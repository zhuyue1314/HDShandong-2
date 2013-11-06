//
//  HDScrollView.m
//  HDNHMuseum
//
//  Created by Liuzhuan on 13-10-28.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDScrollView.h"

@implementation HDScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}
-(void)awakeFromNib
{
    self.delegate = self;
    self.contentSize = CGSizeMake(320, self.frame.size.height);
    self.backgroundColor = [UIColor grayColor];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320, 568)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self addGestureRecognizer:singleTap];
//    scaled = NO;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (self.hidden)
    {
        self.hidden = NO;
//        [self.hdDelegate HDScrollViewDelegateZoomOut:self];
//        scaled = NO;
    }
    else
    {
        self.hidden = YES;
//        [self.hdDelegate HDScrollViewDelegateZoomIn:self];
//        scaled = YES;
    }
}
@end
