//
//  HDBroadcast.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-15.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDBroadcast.h"

@implementation HDBroadcast
@synthesize identifier = _identifier;
@synthesize time = _time;
@synthesize title = _title;
@synthesize content = _content;
@synthesize status = _status;

-(void)initWithArray:(NSArray *)array
{
    if ( self)
    {
        for (int i=0; i<[array count]; i++)
        {
            if (i==0)
            {
                self.identifier = [array objectAtIndex:i];
            }
            else if(i==1)
            {
                self.title = [array objectAtIndex:i];
            }
            else if(i==2)
            {
                self.content = [array objectAtIndex:i];
            }
            else if (i==3)
            {
                self.time = [array objectAtIndex:i];
            }
            else
            {
                self.status = @"new";
                return;
            }
        }
    }
}
- (id) initWithCoder: (NSCoder*) coder
{
    self = [super init];
    if (self)
    {
        _identifier = [coder decodeObjectForKey:@"identifier"];
        _title = [coder decodeObjectForKey:@"title"];
        _content = [coder decodeObjectForKey:@"content"];
        _time = [coder decodeObjectForKey:@"time"];
        _status = [coder decodeObjectForKey:@"status"];
    }
    return self;
}
- (void) encodeWithCoder: (NSCoder*) coder
{
    [coder encodeObject:_identifier forKey:@"identifier"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeObject:_time forKey:@"time"];
    [coder encodeObject:_status forKey:@"status"];
}
@end
