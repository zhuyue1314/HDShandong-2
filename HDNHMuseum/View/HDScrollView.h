//
//  HDScrollView.h
//  HDNHMuseum
//
//  Created by Liuzhuan on 13-10-28.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HDScrollViewDelegate;
@interface HDScrollView : UIScrollView<UIScrollViewDelegate>
{
//    BOOL scaled;
}
@property(nonatomic,assign)id <HDScrollViewDelegate>hdDelegate;
@property(nonatomic,strong)UIImageView *imageView;
@end

@protocol HDScrollViewDelegate <NSObject>
- (void)HDScrollViewDelegateZoomOut:(HDScrollView *)scrollView;
- (void)HDScrollViewDelegateZoomIn:(HDScrollView *)scrollView;

@end
