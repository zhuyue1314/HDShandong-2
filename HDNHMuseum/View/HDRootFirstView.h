//
//  HDRootFirstView.h
//  HDTianJin
//
//  Created by Li Shijie on 13-9-3.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDRootFirstView;

@protocol HDRootViewDelegate <NSObject>

-(void)rootViewWithItemTap:(NSInteger)tag;

@end

@interface HDRootFirstView : UIView
{
    
}
@property (nonatomic,assign)id<HDRootViewDelegate>delegate;
-(void)reloadView;
@end
