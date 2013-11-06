//
//  HDAnnotation.m
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDAnnotation.h"

@implementation HDAnnotation
+ (id)annotationWithPoint:(CGPoint)point
{
	return [[[self class] alloc] initWithPoint:point];
}

- (id)initWithPoint:(CGPoint)point {
	self = [super init];
    
	if (nil != self) {
		self.point = point;
	}
    
	return self;
}

@end
