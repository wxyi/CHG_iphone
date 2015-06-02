//
//  ForgotPasswordCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ForgotPasswordCell.h"

@implementation ForgotPasswordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupCell
{
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0; //圆角
    self.bgView.layer.borderColor = [[UIColor blackColor] CGColor];
}
-(IBAction)ForgotPassword:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
@end
