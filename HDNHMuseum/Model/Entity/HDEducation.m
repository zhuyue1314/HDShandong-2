//
//  HDEducation.m
//  HDNHMuseum
//
//  Created by Liuzhuan on 13-10-29.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDEducation.h"

@implementation HDEducation
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        _title = [dic objectForKey:@"title"];
        _path = [dic objectForKey:@"path"];
        _description = [dic objectForKey:@"description"];
    }
    return self;
}
@end
