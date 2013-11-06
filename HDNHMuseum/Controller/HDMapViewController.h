//
//  HDMapViewController.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDItemViewController.h"


@interface HDMapViewController : HDItemViewController<UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
-(void)locationWithRFID:(NSString *)number;
@end
