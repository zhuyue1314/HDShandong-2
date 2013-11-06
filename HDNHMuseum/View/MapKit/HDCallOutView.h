//
//  HDCallOutView.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAnnotation.h"

@class HDMapView;

@interface HDCallOutView : UIView
{
    @private
    HDAnnotation *_annotation;
    HDMapView *_mapView;
}
- (id)initWithAnnotation:(HDAnnotation *)annotation onMap:(HDMapView *)mapView;
- (void)displayAnnotation:(HDAnnotation *)annotation;


@property (nonatomic, strong) HDAnnotation *annotation;
@property (nonatomic, strong) HDMapView    *mapView;
@end
