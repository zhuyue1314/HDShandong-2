//
//  HDPanoramaViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-23.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDPanoramaViewController.h"
#import "PLView.h"
@interface HDPanoramaViewController ()
@property (nonatomic, retain) IBOutlet PLView *plView;
@end

@implementation HDPanoramaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIToolbar *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    //tool.barStyle = UIBarStyleBlack;
//    [tool setBackgroundImage:[UIImage imageNamed:@"itemNavBar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolButton.frame = CGRectMake(0.0, 20.0, 40.0, 32.0);
    [toolButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [toolButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *toolBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:toolButton];
//    [tool setItems:[NSArray arrayWithObject:toolBarButtonItem]];
    [self.view addSubview:toolButton];
    
    
    self.plView.isDeviceOrientationEnabled = NO;
	self.plView.isAccelerometerEnabled = NO;
	self.plView.isScrollingEnabled = NO;
	self.plView.isInertiaEnabled = NO;
	self.plView.type = PLViewTypeSpherical;
    [self.plView addTexture:[PLTexture textureWithPath:[[NSBundle mainBundle] pathForResource:@"quanjing" ofType:@"png"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
