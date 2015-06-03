//
//  ResetPasswordCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ResetPasswordCell.h"

@implementation ResetPasswordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)ResetPassword:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
@end
