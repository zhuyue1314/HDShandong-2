//
//  HDBroadcast.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-15.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDBroadcast : NSObject
@property(strong,nonatomic)NSString *identifier;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSString *time;
@property(strong,nonatomic)NSString *status;
-(void)initWithArray:(NSArray *)array;
@end
