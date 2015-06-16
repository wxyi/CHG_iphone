//
//  OrderAmountCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderAmountCell.h"

@implementation OrderAmountCell

- (void)awakeFromNib {
    // Initialization code
    self.Receivedlab.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    DLog(@"textFieldDidEndEditing");
    NSString* price = textField.text;
    
    self.favorablelab.text = [NSString stringWithFormat:@"%.1f",self.allprice - [price doubleValue]];
}
@end
