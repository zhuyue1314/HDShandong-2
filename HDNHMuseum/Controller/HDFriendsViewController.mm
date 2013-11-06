//
//  HDFriendsViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-9-5.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDFriendsViewController.h"
#import "HDConnectModel.h"
#import "HDDeclare.h"
#import "HDMapViewController.h"
#import "HDFriend.h"

@interface HDFriendsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
- (IBAction)registerGroup:(UIButton *)sender;
- (IBAction)joinGroup:(UIButton *)sender;
@property(strong,nonatomic)NSMutableArray *friendsArray;
@end
static HDConnectModel *connect;
static HDDeclare *declare;
@implementation HDFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        connect = [HDConnectModel sharedConnect];
        declare = [HDDeclare sharedDeclare];
        _friendsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, 50.0, 29.0);
    [rightButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.friendTableView.hidden = YES;
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.friendTableView.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"background928"]];
    self.friendTableView.backgroundView = tableBackgroundView;
    
       
    // Do any additional setup after loading the view from its nib.
}
-(void)quit
{
    NSString *string = [NSString stringWithFormat:@"delur%@#%@#",declare.groupNumber,declare.userName];
    [connect sendContent:string WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result)
    {
        NSLog(@"%@",[result objectForKey:@"msg"]);
        declare.groupNumber = @"0";
        NSString *userInfo = [[declare applicationLibraryDirectory] stringByAppendingPathComponent:@"userInfo.plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userInfo];
        [dic setValue:declare.groupNumber forKey:@"groupNumber"];
        [dic writeToFile:userInfo atomically:YES];
        self.friendTableView.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.friendsArray removeAllObjects];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.title = declare.myFriend;
    self.registerLabel.text = declare.registerGroup;
    self.joinLabel.text = declare.joinGroup;
    if ([declare.groupNumber intValue])
    {
        [self reloadFriendsViewWithGroupNumber:declare.groupNumber];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFriendTableView:nil];
    [super viewDidUnload];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsArray count];
}
- (IBAction)registerGroup:(UIButton *)sender
{
    NSString *content = [NSString stringWithFormat:@"qbind%@#",declare.userName];
    [connect sendContentAlert:content WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result)
    {
        NSLog(@"%@",[result objectForKey:@"msg"]);
        NSString *content=[result objectForKey:@"msg"];
        if ([content isEqualToString:@"qfail"])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                               message:declare.registerFailed
                                                              delegate:nil
                                                     cancelButtonTitle:declare.alertOK
                                                     otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            NSArray *array=[content componentsSeparatedByString:@"#"];
            NSString *groupNo = [array objectAtIndex:1];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.registerSucceed
                                                               message:groupNo
                                                              delegate:nil
                                                     cancelButtonTitle:declare.alertOK
                                                    otherButtonTitles:nil, nil];
            [alertView show];
            declare.groupNumber = groupNo;
            NSString *userInfo = [[declare applicationLibraryDirectory] stringByAppendingPathComponent:@"userInfo.plist"];
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userInfo];
            [dic setValue:declare.groupNumber forKey:@"groupNumber"];
            [dic writeToFile:userInfo atomically:YES];
            [self reloadFriendsViewWithGroupNumber:groupNo];
        }
    }];
}

- (IBAction)joinGroup:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.joinNumberNeed
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:declare.alertCancel
                                             otherButtonTitles:declare.alertOK, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].text = @"";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    alertView.tag = 101;
    [alertView show];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    HDFriend *myfriend = [self.friendsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = myfriend.nickName;
    cell.detailTextLabel.text = myfriend.name;
    cell.imageView.image = [UIImage imageNamed:@"friendicon"];
    return cell;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        HDFriend *myfriend = [self.friendsArray objectAtIndex:indexPath.row];
        NSString *content = [NSString stringWithFormat:@"quren%@#",myfriend.name];
        [connect sendContent:content WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result)
         {
             NSString *string = [result objectForKey:@"msg"];
             if ([string isEqualToString:@"noren"])
             {
                 UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:declare.alertTitle
                                                                message:declare.noLocationInfo
                                                               delegate:nil
                                                      cancelButtonTitle:declare.alertOK
                                                      otherButtonTitles:nil, nil];
                 [alert show];
             }
             else
             {
                 NSArray *array = [string componentsSeparatedByString:@"#"];
                 if ([array count]>1)
                 {
                     NSString *position = [array objectAtIndex:1];
                     HDMapViewController *map = [[HDMapViewController alloc]initWithNibName:@"HDMapViewController" bundle:nil];
                     [self.navigationController pushViewController:map animated:YES];
                     [map locationWithRFID:position];
                 }
             }
             
             
         }];
    }
    else
    {
        UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:declare.alertTitle
                                                       message:declare.outsideGroup
                                                      delegate:nil
                                             cancelButtonTitle:declare.alertOK
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *string = [alertView textFieldAtIndex:0].text;
        NSString *content = [NSString stringWithFormat:@"addur%@#%@#",string,declare.userName];
        [connect sendContentAlert:content WithTarget:declare.target WithCompleteBlock:^(NSDictionary *result)
        {
            NSLog(@"%@",[result objectForKey:@"msg"]);
            NSString *content=[result objectForKey:@"msg"];
            if ([content isEqualToString:@"qfail"])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:declare.alertTitle
                                                                   message:declare.joinFailed
                                                                  delegate:nil
                                                         cancelButtonTitle:declare.alertOK
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            }
            else
            {
                declare.groupNumber = string;
                NSString *userInfo = [[declare applicationLibraryDirectory] stringByAppendingPathComponent:@"userInfo.plist"];
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userInfo];
                [dic setValue:declare.groupNumber forKey:@"groupNumber"];
                [dic writeToFile:userInfo atomically:YES];
                [self reloadFriendsViewWithGroupNumber:string];
                
            }
        }];
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
@end
