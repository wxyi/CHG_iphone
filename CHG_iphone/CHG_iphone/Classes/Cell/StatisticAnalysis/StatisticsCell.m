//
//  StatisticsCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StatisticsCell.h"

@implementation StatisticsCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.bottomview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -20, 30)];
    self.bottomview.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:self.bottomview];
    
    self.bgview = [[UIView alloc] initWithFrame:CGRectZero];
    [self.bottomview addSubview:self.bgview];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStatistics:(NSString*)date number:(NSInteger)number
{
    CGRect frame = self.bgview.frame;
    frame.size.width = 160;
    frame.origin.x = 0;
    frame.size.height = 30;
    frame.size.width += number;
    self.bgview.frame = frame;
    self.bgview.backgroundColor = [UIColor grayColor];
    
    self.dateLab = [[UILabel alloc] initWithFrame:frame];
    self.dateLab.textAlignment = NSTextAlignmentLeft;
    self.dateLab.font = FONT(12);
    self.dateLab.text = date;
    [self.bgview addSubview:self.dateLab];
    
    frame.size.width -= 10;
    self.numlab = [[UILabel alloc] initWithFrame:frame];
    self.numlab.textAlignment = NSTextAlignmentRight;
    self.numlab.font = FONT(12);
    self.numlab.text = [NSString stringWithFormat:@"%d",number];
    [self.bgview addSubview:self.numlab];
    
}
@end
