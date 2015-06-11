//
//  StoreManagementCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreManagementCell.h"

@implementation StoreManagementCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)showQrcode:(UIButton*)sender
{
    DLog(@"二维码显示");
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
@end
