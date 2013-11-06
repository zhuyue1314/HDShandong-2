//
//  HDReceivedADViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-29.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDReceivedADViewController.h"
#import "HDBroadcastViewController.h"
#import "HDDeclare.h"
#import "HDBroadcast.h"


@interface HDReceivedADViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *array;
-(void)reloadADS;

@end
static HDDeclare *declare;
@implementation HDReceivedADViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _array = [NSMutableArray arrayWithCapacity:0];
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
    
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.tableView.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"background928"]];
    self.tableView.backgroundView = tableBackgroundView;
    [self reloadADS];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)reloadADS
{
    NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[[HDDeclare sharedDeclare]applicationLibraryDirectory]];
    
    NSMutableData *data = [[NSMutableData alloc]
                                  initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                     initForReadingWithData:data];
    [self.array removeAllObjects];
    [self.array addObjectsFromArray:
     [unarchiver decodeObjectForKey:@"receiveAD"]];
    [unarchiver finishDecoding];
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.title = declare.information;
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%d",self.tableView.editing);
    self.tableView.editing = NO;
   // [self.tableView endUpdates];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
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
        cell.backgroundColor = [UIColor clearColor];
        cell.imageView.image = [UIImage imageNamed:@"broadcasticon"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    HDBroadcast *item = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     HDBroadcast *item = [self.array objectAtIndex:indexPath.row];
    HDBroadcastViewController *broadcastDetailViewController = [[HDBroadcastViewController alloc]initWithNibName:@"HDBroadcastViewController" bundle:nil];
      broadcastDetailViewController.item = item;
    [self.navigationController pushViewController:broadcastDetailViewController animated:YES];
  
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.array removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[declare applicationLibraryDirectory]];
        
        NSMutableData *receiveData = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                     initForWritingWithMutableData:receiveData];
        
        [archiver encodeObject:self.array forKey:@"receiveAD"];
        [archiver finishEncoding];
        if ([receiveData writeToFile: path atomically: YES])
        {
            NSLog(@"fhjdskfhskafhlas");
        }
        
    }
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
