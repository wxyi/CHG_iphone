//
//  pinCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "pinCell.h"

@implementation pinCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)skipdetails:(UIButton*)sender
{
    if (self.CellSkipSelect) {
        self.CellSkipSelect(self.items);
    }
//    if (self.skipdetails) {
//        self.skipdetails(self.strOrderId);
//    }
}
@end
