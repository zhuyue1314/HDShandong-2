//
//  HDEducation.h
//  HDNHMuseum
//
//  Created by Liuzhuan on 13-10-29.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDEducation : NSObject
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *path;
@property(strong,nonatomic)NSString *description;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
