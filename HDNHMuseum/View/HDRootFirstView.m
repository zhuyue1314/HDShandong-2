//
//  HDRootFirstView.m
//  HDTianJin
//
//  Created by Li Shijie on 13-9-3.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDRootFirstView.h"
#import "HDDeclare.h"

@interface HDRootFirstView ()
@property(nonatomic,strong) UIButton *generalButton;
@property(nonatomic,strong)UILabel *generalLabel;
@property(nonatomic,strong)UIButton *mapButton;
@property(nonatomic,strong)UILabel *mapLabel;
@property(nonatomic,strong)UIButton *bookButton;
@property(nonatomic,strong)UILabel *bookLabel;
@property(nonatomic,strong)UIButton *interfaceButton;
@property(nonatomic,strong)UILabel *interfaceLabel;
@property(nonatomic,strong)UIButton *broadcastButton;
@property(nonatomic,strong)UILabel *broadcastLabel;
@property(nonatomic,strong)UIButton *friendButton;
@property(nonatomic,strong)UILabel *friendLabel;
@property(nonatomic,strong)UIButton *resourceButton;
@property(nonatomic,strong)UILabel *resourceLabel;
@end
static HDDeclare *declare;
@implementation HDRootFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        declare = [HDDeclare sharedDeclare];
        _generalButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_generalButton setBackgroundImage:[UIImage imageNamed:@"general"] forState:UIControlStateNormal];
        
        _generalButton.frame = CGRectMake(20, 60, 83, 80);
        _generalButton.tag = 101;
        [_generalButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_generalButton];
         _generalLabel= [[UILabel alloc]initWithFrame:CGRectMake(23, 120, 80, 20)];
        
        _generalLabel.backgroundColor = [UIColor clearColor];
        _generalLabel.textColor = [UIColor blackColor];
        _generalLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_generalLabel];
        
        
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton setBackgroundImage:[UIImage imageNamed:@"interface"] forState:UIControlStateNormal];
        _mapButton.frame = CGRectMake(113, 60, 83, 80);
        _mapButton.tag = 102;
        [_mapButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapButton];
        
        _mapLabel= [[UILabel alloc]initWithFrame:CGRectMake(116, 120, 80, 20)];
   
        _mapLabel.backgroundColor = [UIColor clearColor];
        _mapLabel.textColor = [UIColor whiteColor];
        _mapLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_mapLabel];
        
        _bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookButton setBackgroundImage:[UIImage imageNamed:@"broadcast"] forState:UIControlStateNormal];
        _bookButton.frame = CGRectMake(20, 150, 83, 80);
        _bookButton.tag = 103;
        [_bookButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookButton];
        _bookLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 210, 80, 20)];
        
        _bookLabel.backgroundColor = [UIColor clearColor];
        _bookLabel.textColor = [UIColor whiteColor];
        _bookLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_bookLabel];

        
         _interfaceButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_interfaceButton setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        _interfaceButton.frame = CGRectMake(113, 150, 83, 80);
        _interfaceButton.tag = 104;
        [_interfaceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_interfaceButton];
        
        _interfaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(116, 210, 80, 20)];
        
        _interfaceLabel.backgroundColor = [UIColor clearColor];
        _interfaceLabel.textColor = [UIColor blackColor];
        _interfaceLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_interfaceLabel];
        
         _broadcastButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_broadcastButton setBackgroundImage:[UIImage imageNamed:@"book"] forState:UIControlStateNormal];
        _broadcastButton.frame = CGRectMake(20, 240, 83, 80);
        _broadcastButton.tag = 105;
        [_broadcastButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_broadcastButton];
         _broadcastLabel= [[UILabel alloc]initWithFrame:CGRectMake(23, 300, 80, 20)];
        
        _broadcastLabel.backgroundColor = [UIColor clearColor];
        _broadcastLabel.textColor = [UIColor blackColor];
        _broadcastLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_broadcastLabel];
        
        
         _friendButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_friendButton setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
        _friendButton.frame = CGRectMake(113, 240, 83, 80);
        _friendButton.tag = 106;
        [_friendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_friendButton];
        
         _friendLabel= [[UILabel alloc]initWithFrame:CGRectMake(116, 300, 80, 20)];
        
        _friendLabel.backgroundColor = [UIColor clearColor];
        _friendLabel.textColor = [UIColor whiteColor];
        _friendLabel.font = [UIFont fontWithName:@"Arial" size:13];
        [self addSubview:_friendLabel];
        
         _resourceButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_resourceButton setBackgroundImage:[UIImage imageNamed:@"resource"] forState:UIControlStateNormal];
        _resourceButton.frame = CGRectMake(20, 330, 176, 80);
        _resourceButton.tag = 107;
        [_resourceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resourceButton];
        
        _resourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 360, 100, 20)];
        
        _resourceLabel.backgroundColor = [UIColor clearColor];
        _resourceLabel.textColor = [UIColor blackColor];
        _resourceLabel.font = [UIFont fontWithName:@"Arial" size:15];
        [self addSubview:_resourceLabel];
        [self reloadView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)reloadView
{
//    self.generalLabel.text = @"场馆简介";
//    self.mapLabel.text = @"网络互动";
//    self.bookLabel.text = @"场馆资讯";
//    self.resourceLabel.text = @"自动导览";
//    self.friendLabel.text = @"地图导航";
//    self.broadcastLabel.text = @"特色教育";
//    self.interfaceLabel.text = @"我的同伴";
    self.generalLabel.text = declare.introduce;
    self.mapLabel.text = declare.Interaction;
    self.bookLabel.text = declare.information;
    self.resourceLabel.text = declare.AutoNavigation;
    self.friendLabel.text = declare.map;
    self.broadcastLabel.text = declare.education;
    self.interfaceLabel.text = declare.myFriend;
}
-(void)buttonAction:(UIButton *)button
{
    [self.delegate rootViewWithItemTap:button.tag];
}
- (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor clearColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor clearColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
