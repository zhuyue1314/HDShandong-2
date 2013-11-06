//
//  HDRootSecondView.h
//  HDTianJin
//
//  Created by Li Shijie on 13-9-3.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDRootSecondView;

@protocol HDRootSecondViewDelegate <NSObject>
-(void)rootSecondViewItemTap:(NSInteger)tag;
@end

@interface HDRootSecondView : UIView
{}
@property(nonatomic,assign)id<HDRootSecondViewDelegate>delegate;
-(void)reloadView;
@end
