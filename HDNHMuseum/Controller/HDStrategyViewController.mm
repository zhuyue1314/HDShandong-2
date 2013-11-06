//
//  HDStrategyViewController.m
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-26.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDStrategyViewController.h"

#import "HDStrategyDetailViewController.h"
#import "HDArriveViewController.h"
#import "HDDeclare.h"
@interface HDStrategyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *telephoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *trafficBtn;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *ticketBtn;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UIButton *aroundBtn;
@property (weak, nonatomic) IBOutlet UILabel *aroundLabel;
- (IBAction)telephoneAction:(UIButton *)sender;
- (IBAction)trafficAction:(UIButton *)sender;
- (IBAction)ServiceAction:(UIButton *)sender;
- (IBAction)ticketAction:(UIButton *)sender;
- (IBAction)aroundAction:(UIButton *)sender;
@property(strong,nonatomic)HDStrategyDetailViewController *strategyDetailController;

@end
static HDDeclare *declare;
@implementation HDStrategyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _strategyDetailController = [[HDStrategyDetailViewController alloc]initWithNibName:@"HDStrategyDetailViewController" bundle:nil];
        declare = [HDDeclare sharedDeclare];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iPhone5)
    {
        self.telephoneBtn.frame = CGRectMake(10, 13, 143, 155);
        [self.telephoneBtn setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
        self.telephoneLabel.frame = CGRectMake(23, 141, 130, 21);
        
    
        self.trafficBtn.frame = CGRectMake(167, 13, 143, 155);
        [self.trafficBtn setImage:[UIImage imageNamed:@"traffic"] forState:UIControlStateNormal];
        self.trafficLabel.frame = CGRectMake(181, 141, 130, 21);
        
        
        self.serviceBtn.frame = CGRectMake(13, 181, 295, 143);
        [self.serviceBtn setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
        self.serviceLabel.frame = CGRectMake(23, 292, 285, 21);
        
        self.ticketBtn.frame = CGRectMake(10, 334, 143, 155);
        [self.ticketBtn setImage:[UIImage imageNamed:@"ticket"] forState:UIControlStateNormal];
        self.ticketLabel.frame = CGRectMake(23, 458, 130, 21);
        
        
        self.aroundBtn.frame = CGRectMake(167, 334, 143, 155);
        [self.aroundBtn setImage:[UIImage imageNamed:@"around"] forState:UIControlStateNormal];
        self.aroundLabel.frame = CGRectMake(181, 458, 130, 21);
    }
    else
    {
        self.telephoneBtn.frame = CGRectMake(10, 12, 143, 123);
        [self.telephoneBtn setImage:[UIImage imageNamed:@"telephone1"] forState:UIControlStateNormal];
        self.telephoneLabel.frame = CGRectMake(23, 110, 130, 21);
        
        self.trafficBtn.frame = CGRectMake(167, 12, 143, 123);
        [self.trafficBtn setImage:[UIImage imageNamed:@"traffic1"] forState:UIControlStateNormal];
        self.trafficLabel.frame = CGRectMake(181, 110, 130, 21);
        
        
        self.serviceBtn.frame = CGRectMake(13, 147, 295, 123);
        [self.serviceBtn setImage:[UIImage imageNamed:@"service1"] forState:UIControlStateNormal];
        self.serviceLabel.frame = CGRectMake(23, 245, 285, 21);
        
        self.ticketBtn.frame = CGRectMake(10, 282, 143, 123);
        [self.ticketBtn setImage:[UIImage imageNamed:@"ticket1"] forState:UIControlStateNormal];
        self.ticketLabel.frame = CGRectMake(23, 380, 130, 21);
        
        
        self.aroundBtn.frame = CGRectMake(167, 282, 143, 123);
        [self.aroundBtn setImage:[UIImage imageNamed:@"around1"] forState:UIControlStateNormal];
        self.aroundLabel.frame = CGRectMake(181, 380, 130, 21);
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = declare.strategy;
    self.telephoneLabel.text = declare.visit;
    self.trafficLabel.text = declare.traffic;
    self.ticketLabel.text = declare.museumInfo;
    self.aroundLabel.text = declare.website;
    self.serviceLabel.text = declare.arrive;
    self.navigationController.navigationBarHidden = NO;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTelephoneBtn:nil];
    [self setTrafficBtn:nil];
    [self setServiceBtn:nil];
    [self setTicketBtn:nil];
    [self setAroundBtn:nil];
    [self setTelephoneLabel:nil];
    [self setTrafficLabel:nil];
    [self setServiceLabel:nil];
    [self setTicketLabel:nil];
    [self setAroundLabel:nil];
    [super viewDidUnload];
}
- (IBAction)telephoneAction:(UIButton *)sender
{
    [self.navigationController pushViewController:self.strategyDetailController animated:YES];
    self.strategyDetailController.detail = @"\t开放时间:周二至周日9:00-17:00周一休馆，国家法定节假日照常开放(可携带身份证、学生证、老年证等有效证件免费领票参观)。";
    self.strategyDetailController.title = declare.visit;
}

- (IBAction)trafficAction:(UIButton *)sender
{
    
    [self.navigationController pushViewController:self.strategyDetailController animated:YES];
    self.strategyDetailController.detail = @"\t地    址:济南市经十路11777号（新馆）\n\t公交信息:1、乘坐115、119、K139路公交车，下井村站下车。\n\t2、乘坐BRT-5、202路公交车，华洋名苑站下车，沿经十路东行500米。\n\t3、乘坐102路到省中医(路口西),下车步行315米\n\t4、 乘坐18、62、63、150路公交车，一建新村站下车，沿姚家东路南行500米。";
    self.strategyDetailController.title = declare.traffic;
    
}

- (IBAction)ServiceAction:(UIButton *)sender
{
    HDArriveViewController *arriveViewController= [[HDArriveViewController alloc]init];
    [self presentViewController:arriveViewController animated:YES completion:nil];
}

- (IBAction)ticketAction:(UIButton *)sender
{
    [self.navigationController pushViewController:self.strategyDetailController animated:YES];
    self.strategyDetailController.detail = @"\t展厅咨询电话:0531-82620869\n\t办公室电话:0531-82953407\n\t邮政编码:250011";
    self.strategyDetailController.title = declare.museumInfo;
}

- (IBAction)aroundAction:(UIButton *)sender
{
    [self.navigationController pushViewController:self.strategyDetailController animated:YES];
    self.strategyDetailController.detail= @"\thttp://www.sdam.org.cn";
    self.strategyDetailController.title = declare.website;
}
@end
