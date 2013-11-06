//
//  HDItem.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-6.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HDItem : NSManagedObject
@property(nonatomic,retain)NSString *identifier;
@property(nonatomic,retain)NSString *exhibitno;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *image;
@property(nonatomic,retain)NSString *icon;
@property(nonatomic,retain)NSString *audio;
@property(nonatomic,retain)NSString *desc;
@property(nonatomic,retain)NSString *unitno;

@end
