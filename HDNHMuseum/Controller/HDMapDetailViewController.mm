//
//  HDMapDetailViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-30.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDMapDetailViewController.h"
#import "HDAnnotation.h"
//#import "HDItem.h"
#import "HDLocation.h"
#import "HDDeclare.h"
#import "HDPlayerViewController.h"
static HDDeclare *declare;
#define SkippingGirlImageSize CGSizeMake(465,320)//一倍地图的尺寸
@interface HDMapDetailViewController ()
@property (strong,nonatomic)HDMapView *mapView;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic)NSMutableArray *annotationArray;
@property(strong,nonatomic)NSMutableArray *currentAnnotations;

- (IBAction)hideRouteView:(UIButton *)sender;
@property(strong,nonatomic)HDPlayerViewController *playerViewController;
@end

@implementation HDMapDetailViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        declare  = [HDDeclare sharedDeclare];
        _playerViewController = [[HDPlayerViewController alloc]initWithNibName:@"HDPlayerViewController" bundle:nil];
        _currentAnnotations = [NSMutableArray arrayWithCapacity:0];
        _annotationArray = [NSMutableArray arrayWithCapacity:0];
        self.locationNumber = @"0";
        self.friendNumber = @"0";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView = [[HDMapView alloc] initWithFrame:CGRectMake(0,0,568,320)
                                        contentSize:SkippingGirlImageSize];
    self.mapView.center = self.view.center;
    //self.view.backgroundColor = [UIColor redColor];
    self.mapView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
    self.mapView.dataSource = self;
    self.mapView.mapViewdelegate = self;
    self.mapView.zoomScale = 1.0f;
    self.mapView.levelsOfZoom = 2;
    self.mapView.levelsOfDetail = 2;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    [self fetchData];
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
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoDemand:)
                                                 name:@"result"
                                               object:nil];
    NSString *str = [NSString stringWithFormat:@"mapRoute%d.png",[self.currentIndex intValue]+1];
    [self.mapView addRouteViewWithIndex:str];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"result"
                                                 object:nil];
}
-(void)autoDemand:(NSNotification*)notification
{
    if (declare.autoFlag)
    {
        NSDictionary *dic = [notification userInfo];
        NSString *number = [dic objectForKey:@"content"];
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^(void) {
            [self locationMe:number andFriend:self.friendNumber];
        });
       // [self performSelectorOnMainThread:@selector(location:) withObject:number waitUntilDone:NO];
    }
}

- (void)locationMe:(NSString *)myInfo
         andFriend:(NSString *)friendInfo
{
    if ([self.locationNumber intValue]== [myInfo intValue] &&[self.friendNumber intValue]==[friendInfo intValue])
    {
        return;
    }
    else
    {
        self.locationNumber = myInfo;
        self.friendNumber = friendInfo;
        [self.mapView locationMine:myInfo andFriend:friendInfo];
    }
}
-(void)location:(NSString *)number
{
    if ([self.locationNumber intValue]== [number intValue])
    {
        return;
    }
    else
    {
        self.locationNumber = number;
        for (int i=0; i<[self.annotationArray count]; i++)
        {
            HDLocation *item = [self.annotationArray objectAtIndex:i];
            if ([number intValue]==[item.identifier intValue])
            {
                [self.mapView locationPin:item.identifier];
                return;
            }
        }
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
-(void)fetchData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Location"
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSError *error = nil;
    NSMutableArray *FetchResults = [[self.managedObjectContext
                                     executeFetchRequest:fetchRequest
                                     error:&error]mutableCopy];
    self.annotationArray = FetchResults;
    [self.currentAnnotations removeAllObjects];
    for (int i= 0; i<[self.annotationArray count]; i++)
    {
        HDLocation *annotationData = [self.annotationArray objectAtIndex:i];
        if ([self.currentIndex intValue]+1==[annotationData.floor intValue])
        {
            [self.currentAnnotations addObject:annotationData];
            NSString *position = annotationData.position;
            NSArray *array = [position componentsSeparatedByString:@","];
            float x = [[array objectAtIndex:0]floatValue];
            float y = [[array objectAtIndex:1]floatValue];
            HDAnnotation * annotation = [HDAnnotation annotationWithPoint:CGPointMake(x, y)];
            annotation.title = annotationData.name;
            annotation.identify = annotationData.identifier;
//            if ([annotationData.feature isEqualToString:@"explain"])
//            {
//                annotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//                [annotation.rightCalloutAccessoryView addTarget:self action:@selector(playItem:) forControlEvents:UIControlEventTouchUpInside];
//            }
            [self.mapView addAnnotation:annotation animated:YES];
        }
        

    }
}
-(void)playItem:(UIButton*)sender
{
//    int identifier = [self.mapView.callout.annotation.identify intValue];
//    for (HDLocation *item in self.annotationArray)
//    {
//        if (identifier==[item.identifier intValue])
//        {
//            self.playerViewController.itemArray =self.annotationArray;
//            [self.navigationController pushViewController:self.playerViewController animated:YES];
//           // [self.playerViewController playItem:item];
//        }
//    }
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
#define SkippingGirlImageName @"map"
- (UIImage *)mapView:(HDMapView *)mapView
         imageForRow:(NSInteger)row
              column:(NSInteger)column
               scale:(NSInteger)scale
{

    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d_%dx_%d_%d.png", SkippingGirlImageName,[self.currentIndex intValue]+1, scale, row, column]];
}
- (IBAction)hideRouteView:(UIButton *)sender {
    [self.mapView hideRouteView];
}
@end
