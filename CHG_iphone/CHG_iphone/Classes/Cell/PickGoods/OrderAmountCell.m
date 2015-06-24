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
    DLog(@"price = %.1f Receivedlab = %.1f",[price doubleValue],[self.Receivedlab.text doubleValue]);
    
    if ([self.receivablelab.text intValue] >= [price intValue]) {
        self.favorablelab.text = [NSString stringWithFormat:@"%.2f",[self.receivablelab.text doubleValue] - [price doubleValue]];
        self.Receivedlab.text = [NSString stringWithFormat:@"%.2f",[price doubleValue] ];
    }
    else
    {
        textField.text = @"";
        [SGInfoAlert showInfo:@"实退金额大于应退金额"
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self
                     vertical:0.7];
    }

   
    
}
@end
