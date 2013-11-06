//
//  HDSettingViewController.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//


#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "HDItemViewController.h"
@interface HDSettingViewController : HDItemViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{

    ASIHTTPRequest *request;
}
@end
