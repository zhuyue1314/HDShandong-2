//
//  Annotation.h
//  HDMapKit
//
//  Created by Li Shijie on 13-5-3.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Annotation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * position;

@end
