//
//  HDPlayerViewController.h
//  HDDGMuseum
//
//  Created by Li Shijie on 13-4-22.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDItem;

@interface HDPlayerViewController : UIViewController
{
    BOOL       audioPlaying;
    BOOL       videoPlaying;
}
@property(strong,nonatomic)NSMutableArray *itemArray;
-(void)playItem:(HDItem *)item;
@end
