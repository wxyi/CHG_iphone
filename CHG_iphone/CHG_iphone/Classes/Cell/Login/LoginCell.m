//
//  LoginCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(void)setupCell
{
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10.0; //圆角
    self.bgView.layer.borderColor = [[UIColor blackColor] CGColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)Login:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
@end
