//
//  HDSeekHelpViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-8-12.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDSeekHelpViewController.h"
#import "HDConnectModel.h"
#import "HDDeclare.h"


@interface HDSeekHelpViewController ()

- (IBAction)helpAction:(UIButton *)sender;
@property(nonatomic,strong)NSString *RFID;
@end
static HDConnectModel *connect;
static HDDeclare *declare;
@implementation HDSeekHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        connect = [HDConnectModel sharedConnect];
        _RFID = @"0";
        declare = [HDDeclare sharedDeclare];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)helpAction:(UIButton *)sender
{
    //qujiu机器号#求助编号#经度#纬度#RFID号#电量#”
    NSString *content = [NSString stringWithFormat:@"qujiu%@#%d#0#0#%@#100#",[[HDDeclare sharedDeclare] userName],sender.tag,self.RFID];
    [connect sendContent:content WithTarget:[[HDDeclare sharedDeclare] channel] WithCompleteBlock:^(NSDictionary *result){
         NSLog(@"求救反馈callback%@",result);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle message:declare.SOSSuceed delegate:nil cancelButtonTitle:declare.alertOK otherButtonTitles:nil, nil];
        [alert show];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.SOS;
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoDemand:)
                                                 name:@"result"
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"result"
                                                 object:nil];
}

-(void)autoDemand:(NSNotification*)notification
{
    NSDictionary *dic = [notification userInfo];
    self.RFID = [dic objectForKey:@"content"];
}
@end
