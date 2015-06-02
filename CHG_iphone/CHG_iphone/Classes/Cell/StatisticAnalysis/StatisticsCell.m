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
    self.bgview = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.bgview];
    
    

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStatistics:(NSString*)date number:(NSString*)number
{
    CGRect frame = self.bgview.frame;
    frame.size.width = 160;
    frame.origin.x = 10;
    frame.size.height = 30;
    frame.size.width += [number intValue];
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
    self.numlab.text = number;
    [self.bgview addSubview:self.numlab];
    
}
@end
