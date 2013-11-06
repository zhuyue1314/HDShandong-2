//
//  HDTiledView.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class HDTiledView;

@interface HDTiledLayer : CATiledLayer
@end

@protocol HDTiledViewDelegate <NSObject>

-(UIImage *)tiledView:(HDTiledView *)tiledView
          imageForRow:(NSInteger)row
               column:(NSInteger)column
                scale:(NSInteger)scale;

@end

@interface HDTiledView : UIView
{
}

@property(nonatomic,assign)id <HDTiledViewDelegate>delegate;

@property(nonatomic,readonly)CGSize tileSize;
@property(nonatomic,assign)size_t numberOfZoomLevels;
@property(nonatomic,assign)BOOL shouldAnnotateRect;
//@property(nonatomic,strong)UIImageView *overLineView;
//@property(nonatomic,strong)UIImageView *routeView;
@end
