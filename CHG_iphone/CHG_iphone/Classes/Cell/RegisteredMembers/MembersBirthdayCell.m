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

    [self.Birthdayfield setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
