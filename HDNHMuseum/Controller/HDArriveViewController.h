//
//  HDArriveViewController.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-28.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDItemViewController.h"
#import "BMapKit.h"
@interface HDArriveViewController : HDItemViewController<BMKMapViewDelegate,BMKSearchDelegate>
{
    BMKMapView* mapView;
}
@end
