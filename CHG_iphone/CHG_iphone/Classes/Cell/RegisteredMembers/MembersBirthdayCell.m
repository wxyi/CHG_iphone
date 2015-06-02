//
//  MembersBirthdayCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MembersBirthdayCell.h"

@implementation MembersBirthdayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupCell
{
    
//    self.bgview.layer.borderWidth = 1;
    self.bgview.layer.masksToBounds = YES;
    self.bgview.layer.cornerRadius = 10.0; //圆角
    
//    self.bglabel.layer.borderWidth = 1;
    self.bglabel.layer.masksToBounds = YES;
    self.bglabel.layer.cornerRadius = 10.0; //圆角
    //    self.bgView.layer.borderColor = [[UIColor blackColor] CGColor];
}
@end
