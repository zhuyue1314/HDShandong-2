//
//  HDMapDetailViewController.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-30.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//


#import "HDMapView.h"

@interface HDMapDetailViewController : UIViewController<HDMapViewDelegate,HDMapViewDataSource>
@property(strong,nonatomic)NSString *currentIndex;
@property(strong,nonatomic)NSString *locationNumber;
@property(strong,nonatomic)NSString *friendNumber;
@end
