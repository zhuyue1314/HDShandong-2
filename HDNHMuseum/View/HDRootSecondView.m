//
//  HDRootSecondView.m
//  HDTianJin
//
//  Created by Li Shijie on 13-9-3.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDRootSecondView.h"
#import "HDDeclare.h"
@interface HDRootSecondView ()
@property(nonatomic,strong) UIButton *photoButton;
@property(nonatomic,strong)UILabel *photoLabel;
@property(nonatomic,strong)UIButton *strategyButton;
@property(nonatomic,strong)UILabel *strategyLabel;
@end
static HDDeclare *declare;
@implementation HDRootSecondView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        declare = [HDDeclare sharedDeclare];
           _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoButton setBackgroundImage:[UIImage imageNamed:@"360"] forState:UIControlStateNormal];
            
            _photoButton.frame = CGRectMake(20, 60, 83, 80);
            _photoButton.tag = 201;
            [_photoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_photoButton];
            _photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 120, 80, 20)];
        
            _photoLabel.backgroundColor = [UIColor clearColor];
            _photoLabel.textColor = [UIColor blackColor];
            _photoLabel.font = [UIFont fontWithName:@"Arial" size:13];
            [self addSubview:_photoLabel];
            
            
            _strategyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_strategyButton setBackgroundImage:[UIImage imageNamed:@"strategy"] forState:UIControlStateNormal];
            _strategyButton.frame = CGRectMake(113, 60, 83, 80);
            _strategyButton.tag = 202;
            [_strategyButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_strategyButton];
            
            _strategyLabel = [[UILabel alloc]initWithFrame:CGRectMake(116, 120, 80, 20)];
        
            _strategyLabel.backgroundColor = [UIColor clearColor];
            _strategyLabel.textColor = [UIColor whiteColor];
            _strategyLabel.font = [UIFont fontWithName:@"Arial" size:13];
            [self addSubview:_strategyLabel];
            [self reloadView];
//            UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [collectionButton setBackgroundImage:[UIImage imageNamed:@"store"] forState:UIControlStateNormal];
//            collectionButton.frame = CGRectMake(20, 150, 83, 80);
//            collectionButton.tag = 203;
//            [collectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:collectionButton];
//            UILabel *collectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 210, 80, 20)];
//            collectionLabel.text = @"电子商务";
//            collectionLabel.backgroundColor = [UIColor clearColor];
//            collectionLabel.textColor = [UIColor blackColor];
//            collectionLabel.font = [UIFont fontWithName:@"Arial" size:13];
//            [self addSubview:collectionLabel];
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
    self.photoLabel.text =declare.Panoramic ;
    self.strategyLabel.text = declare.strategy;
}
-(void)buttonAction:(UIButton *)button
{
    [self.delegate rootSecondViewItemTap:button.tag];
}
@end
