//
//  HDintroductionViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDintroductionViewController.h"
#import "HDDeclare.h"

@interface HDintroductionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)UIScrollView  *scrollView;
@property(strong,nonatomic)UIPageControl *photoPage;
@end
static HDDeclare *declare;
@implementation HDintroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        declare = [HDDeclare sharedDeclare];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tableBackgroundView = [[UIImageView alloc]
                                        initWithFrame:self.tableView.bounds];
    [tableBackgroundView setImage:[UIImage imageNamed:@"background1008.png"]];
    self.tableView.backgroundView = tableBackgroundView;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 217)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(1600, 166);
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    imageView1.image = [UIImage imageNamed:@"introduction"];
    [self.scrollView addSubview:imageView1];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, 216)];
    imageView2.image = [UIImage imageNamed:@"introduction1"];
    [self.scrollView addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, 216)];
    imageView3.image = [UIImage imageNamed:@"introduction2"];
    [self.scrollView addSubview:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(960, 0, 320, 216)];
    imageView4.image = [UIImage imageNamed:@"introduction3"];
    [self.scrollView addSubview:imageView4];
    
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(1280, 0, 320, 216)];
    imageView5.image = [UIImage imageNamed:@"introduction4"];
    [self.scrollView addSubview:imageView5];
    
    self.photoPage = [[UIPageControl alloc]initWithFrame:CGRectMake(60, 180, 200,36)];
    self.photoPage.currentPage = 0;
    self.photoPage.numberOfPages = 5;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.introduce;
    self.navigationController.navigationBarHidden = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 217;
    }
    else
    {
        if (iPhone5)
        {
            return 300;
        }
        else
        {
            return 200;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0)
    {
//        [cell addSubview:self.scrollView];
//        [cell addSubview:self.photoPage];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
        imageView1.image = [UIImage imageNamed:@"introduction"];
        [cell addSubview:imageView1];
    }
    else
    {
        UITextView *textView;
        if (iPhone5)
        {
            textView = [[UITextView alloc]initWithFrame:CGRectMake(0,0, 320, 300)];
        }
        else
        {
            textView = [[UITextView alloc]initWithFrame:CGRectMake(0,0, 320, 200)];
        }

        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.font = [UIFont systemFontOfSize:17];
        textView.text = @"\t山东省美术馆是山东省承办第十届中国艺术节的重要场馆之一，将为“全国优秀美术作品展”、“山东省重大历史题材美术创作工程作品展”等提供一流的展示平台。 山东省美术馆总投资近6亿元，是我国在建规模最大的现代美术馆， 山东省美术馆定位为独具特色、设施先进、品位高雅、功能完善的现代化美术馆。项目可用于建设的土地面积2.07公顷，建设总面积5万平方米，其中地上五层建筑面积3.8万平方米，地下一层建筑面积1.2万平方米。建成后的山东省美术馆，将以优美的建筑形象，鲜明的建筑个性，独特的文化内涵，成为凸显山东文化特色，富有时代气息，集收藏、研究、展陈、教育、交流、服务于一体，学术、教育和休闲功能形象并重的文化标志性建筑。";
        [cell addSubview:textView];
    }
    return  cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    self.photoPage.currentPage =(int) offset/320;
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
