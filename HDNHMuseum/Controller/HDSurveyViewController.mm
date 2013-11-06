//
//  HDSurveyViewController.m
//  PomeloKit
//
//  Created by Li Shijie on 13-7-10.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDSurveyViewController.h"
#import "HDDeclare.h"
#import "HDSurveyDataViewController.h"

@interface HDSurveyViewController ()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(assign,nonatomic)NSUInteger curentIndex;
@end

static HDDeclare *declare;

@implementation HDSurveyViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.curentIndex = 0;
    declare = [HDDeclare sharedDeclare];
    
    HDSurveyDataViewController *startViewController = [[HDSurveyDataViewController alloc]initWithNibName:@"HDSurveyDataViewController" bundle:nil];
   
    NSArray *viewControllers = [NSArray arrayWithObject:startViewController];
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
     startViewController.index = 0;
    [self didMoveToParentViewController:self];
    self.title =declare.Questionnaire;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(next)
                                                name:@"next"
                                              object:nil];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0, 0.0, 50.0, 29.0);
    [leftButton setImage:[UIImage imageNamed:@"back.png"]
                forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(back)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)next
{
    if (self.curentIndex+1 >= self.serveyCount)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                           message:@"最后一题完成，感谢您的参与！"
                                                          delegate:self
                                                 cancelButtonTitle:@"返回"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    self.curentIndex++;
    HDSurveyDataViewController *startViewController = [[HDSurveyDataViewController alloc]initWithNibName:@"HDSurveyDataViewController" bundle:nil];
    
    NSArray *viewControllers = [NSArray arrayWithObject:startViewController];
    
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    startViewController.index = self.curentIndex;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = [self.viewControllers objectAtIndex:0];
    NSArray *viewControllers =[ NSArray arrayWithObject:currentViewController];
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:NULL];
    
    self.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.curentIndex == 0)
    {
        return nil;
    }
    self.curentIndex--;
    HDSurveyDataViewController *surveyDataViewController = [[HDSurveyDataViewController alloc]initWithNibName:@"HDSurveyDataViewController" bundle:nil];
    surveyDataViewController.index = self.curentIndex;
    return surveyDataViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.curentIndex +1>= self.serveyCount)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最后一页" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    self.curentIndex++;
    HDSurveyDataViewController *surveyDataViewController = [[HDSurveyDataViewController alloc]initWithNibName:@"HDSurveyDataViewController" bundle:nil];
    surveyDataViewController.index = self.curentIndex;
    return surveyDataViewController;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
