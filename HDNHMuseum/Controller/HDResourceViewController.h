//
//  HDResourceViewController.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarSDK.h"

#import "HDItemViewController.h"

@interface HDResourceViewController : HDItemViewController<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate,UISearchDisplayDelegate>
{
    ZBarReaderViewController *reader;
}
@property (strong,nonatomic)NSMutableArray *itemArray;
@property(strong,nonatomic)NSMutableArray *resourceArray;
@end
