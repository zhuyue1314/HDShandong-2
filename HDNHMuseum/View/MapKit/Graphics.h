//
//  Graphics.h
//  HDMapKit
//
//  Created by Li Shijie on 13-5-3.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Graphics : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * value;

@end
