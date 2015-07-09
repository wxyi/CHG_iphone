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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = UIColorFromRGB(0xdddddd);
   
    textField.text = @"";
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.text.length == 0) {
        textField.text = self.receivablelab.text;
        return;
    }
    DLog(@"textFieldDidEndEditing");
    textField.backgroundColor = [UIColor clearColor];
    NSString* price = textField.text;
    DLog(@"price = %.1f Receivedlab = %.1f",[price doubleValue],[self.Receivedlab.text doubleValue]);
    
    if ([self.receivablelab.text doubleValue] >= [price doubleValue]) {
        self.favorablelab.text = [NSString stringWithFormat:@"%.2f",[self.receivablelab.text doubleValue] - [price doubleValue]];
        self.Receivedlab.text = [NSString stringWithFormat:@"%.2f",[price doubleValue] ];
    }
    else
    {
        textField.text = @"";
        
        NSString* info;
        if (self.orderSaletype == SaleTypeSellingGoods ||self.orderSaletype == SaleTypePresell) {
            info = @"实收金额小于或等于应收金额";
        }
        else
        {
            info = @"实退金额小于或等于应退金额";
        }
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self
                     vertical:0.7];
    }

   
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        _isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];
        if ((single>='0' && single<='9') || single=='.')
        {
            //数据格式正确
            if (single=='.')
            { //判断是否有小数点
                if(!_isHaveDian)
                {
                    _isHaveDian=YES;
                    return YES;
                }
                else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (_isHaveDian)
                {
                    //判断小数点的位数
                    NSLog(@"%@",textField.text);
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt=range.location-ran.location;
                    NSLog(@"............%d......",tt);
                    if (tt<=2)
                        return YES;
                    else
                        return NO;
                }
                else
                {
                    return YES;
                }
            }
        }
        else
        {
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
}
@end
