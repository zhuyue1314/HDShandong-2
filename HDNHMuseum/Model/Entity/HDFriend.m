//
//  HDFriend.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-20.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDFriend.h"

@implementation HDFriend
@synthesize name = _name;
@synthesize nickName = _nickName;
-(id)init
{
    self = [super init];
    if (self)
    {
        self.name = @"";
        self.nickName = @"";
    }
    return  self;
}
@end
