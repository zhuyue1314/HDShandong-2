//
//  HDStrategyDetailViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-6.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDStrategyDetailViewController.h"

@interface HDStrategyDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textDetail;
@end

@implementation HDStrategyDetailViewController

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
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0, 0.0, 50.0, 29.0);
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.textDetail.text = self.detail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextDetail:nil];
    [super viewDidUnload];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
