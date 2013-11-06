//
//  HDAnnotationView.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAnnotation.h"
#import "HDMapView.h"


@interface HDAnnotationView : UIButton
{
    @private
    HDAnnotation *_annotation;
}
- (CGRect)frameForPoint:(CGPoint)point;

- (id)initWithAnnotation:(HDAnnotation *)annotation onView:(HDMapView *)mapView animated:(BOOL)animate;

@property (nonatomic, retain) HDAnnotation *annotation;

@end
