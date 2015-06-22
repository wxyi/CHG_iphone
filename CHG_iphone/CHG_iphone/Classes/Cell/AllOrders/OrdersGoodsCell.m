//
//  OrdersGoodsCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/26.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrdersGoodsCell.h"

@implementation OrdersGoodsCell

- (void)awakeFromNib {
    // Initialization code
    self.GoodImage.layer.borderColor = [UIColorFromRGB(0xdddddd) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
