//
//  HDAnnotation.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDAnnotation : NSObject
{
    CGPoint   _point;
	NSString *_title;
	NSString *_subtitle;
    NSString *_identify;
	UIButton *_rightCalloutAccessoryView;
}
@property (nonatomic, assign) CGPoint   point;
@property (nonatomic, copy) NSString   *title;
@property (nonatomic, copy) NSString   *subtitle;
@property (nonatomic, copy) NSString   *identify;
@property (nonatomic, strong) UIButton *rightCalloutAccessoryView;

+ (id)annotationWithPoint:(CGPoint)point;
- (id)initWithPoint:(CGPoint)point;
@end
