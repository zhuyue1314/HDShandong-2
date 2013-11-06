//
//  HDUnit.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-10-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HDUnit : NSManagedObject
@property(nonatomic,strong)NSString *identifier;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *number;
@end
