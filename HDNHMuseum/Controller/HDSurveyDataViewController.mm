//
//  HDSurveyDataViewController.m
//  PomeloKit
//
//  Created by Li Shijie on 13-7-10.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDSurveyDataViewController.h"
#import "HDConnectModel.h"
#import "HDDeclare.h"


@interface HDSurveyDataViewController ()
- (IBAction)btnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong,nonatomic) NSString *questionString;

@end
static HDConnectModel *connect;
@implementation HDSurveyDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        connect = [HDConnectModel sharedConnect];
        _questionString = @"\t";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
}
-(void)setIndex:(NSUInteger)index
{
    //_index = 0;
    _index = index;
    NSString *string = [NSString stringWithFormat:@"QUESTCHINESE#%d#",_index+1];
    [connect sendContent:string WithTarget:@"hengda" WithCompleteBlock:^(NSDictionary *result)
     {
         NSLog(@"请求问卷callback%@",result);
         NSString *resultString = [result objectForKey:@"msg"];
         NSArray *resultArray = [resultString componentsSeparatedByString:@"#"];
         for (int i = 0; i<[resultArray count]; i++)
         {
             NSString *component = [resultArray objectAtIndex:i];
             if ([component isEqualToString:@"QUEST"])
                 continue;
             else if ([component isEqualToString:@"END"])
                 break;
             else if([component isEqualToString:@"CHINESE"]||[component isEqualToString:@"ENGLISH"])
                 continue;
             else
             {
                 NSString *stringIndex = @"";
                 if (i == 4)
                 {
                     stringIndex = @"A";
//                     self.questionString = [NSString stringWithFormat:@"%@%@\t%@\n\t",self.questionString,stringIndex,component];
                 }
                 else if (i==5)
                 {
                     stringIndex = @"B";
//                     self.questionString = [NSString stringWithFormat:@"%@%@\t%@\n\t",self.questionString,stringIndex,component];
                 }
                 else if(i==6)
                 {
                     stringIndex = @"C";
//                     self.questionString = [NSString stringWithFormat:@"%@%@\t%@\n\t",self.questionString,stringIndex,component];
                 }
                 else if(i==7)
                 {
                     stringIndex = @"D";
                     
                 }
                 else
                 {
                     self.questionString = [NSString stringWithFormat:@"%@%@\n\t",self.questionString,component];
                     continue;
                 }
                 self.questionString = [NSString stringWithFormat:@"%@%@\t%@\n\t",self.questionString,stringIndex,component];
             }
         }
         self.textView.text = self.questionString;

     }];
    
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
}
- (IBAction)btnAction:(UIButton *)sender
{
    //NSString *tag = [NSString stringWithFormat:@"%d",sender.tag];
    NSString *string = [NSString stringWithFormat:@"wenti%d#%d#CHINESE",self.index+1,sender.tag];
    [connect sendContent:string WithTarget:[[HDDeclare sharedDeclare] channel] WithCompleteBlock:^(NSDictionary *result)
     {
         NSLog(@"发送问卷callback%@",result);
         [[NSNotificationCenter defaultCenter]postNotificationName:@"next" object:self];
         
     }];
}

@end
