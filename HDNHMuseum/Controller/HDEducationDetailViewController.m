//
//  HDEducationDetailViewController.m
//  HDNHMuseum
//
//  Created by Liuzhuan on 13-10-29.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDEducationDetailViewController.h"
#import "HDDeclare.h"

@interface HDEducationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
static HDDeclare *declare;
@implementation HDEducationDetailViewController

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
    self.title = self.currentItem.title;
    NSString *stringPah = [NSString stringWithFormat:@"%@/%@",[declare applicationLibraryDirectory],self.currentItem.path];
    if ([[NSFileManager defaultManager]fileExistsAtPath:stringPah])
    {
        NSError *eror;
        NSString *str = [NSString stringWithContentsOfFile:stringPah encoding:NSUTF8StringEncoding error:&eror];
        
        NSString *path = [NSString stringWithFormat:@"%@/education",[declare applicationLibraryDirectory]];
        path = [path stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
        path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",path]];
        //NSLog(@"%@",baseURL);
        [self.webView loadHTMLString:str baseURL:baseURL];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
