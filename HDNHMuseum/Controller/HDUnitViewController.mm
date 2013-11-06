//
//  HDUnitViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-10-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.


#import "HDUnitViewController.h"
#import "HDItem.h"
#import "HDDeclare.h"
#import "HDUnit.h"
#import "HDPlayerViewController.h"
#import "HDResourceViewController.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"

static HDDeclare *declare;

@interface HDUnitViewController()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)autoDemand:(NSNotification*)notification;
-(void)push:(NSString *)number;
@property (strong,nonatomic)NSMutableArray *unitArray;
@property (strong,nonatomic)NSMutableArray *resourceArray;
@property(strong,nonatomic)HDPlayerViewController *playerViewController ;
@property(nonatomic)BOOL autoing;
@property(strong,nonatomic)ASIHTTPRequest *request;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation HDUnitViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _unitArray = [NSMutableArray arrayWithCapacity:0];
        _resourceArray  = [NSMutableArray arrayWithCapacity:0];
        _playerViewController = [[HDPlayerViewController alloc]initWithNibName:@"HDPlayerViewController" bundle:nil];
        declare = [HDDeclare sharedDeclare];
        //recorder = new AQRecorder();
        _autoing = YES;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.tableView.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"background928"]];
    self.tableView.backgroundView = tableBackgroundView;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.AutoNavigation;
    self.navigationController.navigationBarHidden = NO;
    [self fetchData];
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

-(void)fetchData
{
    NSLog(@"%@",declare.unit);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:declare.unit
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSError *error = nil;
    NSMutableArray *FetchResults = [[self.managedObjectContext
                                     executeFetchRequest:fetchRequest
                                     error:&error]mutableCopy];
    [self.unitArray removeAllObjects];
    self.unitArray = FetchResults;
    [self.tableView reloadData];
    
    NSFetchRequest *fetchResourceRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityResource = [NSEntityDescription
                                   entityForName:declare.language
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchResourceRequest setEntity:entityResource];
    [fetchResourceRequest setFetchBatchSize:20];
    NSError *errorResource = nil;
    NSMutableArray *FetchResourceResults = [[self.managedObjectContext
                                     executeFetchRequest:fetchResourceRequest
                                     error:&errorResource]mutableCopy];
    [self.resourceArray removeAllObjects];
    self.resourceArray = FetchResourceResults;
    if ([self.resourceArray count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.alertTitle message:@"No Exhibitions" delegate:nil cancelButtonTitle:declare.alertOK otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.unitArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"itemCellSelected"]];
        cell.selectedBackgroundView = image;
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    HDUnit *item = [self.unitArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    NSString *iconPath = [NSString stringWithFormat:@"%@/%@/%@",[declare applicationLibraryDirectory],declare.language,item.icon];
    if ([[NSFileManager defaultManager] fileExistsAtPath:iconPath])
    {
        cell.imageView.image = [UIImage imageWithContentsOfFile:iconPath];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"cellIIcon"];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDUnit *unit = [self.unitArray objectAtIndex:indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (HDItem *item in self.resourceArray)
    {
        if ([item.unitno intValue]==[unit.number intValue])
        {
            [array addObject:item];
        }
    }
    HDResourceViewController *resourceViewController = [[HDResourceViewController alloc]initWithNibName:@"HDResourceViewController" bundle:nil];
    resourceViewController.itemArray = array;
    resourceViewController.resourceArray = self.resourceArray;
    resourceViewController.title = unit.name;
    [self.navigationController pushViewController:resourceViewController animated:YES];
    
    
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HDNHMuseum" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[declare applicationLibraryURLDirectory] URLByAppendingPathComponent:@"HDNHMuseum.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        
    }
    return _persistentStoreCoordinator;
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
    NSString *zipPath = [NSString stringWithFormat:@"http://%@/ios/app/%@/%@.zip",declare.downloadAddress,declare.language,aItem.identifier];
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
    [self.request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total)
     {
         downloadedBytes += size;
         CGFloat progressPercent = (CGFloat)downloadedBytes/total;
         progressHUD.progress = progressPercent;
     }];
    __block __weak HDUnitViewController *unit = self;
    [self.request setCompletionBlock:^{
        [progressHUD hide:YES];
        MBProgressHUD *progress = [[MBProgressHUD alloc]initWithView:unit.navigationController.view];
        [unit.navigationController.view addSubview:progress];
        //progress.delegate = unit;
        [progress setLabelText:declare.instralling];
        [progress showAnimated:YES whileExecutingBlock:^{
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath])
            {
                NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[declare applicationLibraryDirectory],declare.language];
                ZipArchive* za = [ZipArchive new];
                [za UnzipOpenFile: resourcePath];
                if ([za UnzipFileTo: directoryPath overWrite: YES])
                {
                    NSError *error;
                    [[NSFileManager defaultManager]removeItemAtPath:resourcePath
                                                              error:&error];
                    unit.autoing = YES;
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:aItem.identifier forKey:@"content"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"result" object:nil userInfo:dic];
                    
                }
            }}];
        
    }];
    [self.request setDownloadDestinationPath:resourcePath];
    [self.request setAllowResumeForFileDownloads:YES];
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
