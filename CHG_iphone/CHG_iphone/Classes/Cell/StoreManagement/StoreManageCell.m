//
//  StoreManageCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/5.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreManageCell.h"

@implementation StoreManageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)skipdetails:(UIButton*)sender
{
    if (self.didselectDisable) {
        self.didselectDisable(self.IndexPath);
    }
}
@end
