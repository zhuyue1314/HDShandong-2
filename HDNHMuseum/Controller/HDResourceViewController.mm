//
//  HDResourceViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDResourceViewController.h"
#import "HDItem.h"
#import "HDDeclare.h"
#import "HDPlayerViewController.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"
#import "MBProgressHUD.h"
#import <math.h>
static HDDeclare *declare;

@interface HDResourceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
- (IBAction)QRAction:(UIButton *)sender;
-(void)autoDemand:(NSNotification*)notification;
-(void)push:(NSString *)number;
@property(nonatomic)BOOL autoing;
@property(strong,nonatomic)ASIHTTPRequest *request;

@property (strong,nonatomic)HDPlayerViewController *playerViewController;
@property (strong,nonatomic)NSArray *searchResults;
@end
@implementation HDResourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _autoing = YES;
        _itemArray = [NSMutableArray arrayWithCapacity:0];
        _resourceArray = [NSMutableArray arrayWithCapacity:0];
        declare = [HDDeclare sharedDeclare];
        _playerViewController = [[HDPlayerViewController alloc]initWithNibName:@"HDPlayerViewController" bundle:nil];
        reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsZBarControls = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, 50.0, 29.0);
    [rightButton setImage:[UIImage imageNamed:@"QRCode.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(QRAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.itemTableView.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"background928"]];
    self.itemTableView.backgroundView = tableBackgroundView;
    
//    UIToolbar *tool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [tool setBackgroundImage:[UIImage imageNamed:@"itemNavBar.png"] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolButton.frame = CGRectMake(0.0, 20.0, 40.0, 32.0);
    [toolButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [toolButton addTarget:self action:@selector(QRBack) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *toolBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:toolButton];
    //[tool setItems:[NSArray arrayWithObject:toolBarButtonItem]];
    [reader.view addSubview:toolButton];

    self.searchDisplayController.searchBar.keyboardType = UIKeyboardTypeNumberPad;
    self.searchDisplayController.searchBar.placeholder = @"请输入展品编号";
    self.searchDisplayController.searchResultsDataSource = self.itemTableView.dataSource;

}
-(void)viewWillAppear:(BOOL)animated
{
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)QRAction:(UIButton *)sender
{
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self.navigationController presentViewController:reader animated: YES completion:nil];
}
-(void)QRBack
{
    [reader dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setItemTableView:nil];
    [super viewDidUnload];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.itemTableView)
    {
         return [self.itemArray count];
    }
    else
    {
        return [self.searchResults count];
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"itemCellSelected"]];
        cell.selectedBackgroundView = image;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (tableView==self.itemTableView)
    {
        HDItem *item = [self.itemArray objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"展品编号:%@",item.exhibitno];
        NSString *iconPath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.icon];
        if ([[NSFileManager defaultManager] fileExistsAtPath:iconPath])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:iconPath];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"cellIIcon"];
        }
        
    }
    else
    {
        HDItem *item = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"展品编号:%@",item.exhibitno];
        NSString *iconPath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.icon];
        if ([[NSFileManager defaultManager] fileExistsAtPath:iconPath])
        {
            cell.imageView.image = [UIImage imageWithContentsOfFile:iconPath];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"cellIIcon"];
        }
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDItem *item;
    if (tableView==self.itemTableView)
    {
        item = [self.itemArray objectAtIndex:indexPath.row];
    }
    else
    {
        item = [self.searchResults objectAtIndex:indexPath.row];
    }
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.audio];
    if ([[NSFileManager defaultManager]fileExistsAtPath:resourcePath])
    {
        self.playerViewController.itemArray = self.itemArray;
        [self.navigationController pushViewController:self.playerViewController animated:YES];
        [self.playerViewController playItem:item];
      
    }
    else
    {
        self.autoing = NO;
        [self fetchResourceWithItem:item];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
//------------------------------------------------------------------------------
//    - (void) imagePickerController: (UIImagePickerController*) reader
//     didFinishPickingMediaWithInfo: (NSDictionary*) info
//------------------------------------------------------------------------------
- (void) imagePickerController: (UIImagePickerController*) picker
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissViewControllerAnimated: YES completion:^{
        NSNumber *number = [NSNumber numberWithInt:[symbol.data intValue]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:number forKey:@"content"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"result"
                                                            object:nil
                                                          userInfo:dic];
    }];
}
-(void)push:(NSString *)number
{
    if ([self.navigationController.topViewController isKindOfClass:[HDPlayerViewController class]])
    {
        return;
    }
    BOOL playFlag = NO;
    for (int i=0; i<[self.resourceArray count]; i++)
    {
        HDItem *item = [self.resourceArray objectAtIndex:i];
        if ([number intValue]==[item.identifier intValue])
        {
            NSString *resourcePath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.audio];
            if ([[NSFileManager defaultManager]fileExistsAtPath:resourcePath])
            {

                playFlag = YES;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue,^{
                    self.playerViewController.itemArray = self.resourceArray;
                    [self.navigationController pushViewController:self.playerViewController animated:YES];
                    [self.playerViewController playItem:item];
                });
            }
            else
            {
                self.autoing = NO;
                [self fetchResourceWithItem:item];
            }
            return;
        }
    }
    if (playFlag==NO)
    {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue,^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有这个展品编号" message:number delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];            
        });
    }
    
}
-(void)fetchResourceWithItem:(HDItem *)aItem
{
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@/%@.zip",[declare applicationLibraryDirectory],declare.language,aItem.identifier];
    if ([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        declare.downloadAddress = declare.LANDownloadAddress;
    }
    else
    {
        declare.downloadAddress =declare.netDownloadAddress;
    }
    NSString *zipPath = [NSString stringWithFormat:@"http://%@/IOS/%@/%@.zip",declare.downloadAddress,[declare.language uppercaseString],aItem.identifier];
    NSURL *url = [NSURL URLWithString:zipPath];
    __block MBProgressHUD *progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.view addSubview:progressHUD];
    __block unsigned long long downloadedBytes = 0;
    // progressHUD.delegate = self;
    progressHUD.labelText = declare.downloading;
    [progressHUD setMode:MBProgressHUDModeDeterminate];
    progressHUD.taskInProgress = YES;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 80, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    //[progressHUD addSubview:cancelButton];
    
    self.request = [ASIHTTPRequest requestWithURL:url];
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:@"Conn=HengdaClient" forKey:NSHTTPCookieValue];
    [properties setValue:@"ASIHTTPRequestTestCookie" forKey:NSHTTPCookieName];
    [properties setValue:@".dreamingwish.com" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/asi-http-request/tests" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties] ;
    [self.request setUseCookiePersistence:NO];
    [self.request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    
    [self.request setFailedBlock:^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:declare.downloadFailed
                                                          delegate:nil
                                                 cancelButtonTitle:declare.alertOK
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        [progressHUD hide:YES];
    }];
    [self.request  setDownloadSizeIncrementedBlock:^(long long size)
    {
        NSLog(@"setDownloadSizeIncrementedBlock%lld",size);
        float total = size/1000;
        NSString *string = [NSString stringWithFormat:@"%@ 大小:%.1fK",declare.downloading,total];
        if (total==0)
        {
            progressHUD.labelText = @"暂无讲解";
        }
        else
        {
            progressHUD.labelText = string;
        }
        
    }];
    [self.request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total)
     {
         downloadedBytes += size;
         CGFloat progressPercent = (CGFloat)downloadedBytes/total;
         progressHUD.progress = progressPercent;
         //NSLog(@"setBytesReceivedBlock%lld",total);
     }];
    __block __weak HDResourceViewController *unit = self;
    [self.request setCompletionBlock:^{
        if ([progressHUD.labelText isEqualToString:@"暂无讲解"])
        {
            [progressHUD hide:YES];
            return ;
        }
        [progressHUD hide:YES];
        
        MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:unit.navigationController.view];
        [unit.navigationController.view addSubview:progress];
        [progress setLabelText:declare.instralling];
        [progress showAnimated:YES whileExecutingBlock:^{
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath])
            {
                if (![unit.navigationController.topViewController isKindOfClass:[HDResourceViewController class]])
                {
                    return ;
                }
                NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[declare applicationLibraryDirectory],declare.language];
                ZipArchive* za = [ZipArchive new];
                [za UnzipOpenFile: resourcePath];
                if ([za UnzipFileTo: directoryPath overWrite: YES])
                {
                    NSError *error;
                    [[NSFileManager defaultManager]removeItemAtPath:resourcePath
                                                              error:&error];
                    unit.autoing = YES;
                    [unit.itemTableView reloadData];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:aItem.identifier forKey:@"content"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"result" object:nil userInfo:dic];
                    
                }
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                                   message:declare.downloadFailed
                                                                  delegate:nil
                                                         cancelButtonTitle:declare.alertOK
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
        
    }];
    [self.request setDownloadDestinationPath:resourcePath];
    //[self.request setAllowResumeForFileDownloads:YES];
    [self.request setStartedBlock:^{
        [progressHUD show:YES];
    }];
    [self.request startAsynchronous];
}

-(void)autoDemand:(NSNotification*)notification
{
    if (self.autoing)
    {
        NSDictionary *dic = [notification userInfo];
        NSString *number = [dic objectForKey:@"content"];
        [self push:number];
    }
    
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]                                 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];
    
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString                                 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    
    return YES;
}
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSLog(@"%@",searchText);
    NSPredicate *resultPredicate = [NSPredicate                                      predicateWithFormat:@"exhibitno contains[cd] %@",                                     searchText];
    
    self.searchResults = [self.itemArray filteredArrayUsingPredicate:resultPredicate];
}
@end
