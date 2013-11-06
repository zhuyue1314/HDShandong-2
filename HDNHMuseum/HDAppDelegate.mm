//
//  HDAppDelegate.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDAppDelegate.h"
#import "HDResourceViewController.h"
#import "HDRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MLNavigationController.h"
#import "HDRootViewController.h"
#import "HDConnectModel.h"
static HDConnectModel *connect;
BMKMapManager *_mapManager;

@implementation HDAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    connect = [HDConnectModel sharedConnect];
    HDRootViewController *rootViewController = [[HDRootViewController alloc]initWithNibName:@"HDRootViewController" bundle:nil];
    
    MLNavigationController *rootNav = [[MLNavigationController alloc]initWithRootViewController:rootViewController];
    
    
    self.window.rootViewController = rootNav;
    
    [self.window makeKeyAndVisible];
    
    _mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"9f6721255121f72fb39f99f7ef1db4b6" generalDelegate:self];
    //    注意：为了给用户提供更安全的服务，iOS SDK自V2.0.2版本开始采用全新的key验证体系。
    //    因此当你选择使用，V2.0.2及以后版本的SDK时，需要到新的key申请页面进行全新key的申请，申请及配置流程请参考开发指南的对应章节。
	if (!ret) {
		NSLog(@"manager start failed!");
	}

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [connect reConnect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"onGetNetworkState %d",iError);
}

- (void)onGetPermissionState:(int)iError
{
    NSLog(@"onGetPermissionState %d",iError);
}


@end
