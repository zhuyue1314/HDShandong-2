//
//  HDNewBroadcastViewController.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-23.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDItemViewController.h"

@interface HDNewBroadcastViewController : HDItemViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *array;
@end
