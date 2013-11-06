//
//  HDEducationViewController.m
//  HDNHMuseum
//
//  Created by Liuzhuan on 13-10-28.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDEducationViewController.h"
#import "HDEducationDetailViewController.h"
#import "HDEducation.h"
#import "ASIHTTPRequest.h"
#import "TBXML.h"
#import "HDDeclare.h"

@interface HDEducationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *educationArray;
@property (strong,nonatomic)NSMutableArray *navPointArray;

@end
static HDDeclare *declare;
@implementation HDEducationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _educationArray = [NSMutableArray arrayWithCapacity:0];
        _navPointArray = [NSMutableArray arrayWithObjects:@"title",@"path",@"description",nil];
        declare = [HDDeclare sharedDeclare];
        
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
    [self fetchData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.education;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.educationArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    HDEducation *education = [self.educationArray objectAtIndex:indexPath.row];
    cell.textLabel.text = education.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDEducationDetailViewController *education = [[HDEducationDetailViewController alloc]initWithNibName:@"HDEducationDetailViewController" bundle:nil];
    HDEducation *item = [self.educationArray objectAtIndex:indexPath.row];
    education.currentItem = item;
    [self.navigationController pushViewController:education animated:YES];
}
-(void)fetchData
{
    NSString *xmlPath = [NSString stringWithFormat:@"%@/education/educations.xml",[declare applicationLibraryDirectory]];
    if ([[NSFileManager defaultManager ] fileExistsAtPath:xmlPath])
    {
        NSData *data = [NSData dataWithContentsOfFile:xmlPath];
        NSError *error;
        TBXML *xml = [TBXML tbxmlWithXMLData: data error:&error];
        TBXMLElement *root = xml.rootXMLElement;
        if (root)
        {
            while (![[TBXML elementName:root] isEqualToString:@"education"])
            {
                root = root->firstChild;
                if (!root->currentChild)
                {
                    NSLog(@"XML is NULL!");
                    return;
                }
            }
            if(root)
            {
                while (root)
                {
                    int i = [self.navPointArray count];
                    TBXMLElement *p[i];
                    NSMutableDictionary *items = [NSMutableDictionary dictionary];
                    for (int j = 0;j<i;j++)
                    {
                        p[j] = [TBXML childElementNamed:[self.navPointArray objectAtIndex:j]
                                          parentElement:root];
                        //NSLog(@"%@",[TBXML textForElement:p[j]]);
                        [items setValue:[TBXML textForElement:p[j]]
                                 forKey:[self.navPointArray objectAtIndex:j]];
                        
                    }
                    HDEducation *education = [[HDEducation alloc]initWithDictionary:items];
                    [self.educationArray addObject:education];
                    root = root->nextSibling;
                }
            }
        }
        [self.tableView reloadData];
    }
   
}
@end
