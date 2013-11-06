//
//  HDSurveyViewController.h
//  PomeloKit
//
//  Created by Li Shijie on 13-7-10.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDSurveyViewController : UIPageViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIAlertViewDelegate>

@property(assign,nonatomic)NSUInteger serveyCount;
@end
