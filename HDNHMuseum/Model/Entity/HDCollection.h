//
//  HDCollection.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-1.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HDCollection : NSManagedObject
@property (strong,nonatomic)NSString *identifier;
@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *image;
@property (strong,nonatomic)NSString *desc;
@end
