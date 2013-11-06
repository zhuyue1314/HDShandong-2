//
//  HDMapViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDMapViewController.h"
#import "HDMapDetailViewController.h"
#import "HDDeclare.h"

@interface HDMapViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mapTableView;
@property (strong,nonatomic)UIPageViewController *pageViewController;
@property (strong,nonatomic)NSMutableArray *mapArray;
@property  (assign,nonatomic)UIPageViewControllerNavigationDirection dirction;
-(NSUInteger)indexOfViewController:(HDMapDetailViewController *)viewController;

@end
static HDDeclare *declare;
@implementation HDMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        declare = [HDDeclare sharedDeclare];
        _mapArray = [[NSMutableArray alloc]initWithObjects:@"1-1F",@"1-2F",@"2F",@"3F",nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapTableView.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    self.mapTableView.showsVerticalScrollIndicator = NO;
    
    
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.mapTableView.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"menuTableBackground"]];
    self.mapTableView.backgroundView = tableBackgroundView;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    HDMapDetailViewController *mapDetailViewController = [[HDMapDetailViewController alloc]initWithNibName:@"HDMapDetailViewController" bundle:nil];
    NSArray *viewControllers = [NSArray arrayWithObject:mapDetailViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    mapDetailViewController.currentIndex = @"0";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mapTableView selectRowAtIndexPath:indexPath
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionTop];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    CGRect rect = self.view.bounds;
    self.pageViewController.view.frame = CGRectMake(0, 40, 320, rect.size.height-40);
    [self.pageViewController didMoveToParentViewController:self];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.map;
    self.navigationController.navigationBarHidden = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mapArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *mlabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(-20,20, 80,40)];
        mlabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:mlabel];
        mlabel.tag = 101;
        mlabel.textAlignment = NSTextAlignmentCenter;
        mlabel.textColor = [UIColor blackColor];
        mlabel.font =  [UIFont boldSystemFontOfSize:20];
        mlabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"meunTableCellSelected"]];
        cell.selectedBackgroundView = image;
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    label.text = [self.mapArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView indexPathForSelectedRow].row>indexPath.row)
    {
         self.dirction = UIPageViewControllerNavigationDirectionReverse;
    }
    else
    {                         
        self.dirction = UIPageViewControllerNavigationDirectionForward;
       
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDMapDetailViewController *mapDetailViewController = [[HDMapDetailViewController alloc]initWithNibName:@"HDMapDetailViewController" bundle:nil];
    mapDetailViewController.currentIndex = [NSString stringWithFormat:@"%d",indexPath.row];
    NSArray *viewControllers = [NSArray arrayWithObject:mapDetailViewController];
    __block __weak HDMapViewController *blocksafeSelf = self;
    [self.pageViewController setViewControllers:viewControllers direction:self.dirction animated:YES completion:^(BOOL finished){
        if(finished)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blocksafeSelf.pageViewController setViewControllers:viewControllers direction:blocksafeSelf.dirction animated:NO completion:NULL];// bug fix for uipageview controller
            });
        }
    }];
}
//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
//    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
//    NSArray *viewControllers =[ NSArray arrayWithObject:currentViewController];
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
//    
//    self.pageViewController.doubleSided = YES;
//    return UIPageViewControllerSpineLocationMid;
//}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
   NSUInteger index = [self indexOfViewController:(HDMapDetailViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mapTableView selectRowAtIndexPath:indexPath
                                       animated:YES
                                 scrollPosition:UITableViewScrollPositionTop];
        return nil;
    }
    
    index--;      
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    [self.mapTableView selectRowAtIndexPath:indexPath
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionTop];
     HDMapDetailViewController *mapDetailViewController = [[HDMapDetailViewController alloc]initWithNibName:@"HDMapDetailViewController" bundle:nil];
    mapDetailViewController.currentIndex=[NSString stringWithFormat:@"%d",index];
   // NSLog(@"Before");
    return mapDetailViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(HDMapDetailViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.mapArray count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        [self.mapTableView selectRowAtIndexPath:indexPath
                                       animated:YES
                                 scrollPosition:UITableViewScrollPositionMiddle];
        return nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
    [self.mapTableView selectRowAtIndexPath:indexPath
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionMiddle];

     HDMapDetailViewController *mapDetailViewController = [[HDMapDetailViewController alloc]initWithNibName:@"HDMapDetailViewController" bundle:nil];
    mapDetailViewController.currentIndex= [NSString stringWithFormat:@"%d",index];
    return mapDetailViewController;
}
-(NSUInteger)indexOfViewController:(HDMapDetailViewController *)viewController
{
    return [viewController.currentIndex intValue];
}
-(void)locationWithRFID:(NSString *)number
{
    NSInteger RFID = [number intValue];
    NSInteger index = 0;
    if (RFID>1500&&RFID<1600)
    {
        index = 0;
    }
    else if (RFID>1600&&RFID<1700)
    {
        index = 1;
    }
    else if (RFID>1700&&RFID<1800)
    {
        index = 2;
    }
    else
    {
        index = 3;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mapTableView selectRowAtIndexPath:indexPath
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionMiddle];
    HDMapDetailViewController *mapDetailViewController = [[HDMapDetailViewController alloc]initWithNibName:@"HDMapDetailViewController" bundle:nil];
    mapDetailViewController.currentIndex = [NSString stringWithFormat:@"%d",index];
    mapDetailViewController.friendNumber = number;
    mapDetailViewController.locationNumber = @"0";
    NSArray *viewControllers = [NSArray arrayWithObject:mapDetailViewController];
    __block __weak HDMapViewController *blocksafeSelf = self;
    [self.pageViewController setViewControllers:viewControllers direction:self.dirction animated:YES completion:^(BOOL finished){
        if(finished)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blocksafeSelf.pageViewController setViewControllers:viewControllers direction:blocksafeSelf.dirction animated:NO completion:NULL];// bug fix for uipageview controller
            });
        }
    }];

}
@end
