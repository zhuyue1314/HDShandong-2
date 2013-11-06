//
//  HDFeedbackViewController.m
//  PomeloKit
//
//  Created by Li Shijie on 13-7-10.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDFeedbackViewController.h"
#import "HDConnectModel.h"
#import "HDDeclare.h"

@interface HDFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telephone;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextView *content;
@end
static HDConnectModel *connect;
static HDDeclare *declare;
@implementation HDFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        connect = [HDConnectModel sharedConnect];
        declare = [HDDeclare sharedDeclare];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = declare.Feedback;
    UIControl *control = [[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view sendSubviewToBack:control];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, 50.0, 29.0);
    //[rightButton setTitle:@"send" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // UITextField
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTelephone:nil];
    [self setEmail:nil];
    [self setContent:nil];
    [super viewDidUnload];
}
-(void)resign
{
    [self.telephone resignFirstResponder];
    [self.email resignFirstResponder];
    [self.content resignFirstResponder];
}
-(void)send
{
    NSString *string = [NSString stringWithFormat:@"SUGGE%@#%@#%@",self.content.text,self.telephone.text,self.email.text];
    NSLog(@"%@",string);
    if ([self.telephone.text isEqualToString:@""]&&[self.email.text isEqualToString:@""]&&[self.content.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                       message:declare.nullcontent
                                                      delegate:nil
                                             cancelButtonTitle:declare.alertOK
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [connect sendContent:string WithTarget:[[HDDeclare sharedDeclare] channel] WithCompleteBlock:^(NSDictionary *result)
        {
         NSLog(@"意见反馈callback%@",result);
            self.telephone.text = @"";
            self.content.text = @"";
            self.email.text = @"";
            [self resign];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:declare.feedbacksuceed
                                                          delegate:self
                                                 cancelButtonTitle:declare.alertOK
                                                 otherButtonTitles:nil, nil];

            [alert show];
        }];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint center = self.view.center;
        self.view.center = CGPointMake(center.x,center.y-150);
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint center = self.view.center;
        self.view.center = CGPointMake(center.x,center.y+150);
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
