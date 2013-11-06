//
//  HDRootViewController.m
//  HDTianJin
//
//  Created by Li Shijie on 13-9-2.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDRootViewController.h"
#import "HDMapViewController.h"
#import "HDUnitViewController.h"
#import "HDReceivedADViewController.h"
#import "HDSeekHelpViewController.h"
#import "HDStrategyViewController.h"
#import "HDintroductionViewController.h"
#import "HDSettingViewController.h"
#import "HDFriendsViewController.h"
#import "HDMyMessageViewController.h"
#import "HDConnectModel.h"
#import "HDFeedbackViewController.h"
#import "HDSurveyViewController.h"
#import "HDPanoramaViewController.h"
#import "HDNewBroadcastViewController.h"
#import "HDDeclare.h"
#import "HDBroadcast.h"
#import "ASIHTTPRequest.h"
#import "HDEducationViewController.h"
#import "TBXML+HTTP.h"
#import "TBXML.h"

@interface HDRootViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
- (IBAction)seekHelp:(UIButton *)sender;
- (IBAction)settingAction:(UIButton *)sender;
- (IBAction)myMessage:(UIButton *)sender;
- (IBAction)newBroadcast:(UIButton *)sender;
@property(nonatomic,strong)NSMutableArray *newsArray;
@property (weak, nonatomic) IBOutlet UIImageView *newsBackground;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property(strong,nonatomic)  NSMutableDictionary *items;

@end
static HDConnectModel *connect;
static HDDeclare *declare;
@implementation HDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        connect = [HDConnectModel sharedConnect];
        declare = [HDDeclare sharedDeclare];
        
        recorder = new AQRecorder();
        _newsArray = [NSMutableArray arrayWithCapacity:0];
        _items = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"]==nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"first" forKey:@"first"];
        NSString *resource = [[NSBundle mainBundle]pathForResource:@"builtIn" ofType:@"zip"];
        progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:progressHUD];
        progressHUD.delegate = self;
        progressHUD.labelText = declare.instralling;
        [progressHUD showAnimated:YES whileExecutingBlock:^{
            NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
            ZipArchive* za = [ZipArchive new];
            [za UnzipOpenFile: resource];
            if ([za UnzipFileTo: directoryPath overWrite: YES])
            {
                HDBroadcast *item = [[HDBroadcast alloc]init];
                item.title = @"系统通知";
                item.identifier = @"default";
                item.content = @"您好！欢迎使用山东美术馆智慧服务系统！";
                item.status = @"new";
                item.time = @"0";
                
                NSArray *array = [NSArray arrayWithObjects:item,nil];
                
                NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[declare applicationLibraryDirectory]];
                
                NSMutableData *receiveData = [[NSMutableData alloc] init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                             initForWritingWithMutableData:receiveData];
                
                [archiver encodeObject:array forKey:@"receiveAD"];
                [archiver finishEncoding];
                
                if ([receiveData writeToFile: path atomically: YES])
                {
                   [self fetchNews];
                }
                
            }
            
        }];
        
        
    }
    [[UIApplication sharedApplication] setStatusBarHidden: NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"itemNavBar"] forBarMetrics:UIBarMetricsDefault];
    self.rootScrollView.backgroundColor = [UIColor clearColor];
    [self.rootScrollView setContentSize:CGSizeMake(640, self.rootScrollView.frame.size.height)];
    
    HDRootFirstView *firstView = [[HDRootFirstView alloc]initWithFrame:CGRectMake(0, 25, 320, self.rootScrollView.frame.size.height)];
    firstView.delegate = self;
    firstView.tag = 1001;
    [self.rootScrollView addSubview:firstView];
    
    HDRootSecondView *secondView = [[HDRootSecondView alloc]initWithFrame:CGRectMake(320, 25, 320, self.rootScrollView.frame.size.height)];
    secondView.delegate = self;
    secondView.tag = 1002;
    [self.rootScrollView addSubview:secondView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchNews) name:@"news" object:nil];
     recorder->StartRecord();
    [self versionInfo];
    [self educationInfo];
}
-(void)educationInfo
{
    if ([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        declare.downloadAddress = declare.LANDownloadAddress;
    }
    else
    {
        declare.downloadAddress =declare.netDownloadAddress;
    }
    NSString *resourcePath = [NSString stringWithFormat:@"%@/education/education.zip",[declare applicationLibraryDirectory]];
    NSString *downloadPath = [NSString stringWithFormat:@"http://%@/EDUCATION/IOS.zip",declare.downloadAddress];
    ASIBasicBlock completeBlock = ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath])
        {
            ZipArchive* za = [ZipArchive new];
            [za UnzipOpenFile: resourcePath];
            if ([za UnzipFileTo: [resourcePath stringByDeletingLastPathComponent] overWrite: YES])
            {
//                NSError *error;
//                [[NSFileManager defaultManager]removeItemAtPath:resourcePath
//                                                          error:&error];
            }
        }

    };
    [self downloadWithPath:downloadPath To:resourcePath CompletionBlock:completeBlock];
}
-(void)versionInfo
{
    if ([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        declare.downloadAddress = declare.LANDownloadAddress;
    }
    else
    {
        declare.downloadAddress =declare.netDownloadAddress;
    }
    NSArray *navPointArray = [NSArray arrayWithObjects:@"version",@"sqlversion",@"deleres",@"url",@"sqlurl",nil];

    NSString *versionPath = [NSString stringWithFormat:@"http://%@/VERSION/IOS.xml",declare.downloadAddress];
    NSString *resourcePath = [NSString stringWithFormat:@"%@/version.xml",[declare applicationLibraryDirectory]];
    
    
    ASIBasicBlock completeBlock = ^{
        NSData *data = [NSData dataWithContentsOfFile:resourcePath];
        NSError *error;
        TBXML *xml = [TBXML tbxmlWithXMLData: data error:&error];
        TBXMLElement *root = xml.rootXMLElement;
        while (![[TBXML elementName:root] isEqualToString:@"update"])
        {
            root = root->firstChild;
            if (!root->currentChild)
            {
                NSLog(@"XML is NULL!");
                return;
            }
        }
        if(root)
        {
            while (root)
            {
                int i = [navPointArray count];
                TBXMLElement *p[i];
                
                for (int j = 0;j<i;j++)
                {
                    p[j] = [TBXML childElementNamed:[navPointArray objectAtIndex:j]
                                      parentElement:root];
                    NSLog(@"%@",[TBXML textForElement:p[j]]);
                    [self.items setValue:[TBXML textForElement:p[j]]
                                  forKey:[navPointArray objectAtIndex:j]];
                    
                }
                root = root->nextSibling;
            }
        }
        
        if ([[self.items objectForKey:@"version"]floatValue]>[declare.appVersion floatValue])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:declare.NewVersions
                                                          delegate:self
                                                 cancelButtonTitle:declare.alertCancel
                                                 otherButtonTitles:declare.alertOK, nil];
            alert.tag = 2001;
            [alert show];
            return;
        }
        if([[self.items objectForKey:@"sqlversion"]floatValue]>[declare.dataBaeVersion floatValue])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:declare.NewDatabase
                                                          delegate:self
                                                 cancelButtonTitle:declare.alertCancel
                                                 otherButtonTitles:declare.alertOK, nil];
            alert.tag = 2002;
            [alert show];
        }
        NSLog(@"items:%@",self.items);
    };
    
    [self downloadWithPath:versionPath To:resourcePath CompletionBlock:completeBlock];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self fetchNews];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:@"news" object:nil];
    recorder->StopRecord();
    delete recorder;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    HDRootFirstView *first = (HDRootFirstView *)[self.rootScrollView viewWithTag:1001];
    [first reloadView];
    
    HDRootSecondView *second = (HDRootSecondView *)[self.rootScrollView viewWithTag:1002];
    [second reloadView];
}

-(void)fetchNews
{
    NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[[HDDeclare sharedDeclare]applicationLibraryDirectory]];
    
    NSMutableData *data = [[NSMutableData alloc]
                           initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                     initForReadingWithData:data];
    NSArray *array = [unarchiver decodeObjectForKey:@"receiveAD"];
    [unarchiver finishDecoding];
    [self.newsArray removeAllObjects];
    for (int i = 0; i<[array count]; i++)
    {
        HDBroadcast *temp =[array objectAtIndex:i];
        if ([temp.status isEqualToString:@"new"])
        {
            [self.newsArray addObject:temp];
        }
    }
    NSInteger i=[self.newsArray count];
    if (i)
    {
        self.newsBackground.hidden = NO;
        self.newsLabel.hidden = NO;
        self.newsLabel.text = [NSString stringWithFormat:@"%d",i];
    }
    else
    {
        self.newsBackground.hidden = YES;
        self.newsLabel.hidden = YES;
        self.newsLabel.text = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setRootScrollView:nil];
    [self setNewsLabel:nil];
    [self setNewsBackground:nil];
    [super viewDidUnload];
}

-(void)rootViewWithItemTap:(NSInteger)tag
{
    if (tag==101)
    {
        HDintroductionViewController *introduce = [[HDintroductionViewController alloc]initWithNibName:@"HDintroductionViewController" bundle:nil];
        [self.navigationController pushViewController:introduce animated:YES];
    }
    else if (tag == 102)
    {
        if (declare.netStatus)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:declare.Interaction
                                                                    delegate:self
                                                           cancelButtonTitle:declare.alertCancel
                                                      destructiveButtonTitle:declare.Questionnaire otherButtonTitles:declare.Feedback,nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [actionSheet showFromRect:CGRectMake(0, 200, 320, 200) inView:self.view animated:YES];
        }
        else
        {
            UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:declare.downloadFailed
                                                          delegate:nil
                                                 cancelButtonTitle:declare.alertOK
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else if (tag == 103)
    {
        HDReceivedADViewController *received = [[HDReceivedADViewController alloc]initWithNibName:@"HDReceivedADViewController" bundle:nil];
        [self.navigationController pushViewController:received animated:YES];
    }
    else if (tag == 104)
    {
        if (declare.netStatus)
        {
            HDFriendsViewController *friendsViewController = [[HDFriendsViewController alloc]initWithNibName:@"HDFriendsViewController" bundle:nil];
            [self.navigationController pushViewController:friendsViewController animated:YES];
        }
        else
        {
            UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:declare.downloadFailed
                                                          delegate:nil
                                                 cancelButtonTitle:declare.alertOK
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if (tag == 105)
    {
        HDEducationViewController *educationViewController = [[HDEducationViewController alloc]initWithNibName:@"HDEducationViewController" bundle:nil];
        [self.navigationController pushViewController:educationViewController animated:YES];
    }
    else if (tag == 106)
    {
        HDMapViewController *map = [[HDMapViewController alloc]initWithNibName:@"HDMapViewController" bundle:nil];
        [self.navigationController pushViewController:map animated:YES];
    }
    else if (tag == 107)
    {
        HDUnitViewController *resource = [[HDUnitViewController alloc]initWithNibName:@"HDUnitViewController" bundle:nil];
        [self.navigationController pushViewController:resource animated:YES];
    }
}
-(void)rootSecondViewItemTap:(NSInteger)tag
{
    if (tag == 201)
    {
        HDPanoramaViewController *p = [[HDPanoramaViewController alloc]initWithNibName:@"HDPanoramaViewController" bundle:nil];
        [self presentViewController:p animated:YES completion:nil];
    }
    else if(tag == 202)
    {
        HDStrategyViewController *strategyViewController = [[HDStrategyViewController alloc]initWithNibName:@"HDStrategyViewController" bundle:nil];
        [self.navigationController pushViewController:strategyViewController animated:YES];
    }
    else
    {
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"提示" message:@"正在建设中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}
- (IBAction)seekHelp:(UIButton *)sender {
    if ([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        HDSeekHelpViewController *seekHelpViewController = [[HDSeekHelpViewController alloc]initWithNibName:@"HDSeekHelpViewController" bundle:nil];
        [self.navigationController pushViewController:seekHelpViewController animated:YES];
    }
    else
    {
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:declare.alertTitle
                                                       message:declare.outsideService
                                                      delegate:nil
                                             cancelButtonTitle:declare.alertOK
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
- (IBAction)settingAction:(UIButton *)sender
{
    HDSettingViewController *settingViewController = [[HDSettingViewController alloc]initWithNibName:@"HDSettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (IBAction)myMessage:(UIButton *)sender {
    HDMyMessageViewController *myMessage = [[HDMyMessageViewController alloc]initWithNibName:@"HDMyMessageViewController" bundle:nil];
    
    [self.navigationController pushViewController:myMessage animated:YES];
    
}

- (IBAction)newBroadcast:(UIButton *)sender
{
    if ([self.newsArray count])
    {
        HDNewBroadcastViewController *newBroadcastViewController = [[HDNewBroadcastViewController alloc]initWithNibName:@"HDNewBroadcastViewController" bundle:nil];
        [newBroadcastViewController.array addObjectsFromArray: self.newsArray];
        [self.navigationController pushViewController:newBroadcastViewController animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                       message:declare.noMessage
                                                      delegate:nil
                                             cancelButtonTitle:declare.alertOK
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
   
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSString *content = @"QUNUMChinese#";
        [connect sendContentAlert:content WithTarget:@"hengda" WithCompleteBlock:^(NSDictionary *result)
         {
             NSLog(@"%@",result);
             NSString *num = [result objectForKey:@"msg"];
             if ([num intValue])
             {
                 HDSurveyViewController *surveyViewController = [[HDSurveyViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
                 surveyViewController.serveyCount = [num intValue];
                 [self.navigationController pushViewController:surveyViewController
                                                      animated:YES];
             }
         }];

    }
    else if(buttonIndex==1)
    {
        HDFeedbackViewController *feedbackViewController = [[HDFeedbackViewController alloc]initWithNibName:@"HDFeedbackViewController" bundle:nil];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==1)
    {
        if (alertView.tag == 2001)
        {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/duo-na-xue-ying-yu-wan-sheng-jie/id723243048?mt=8"]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[self.items objectForKey:@"url"]]];
            
        }
        else if (alertView.tag == 2002)
        {
            if ([[self.items objectForKey:@"deleres"]isEqualToString:@"YES"])
            {
                NSString *chinesePath = [NSString stringWithFormat:@"%@/Chinese",[declare applicationLibraryDirectory]];
                NSString *englishPath = [NSString stringWithFormat:@"%@/English",[declare applicationLibraryDirectory]];
                [self removeContentsAtPath:chinesePath];
                [self removeContentsAtPath:englishPath];
                
            }
            ASIBasicBlock completeBlock = ^{
                [declare upadteDataVersion:[self.items objectForKey:@"sqlversion"]];
            };
            NSString *download = [NSString stringWithFormat:@"%@/HDNHMuseum.sqlite",[declare applicationLibraryDirectory]];
            [self downloadWithPath:[self.items objectForKey:@"sqlurl"] To:download CompletionBlock:completeBlock];
        }
    }
}
-(void)downloadWithPath:(NSString *)from To:(NSString *)To CompletionBlock:(ASIBasicBlock)aCompletionBlock
{
    NSURL *url = [NSURL URLWithString:from];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:@"Conn=HengdaClient" forKey:NSHTTPCookieValue];
    [properties setValue:@"ASIHTTPRequestTestCookie" forKey:NSHTTPCookieName];
    [properties setValue:@".dreamingwish.com" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/asi-http-request/tests" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties] ;
    [request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    [request setCompletionBlock:aCompletionBlock];
    [request setDownloadDestinationPath:To];
    [request startAsynchronous];
    [request setFailedBlock:^{
        NSLog(@"failed%@",from);
    }];
}
-(void)removeContentsAtPath:(NSString *)path
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:filename] error:nil];
    }

}
@end
