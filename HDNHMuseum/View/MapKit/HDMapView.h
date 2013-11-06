//
//  HDMapView.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAnnotation.h"
#import "HDCallOutView.h"

@class HDTiledView,HDMapView;

@protocol HDMapViewDataSource <NSObject>

- (UIImage *)mapView:(HDMapView *)mapView
         imageForRow:(NSInteger)row
              column:(NSInteger)column
               scale:(NSInteger)scale;
@end

@protocol HDMapViewDelegate <NSObject>
@optional
- (void)mapViewDidZoom:(HDMapView *)mapView;
- (void)mapViewDidScroll:(HDMapView *)mapView;
- (void)mapView:(HDMapView *)mapView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)mapView:(HDMapView *)mapView didReceiveDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)mapView:(HDMapView *)mapView didReceiveTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface HDMapView : UIScrollView<UIScrollViewDelegate>
{
    @private
    NSMutableArray *_pinAnnotations;
    CGSize          _orignalSize;
    HDCallOutView  *_callout;
    NSMutableArray *shortPathNodes;
    
}
@property (nonatomic,assign) id<HDMapViewDataSource>dataSource;
@property (nonatomic,assign) id<HDMapViewDelegate> mapViewdelegate;
@property (strong,nonatomic) HDTiledView *tiledView;
@property (nonatomic, assign) size_t levelsOfZoom;
@property (nonatomic, assign) size_t levelsOfDetail;
@property (nonatomic, assign) float zoomScale;
@property (nonatomic, assign) BOOL centerSingleTap;
@property (nonatomic, assign) BOOL zoomsInOnDoubleTap;
@property (nonatomic, assign) BOOL zoomsOutOnTwoFingerTap;
@property (nonatomic, assign) CGSize          orignalSize;
@property (nonatomic, strong) NSMutableArray *pinAnnotations;
@property (nonatomic, strong) HDCallOutView  *callout;
@property (nonatomic, strong) UIView *routeView;
//@property (nonatomic, strong)SVGKImageView *routeView;



+ (Class)tiledLayerClass;
- (id)initWithFrame:(CGRect)frame contentSize:(CGSize)contentSize;
- (void)setContentCenter:(CGPoint)center animated:(BOOL)animated;
- (void)addAnnotation:(HDAnnotation *)annotation animated:(BOOL)animate;
- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate;
- (void)removeAllAnnatations:(BOOL)animate;
- (void)hideCallOut;
- (IBAction)showCallOut:(id)sender;
- (void)update_route_viewWithZomScale:(float)scale;
- (void)addRouteViewWithIndex:(NSString *)aIndex;
- (void)hideRouteView;
- (void)serachPathFrom:(NSString *)from To:(NSString *)to;

- (void)locationPin:(NSString *)number;
- (void)locationMine:(NSString *)myInfo
           andFriend:(NSString *)friendInfo;
@end
