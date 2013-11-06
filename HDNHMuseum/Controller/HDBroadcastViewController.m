//
//  HDBroadcastViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-15.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDBroadcastViewController.h"
#import "HDDeclare.h"

@interface HDBroadcastViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextView *content;

@end
static HDDeclare *declare;
@implementation HDBroadcastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        declare = [HDDeclare sharedDeclare];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.detail;
    self.titleLabel.text = self.item.title;
    self.content.text = [NSString stringWithFormat:@"\t%@",self.item.content] ;
    self.navigationController.navigationBarHidden = NO;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setContent:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

@end
