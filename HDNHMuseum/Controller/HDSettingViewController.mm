//
//  HDSettingViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDSettingViewController.h"
#import "HDDeclare.h"
#import "ZipArchive.h"
#import "HDConnectModel.h"

@interface HDSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingTableVIew;

@end
static HDDeclare *declare;
@implementation HDSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        declare = [HDDeclare sharedDeclare];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.settingTableVIew.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"background928"]];
    self.settingTableVIew.backgroundView = tableBackgroundView;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.setting;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSettingTableVIew:nil];
    [super viewDidUnload];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    if (indexPath.row==0)
    {
        cell.textLabel.text = declare.autoLocation;
         UISwitch *switchMode = [[UISwitch alloc]initWithFrame:CGRectMake(220, 15, 50, 30)];
        if (declare.autoFlag)
        {
            [switchMode setOn:YES];
        }
        else
        {
            [switchMode setOn:NO];
        }
        [switchMode addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchMode];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    else
    {
        cell.textLabel.text = declare.settingLanguage;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:declare.settingLanguage message:nil delegate:self cancelButtonTitle:declare.alertCancel otherButtonTitles:nil, nil];
        [alert addButtonWithTitle:@"中文"];
        [alert addButtonWithTitle:@"English"];
        alert.tag = 101;
        [alert show];
    }
}
-(void)switchChanged:(UISwitch *)sender
{
    if (sender.on)
    {
        declare.autoFlag = YES;
    }
    else
    {
        declare.autoFlag = NO;
    }
    
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if (buttonIndex==1)
        {
            declare.language = @"Chinese";
            self.title = declare.setting;
            [self.settingTableVIew reloadData];
        }
        else if(buttonIndex==2)
        {
            declare.language = @"English";
            self.title = declare.setting;
            [self.settingTableVIew reloadData];
        }
        else
            return;
    }
}

@end
