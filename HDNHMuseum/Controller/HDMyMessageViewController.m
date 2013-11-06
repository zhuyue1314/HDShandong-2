//
//  HDMyMessageViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-6.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDMyMessageViewController.h"
#import "HDDeclare.h"
#import "HDConnectModel.h"
#import "HDFriend.h"

@interface HDMyMessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoIcon;
@property (weak, nonatomic) IBOutlet UILabel *netStatus;
@property (weak, nonatomic) IBOutlet UILabel *IDContent;
@property (weak, nonatomic) IBOutlet UILabel *nameContent;
@property (weak, nonatomic) IBOutlet UILabel *groupContent;
- (IBAction)edit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property(strong,nonatomic)NSMutableArray *friendsArray;

@end
static HDDeclare *declare;
static HDConnectModel *connect;
@implementation HDMyMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        declare = [HDDeclare sharedDeclare];
        connect = [HDConnectModel sharedConnect];
        _friendsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = declare.myinformation;
    self.IDContent.text = declare.userID;
    self.nameContent.text = declare.nickName;
    self.groupContent.text = declare.groupNumber;
    //self.friendTableView
    [self reloadFriendsViewWithGroupNumber:declare.groupNumber];
//    NSString *content = [NSString stringWithFormat:@"qname%@#",declare.userName];
//    [connect sendContent:content WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result){
//        NSLog(@"%@",[result objectForKey:@"msg"]);
//    }];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.nameLabel.text = declare.nameLabel;
    self.groupLabel.text = declare.groupLabel;
    if([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        self.netStatus.text = declare.yourInside;
    }
    else
    {
        self.netStatus.text = declare.yourOutside;
    }
    [self reloadFriendsViewWithGroupNumber:declare.groupNumber];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setPhotoIcon:nil];
    [self setNetStatus:nil];
    [self setIDContent:nil];
    [self setNameContent:nil];
    [self setGroupContent:nil];
    [super viewDidUnload];
}
- (IBAction)edit:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.input
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:declare.alertCancel
                                             otherButtonTitles:declare.alertOK, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].text = self.nameContent.text;
    alertView.tag = 101;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
         NSString *string = [alertView textFieldAtIndex:0].text;
        if ([string length])
        {
            NSString *content = [NSString stringWithFormat:@"xname%@#%@#",declare.userName,string];
            [connect sendContent:content WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result){
                self.nameContent.text = string;
                declare.nickName = string;
                NSString *userInfo = [[declare applicationLibraryDirectory] stringByAppendingPathComponent:@"userInfo.plist"];
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userInfo];
                [dic setValue:declare.nickName forKey:@"nickName"];
                [dic writeToFile:userInfo atomically:YES];
                [self reloadFriendsViewWithGroupNumber:declare.groupNumber];
            }];
        }
    }
}
-(void)reloadFriendsViewWithGroupNumber:(NSString *)numberString
{
    NSString *contentString = [NSString stringWithFormat:@"quzhu%@#",numberString];
    [connect sendContent:contentString WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result)
     {
         NSString *resultString = [result objectForKey:@"msg"];
         if ([resultString isEqualToString:@"nozhu"]) {
             return ;
         }
         NSArray *array = [resultString componentsSeparatedByString:@"#"];
         [self.friendsArray removeAllObjects];
         NSString *nameString = nil;
         NSString *nickString = nil;
         if ([array count]>2)
         {
             nameString = [array objectAtIndex:1];
             nickString = [array objectAtIndex:2];
         }
         NSArray *nameArray = [nameString componentsSeparatedByString:@";"];
         NSArray *nickArray = [nickString componentsSeparatedByString:@";"];
         
         for (int i = 0; i<[nameArray count]-1; i++)
         {
             HDFriend *myfriend = [[HDFriend alloc]init];
             myfriend.name = [nameArray objectAtIndex:i];
             NSString *string =[nickArray objectAtIndex:i];
             if ([string isEqualToString:@"null"])
             {
                 myfriend.nickName = @"游客";
             }
             else
                 myfriend.nickName = string;
             [self.friendsArray addObject:myfriend];
         }
         [self.friendTableView reloadData];
         self.friendTableView.hidden= NO;
         self.navigationItem.rightBarButtonItem.enabled = YES;
         
     }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    HDFriend *myfriend = [self.friendsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = myfriend.nickName;
    cell.detailTextLabel.text = myfriend.name;
    cell.imageView.image = [UIImage imageNamed:@"friendicon"];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return declare.myFriend;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsArray count];
}
@end
