//
//  HDNewBroadcastViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-23.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDNewBroadcastViewController.h"
#import "HDBroadcastViewController.h"
#import "HDBroadcast.h"
#import "HDDeclare.h"

@interface HDNewBroadcastViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *allArray;
-(void)reloadADS;
@end
static HDDeclare *declare;
@implementation HDNewBroadcastViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _array = [NSMutableArray arrayWithCapacity:0];
        _allArray = [NSMutableArray arrayWithCapacity:0];
        declare = [HDDeclare sharedDeclare];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = declare.thenews;
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
    for (int i = 0; i<[self.allArray count]; i++)
    {
        HDBroadcast *temp = [self.allArray objectAtIndex:i];
        if ([item.identifier isEqualToString:temp.identifier])
        {
            temp.status = @"old";
            [self.allArray replaceObjectAtIndex:i withObject:temp];
            NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[declare applicationLibraryDirectory]];
            
            NSMutableData *receiveData = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                         initForWritingWithMutableData:receiveData];
            
            [archiver encodeObject:self.allArray forKey:@"receiveAD"];
            [archiver finishEncoding];
            
            if ([receiveData writeToFile: path atomically: YES])
            {
                NSLog(@"fhjdskfhskafhlas");
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"news" object:nil];
        }
    }
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
-(void)reloadADS
{
    NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[declare applicationLibraryDirectory]];
    
    NSMutableData *data = [[NSMutableData alloc]
                           initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                     initForReadingWithData:data];
    [self.allArray removeAllObjects];
    [self.allArray addObjectsFromArray:
    [unarchiver decodeObjectForKey:@"receiveAD"]];
    [unarchiver finishDecoding];
}

@end
