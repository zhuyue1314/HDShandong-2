//
//  HDRootViewController.h
//  HDTianJin
//
//  Created by Li Shijie on 13-9-2.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRootFirstView.h"
#import "HDRootSecondView.h"
#import "AQRecorder.h"
#import "ZipArchive.h"
#import "MBProgressHUD.h"
@interface HDRootViewController : UIViewController<HDRootViewDelegate,HDRootSecondViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    AQRecorder *recorder;
    MBProgressHUD *progressHUD;
}
@end
