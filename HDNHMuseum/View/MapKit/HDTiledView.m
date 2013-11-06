//
//  HDTiledView.m
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDTiledView.h"
#import "math.h"

static const CGFloat kDefaultTileSizeWidth = 155.0f;
static const CGFloat kDefaultTileSizeHeight = 160.0f;
static const CFTimeInterval kDefaultFadeDuration = 0.08;

@implementation HDTiledLayer
+ (CFTimeInterval)fadeDuration
{
    return kDefaultFadeDuration;
}
@end

@interface HDTiledView ()
- (HDTiledLayer *)tiledLayer;
-(void)annotateRect:(CGRect)rect inContext:(CGContextRef)ctx;//for debug
@end

@implementation HDTiledView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGSize scaledTileSize = CGSizeApplyAffineTransform(self.tileSize, CGAffineTransformMakeScale(self.contentScaleFactor, self.contentScaleFactor));
        self.tiledLayer.tileSize = scaledTileSize;
        //self.tiledLayer.levelsOfDetail = 1;
        //self.numberOfZoomLevels = 3;
        self.shouldAnnotateRect = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (Class)layerClass
{
    return [HDTiledLayer class];
}
- (CGSize)tileSize
{
//    return CGSizeMake(kDefaultTileSize, kDefaultTileSize);
    return CGSizeMake(kDefaultTileSizeWidth, kDefaultTileSizeHeight);
}

- (size_t)numberOfZoomLevels
{
    return self.tiledLayer.levelsOfDetailBias;
}

- (void)setNumberOfZoomLevels:(size_t)levels
{
    self.tiledLayer.levelsOfDetailBias = levels;
}
- (HDTiledLayer *)tiledLayer
{
    return (HDTiledLayer *)self.layer;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat scale = CGContextGetCTM(ctx).a / self.tiledLayer.contentsScale;
    
    NSInteger col = (NSInteger)((CGRectGetMinX(rect) * scale) / self.tileSize.width);
    NSInteger row = (NSInteger)((CGRectGetMinY(rect) * scale) / self.tileSize.height);
    
    UIImage *tile_image = [self.delegate tiledView:self
                                       imageForRow:row
                                            column:col
                                             scale:(NSInteger)scale];
    [tile_image drawInRect:rect];
    [self annotateRect:rect inContext:ctx];
}


-(void)annotateRect:(CGRect)rect inContext:(CGContextRef)ctx
{
//    CGFloat scale = CGContextGetCTM(ctx).a / self.tiledLayer.contentsScale;
//    //NSInteger col = (NSInteger)((CGRectGetMinX(rect) * scale) / self.tileSize.width);
//   // NSInteger row = (NSInteger)((CGRectGetMinY(rect) * scale) / self.tileSize.height);
//    CGFloat line_width = 2.0f / scale;
//   // CGFloat font_size = 16.0f / scale;
//    
//    [[UIColor blackColor] set];
////    [[NSString stringWithFormat:@" %0.0fX_%d_%d", scale,row,col] drawAtPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
////                                                                    withFont:[UIFont boldSystemFontOfSize:font_size]];
//    
//    [[UIColor grayColor] set];
//    CGContextSetLineWidth(ctx, line_width);
//    CGContextStrokeRect(ctx, rect);
}

@end
