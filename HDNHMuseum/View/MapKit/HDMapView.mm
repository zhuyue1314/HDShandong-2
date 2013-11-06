//
//  HDMapView.m
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDMapView.h"
#import "HDTiledView.h"
#import "HDAnnotationView.h"
#import "HDDijkstra.h"
#define kStandardUIScrollViewAnimationTime (int64_t)0.10
@interface HDMapView ()<HDTiledViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *twoFingerTapGestureRecognizer;
@property (nonatomic, assign) BOOL muteAnnotationUpdates;
@end

@implementation HDMapView
//------------------------------------------------------------------------------
//    + (Class)tiledLayerClass
//------------------------------------------------------------------------------
+ (Class)tiledLayerClass
{
    return [HDTiledView class];
}
- (id)initWithFrame:(CGRect)frame contentSize:(CGSize)contentSize
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = contentSize;
        self.bouncesZoom = YES;
        self.bounces = YES;
        self.minimumZoomScale = 1.0;
        self.levelsOfZoom = 2;
        self.zoomsInOnDoubleTap = YES;
        self.zoomsOutOnTwoFingerTap = YES;
        self.centerSingleTap = YES;
        self.orignalSize = contentSize;
        
        _tiledView = [[[[self class] tiledLayerClass] alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentSize.width, self.contentSize.height)];
        _tiledView.delegate = self;
        [self addSubview:self.tiledView];
        
        _routeView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.contentSize.width, self.contentSize.height)];
        [_tiledView addSubview:self.routeView];
       // [self update_route_view];
        
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(singleTapReceived:)];
        _singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [_tiledView addGestureRecognizer:_singleTapGestureRecognizer];
        
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(doubleTapReceived:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        [_tiledView addGestureRecognizer:_doubleTapGestureRecognizer];
        
        [_singleTapGestureRecognizer requireGestureRecognizerToFail:_doubleTapGestureRecognizer];
        
        _twoFingerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(twoFingerTapReceived:)];
        _twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2;
        _twoFingerTapGestureRecognizer.numberOfTapsRequired = 1;
        [_tiledView addGestureRecognizer:_twoFingerTapGestureRecognizer];
        shortPathNodes = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark - UIScrolViewDelegate

- (UIView *)viewForZoomingInScrollView:(__unused UIScrollView *)scrollView
{
    return self.tiledView;
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView
{

    if ([self.mapViewdelegate respondsToSelector:@selector(mapViewDidZoom:)])
    {
        [self.mapViewdelegate mapViewDidZoom:self];
    }
}

- (void)scrollViewDidScroll:(__unused UIScrollView *)scrollView
{
    //[self update_route_view];
    if ([self.mapViewdelegate respondsToSelector:@selector(mapViewDidScroll:)])
    {
        [self.mapViewdelegate mapViewDidScroll:self];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   // NSLog(@"scrollViewDidEndScrollingAnimation");
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    float a= scrollView.zoomScale;
    NSLog(@"zoomScale:%f",a);
   // [self update_route_viewWithZomScale:self.zoomScale];
//    NSLog(@"W:%f,H:%f",self.contentSize.width,self.contentSize.height);
//    size_t width = self.contentSize.width;
//    size_t height = self.contentSize.height;
//     NSLog(@"W:%zu,H:%zu",width,height);
}
#pragma mark - Gesture Suport

- (void)singleTapReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.centerSingleTap)
    {
        [self setContentCenter:[gestureRecognizer locationInView:self.tiledView]
                      animated:YES];
    }
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapView:didReceiveSingleTap:)])
    {
        [self.mapViewdelegate mapView:self
                  didReceiveSingleTap:gestureRecognizer];
    }
}

- (void)doubleTapReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.zoomsInOnDoubleTap)
    {
        float newZoom = MIN(powf(2, (log2f(self.zoomScale) + 1.0f)), self.maximumZoomScale); //zoom in one level of detail
        
        self.muteAnnotationUpdates = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kStandardUIScrollViewAnimationTime * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setMuteAnnotationUpdates:NO];
        });
        
        [self setZoomScale:newZoom animated:YES];
    }
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapView:didReceiveDoubleTap:)])
    {
        [self.mapViewdelegate mapView:self
                  didReceiveDoubleTap:gestureRecognizer];
    }
}

- (void)twoFingerTapReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.zoomsOutOnTwoFingerTap)
    {
        float newZoom = MAX(powf(2, (log2f(self.zoomScale) - 1.0f)), self.minimumZoomScale); //zoom out one level of detail
        
        self.muteAnnotationUpdates = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kStandardUIScrollViewAnimationTime * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setMuteAnnotationUpdates:NO];
        });
        
        [self setZoomScale:newZoom animated:YES];
    }
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapView:didReceiveTwoFingerTap:)])
    {
        [self.mapViewdelegate mapView:self
               didReceiveTwoFingerTap:gestureRecognizer];
    }
}

#pragma mark - HDMapView


- (void)setLevelsOfZoom:(size_t)levelsOfZoom
{
    _levelsOfZoom = levelsOfZoom;
    self.maximumZoomScale = (float)powf(2.0f, MAX(0.0f, levelsOfZoom));
}

- (void)setLevelsOfDetail:(size_t)levelsOfDetail
{
    if (levelsOfDetail == 1) NSLog(@"Note: Setting levelsOfDetail to 1 causes strange behaviour");
    
    _levelsOfDetail = levelsOfDetail;
    [self.tiledView setNumberOfZoomLevels:levelsOfDetail];
}

- (void)setContentCenter:(CGPoint)center animated:(BOOL)animated
{
    CGPoint new_contentOffset = self.contentOffset;
    
    if (self.contentSize.width > self.bounds.size.width)
    {
        new_contentOffset.x = MAX(0.0f, (center.x * self.zoomScale) - (self.bounds.size.width / 2.0f));
        new_contentOffset.x = MIN(new_contentOffset.x, (self.contentSize.width - self.bounds.size.width));
    }
    
    if (self.contentSize.height > self.bounds.size.height)
    {
        new_contentOffset.y = MAX(0.0f, (center.y * self.zoomScale) - (self.bounds.size.height / 2.0f));
        new_contentOffset.y = MIN(new_contentOffset.y, (self.contentSize.height - self.bounds.size.height));
    }
    [self setContentOffset:new_contentOffset animated:animated];
}

- (void)addAnnotation:(HDAnnotation *)annotation animated:(BOOL)animate {
	 HDAnnotationView *pinAnnotation = [[HDAnnotationView alloc] initWithAnnotation:annotation
                                                                             onView:self
                                                                           animated:animate];
    
	if (!_pinAnnotations) {
		_pinAnnotations = [[NSMutableArray alloc] init]; 
	}
    
	[self.pinAnnotations addObject:pinAnnotation];
	[self addObserver:pinAnnotation
           forKeyPath:@"contentSize"
              options:NSKeyValueObservingOptionNew
              context:nil];
	//[pinAnnotation release];
}

- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate
{
	for (HDAnnotation *annotation in annotations)
    {
		[self addAnnotation:annotation animated:animate];
	}
}

- (IBAction)showCallOut:(id)sender {
	for (HDAnnotationView *pin in self.pinAnnotations) {
		if (pin == sender) {
			if (!self.callout) {
				// create the callout
                HDCallOutView * calloutView = [[HDCallOutView alloc] initWithAnnotation:pin.annotation
                                                                                  onMap:self];
				self.callout = calloutView;
                //[calloutView release];
                
				[self addObserver:self.callout
                       forKeyPath:@"contentSize"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
				[self addSubview:self.callout];
			}	else {
				[self hideCallOut];
				[self.callout displayAnnotation:pin.annotation];
			}
            [self setContentCenter:pin.annotation.point animated:YES];
			break;
		}
	}
}

- (void)hideCallOut {
	self.callout.hidden = YES;
}
- (void)removeAnnatation:(HDAnnotationView *)annotation animated:(BOOL)animate
{
    [annotation removeFromSuperview];
    [self removeObserver:annotation forKeyPath:@"contentSize"];
}
- (void)removeAllAnnatations:(BOOL)animate
{
    for (HDAnnotationView *annotation in _pinAnnotations)
    {
        [self removeAnnatation:annotation animated:animate];
    }
    [self.pinAnnotations removeAllObjects];
    [self hideCallOut];
    [self setZoomScale:1 animated:YES];
}
- (void)locationPin:(NSString *)number
{
    for (int i = 0; i< [[self subviews] count]; i++)
    {
        UIView *view = [[self subviews]objectAtIndex:i];
        if ([view isKindOfClass:[HDAnnotationView class]])
        {
            HDAnnotationView *temp = (HDAnnotationView *)view;
            if ([temp.annotation.identify intValue] == [number intValue])
            {
                [temp setImage:[UIImage imageNamed:@"pinRed.png"] forState:UIControlStateNormal];
            }
            else
            {
                [temp setImage:[UIImage imageNamed:@"pinPurple.png"] forState:UIControlStateNormal];
            }
        }
    }

}
- (void)locationMine:(NSString *)myInfo
           andFriend:(NSString *)friendInfo
{
    for (int i = 0; i< [[self subviews] count]; i++)
    {
        UIView *view = [[self subviews]objectAtIndex:i];
        if ([view isKindOfClass:[HDAnnotationView class]])
        {
            HDAnnotationView *temp = (HDAnnotationView *)view;
            if ([temp.annotation.identify intValue] == [myInfo intValue])
            {
                [temp setImage:[UIImage imageNamed:@"pinRed.png"] forState:UIControlStateNormal];
            }
            else if ([temp.annotation.identify intValue] == [friendInfo intValue])
            {
                [temp setImage:[UIImage imageNamed:@"pinGreen.png"] forState:UIControlStateNormal];
            }
            else
            {
                [temp setImage:[UIImage imageNamed:@"pinPurple.png"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.dragging) {
		[self hideCallOut];
	}
    
	[super touchesEnded:touches withEvent:event];
}


#pragma mark - HDTiledViewDelegate

- (UIImage *)tiledView:(__unused HDTiledView *)tiledView
           imageForRow:(NSInteger)row
                column:(NSInteger)column
                 scale:(NSInteger)scale
{
    return [self.dataSource  mapView:self
                         imageForRow:row
                              column:column
                               scale:scale];
}

-(void)update_route_viewWithZomScale:(float)scale
{
    
    //int scaleInfo = 2;
//    if (scale<2.0)
//    {
//        scaleInfo = 2;
//    }
//    else if (scale>2&&scale<=4)
//    {
//        scaleInfo = 4;
//    }
//    else
//    {
//        scaleInfo = 1;
//    }
//
//    NSLog(@"scaleInfo:%d",scaleInfo);
    //UIGraphicsBeginImageContext(self.routeView.frame.size);
    NSArray *array = [self.routeView subviews];
    for (UIView *view in array)
    {
        [view removeFromSuperview];
    }
    for (int i = 1; i < [shortPathNodes count]; i++)
    {
        NSString *from = [shortPathNodes objectAtIndex:i-1];
        NSString *to = [shortPathNodes objectAtIndex:i];
        NSString *line = [NSString stringWithFormat:@"%@_%@.png",from,to];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.routeView.frame];
        imageView.image = [UIImage imageNamed:line];
        [self.routeView addSubview:imageView];
       // [image drawInRect:self.frame];
    }

   // UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
   // UIGraphicsEndImageContext();
    //self.routeView.image = resultImage;
//    size_t width = self.contentSize.width;
//    size_t height = self.conten tSize.height;
//    
//    CGContextRef context = CGBitmapContextCreate(nil,
//                                                 width,
//                                                 height ,
//                                                 8,
//                                                 4*width,
//                                                 CGColorSpaceCreateDeviceRGB(),
//                                                 kCGImageAlphaPremultipliedLast);
//    UIColor *color = [UIColor blueColor];
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGContextSetRGBFillColor(context, 0, 1, 1, 1);
//    CGContextSetLineWidth(context, 4.0);
//    CGContextSetLineCap(context, kCGLineCapButt);
//
//    for (int i = 0; i < [shortPathNodes count]; i++)
//    //for (int i = 0; i < [self.pinAnnotations count]; i++)
//    {
//        int n = [[shortPathNodes objectAtIndex:i]intValue];
//        HDAnnotationView *annotationView = [self.pinAnnotations objectAtIndex:n-1];
//        CGPoint point = CGPointMake(annotationView.frame.origin.x+7, annotationView.frame.origin.y+35);
//        if (i == 0)
//        {
//            CGContextMoveToPoint(context, point.x,height - point.y);
//            
//        }
//        else
//        {
//            CGContextAddLineToPoint(context, point.x,height - point.y);
//        }
//        
//    }
//    CGContextStrokePath(context);
//    CGImageRef image = CGBitmapContextCreateImage(context);
//    UIImage *img = [UIImage imageWithCGImage:image];
//    CGImageRelease(image);
//    self.routeView.image = img;
//    CGContextRelease(context);
    
}
- (void)serachPathFrom:(NSString *)from To:(NSString *)to
{
    HDDijkstra *dijkstra = [[HDDijkstra alloc]initWithPath:nil];
    if ([shortPathNodes count])
    {
        [shortPathNodes removeAllObjects];
    }
    [shortPathNodes addObjectsFromArray:[dijkstra shortestPathFrom:[from intValue] to:[to intValue]]];
    [self update_route_viewWithZomScale:self.zoomScale];
}
-(void)dealloc
{
    if (self.callout) {
		[self removeObserver:self.callout forKeyPath:@"contentSize"];
	}
    
	if (_pinAnnotations) {
		for (HDAnnotation *annotation in _pinAnnotations) {
			[self removeObserver:annotation forKeyPath:@"contentSize"];
		}
	}
}
- (void)addRouteViewWithIndex:(NSString *)aIndex
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.routeView.frame];
    imageView.image = [UIImage imageNamed:aIndex];
    [self.routeView addSubview:imageView];
    //self.routeView.hidden = NO;
}
- (void)hideRouteView
{
    if (self.routeView.hidden)
    {
        self.routeView.hidden = NO;
    }
    else
    {
        self.routeView.hidden = YES;
    }
}
@end
