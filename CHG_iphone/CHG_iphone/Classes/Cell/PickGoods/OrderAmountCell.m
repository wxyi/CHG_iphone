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
    [self.Receivedlab addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.backgroundColor = UIColorFromRGB(0xdddddd);
   
    
    
//    textField.text = @"";
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    if (textField.text.length == 0) {
//        textField.text = self.receivablelab.text;
//        return;
//    }
    textField.text = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
    DLog(@"textFieldDidEndEditing");
    textField.backgroundColor = [UIColor clearColor];
    NSString* price = textField.text;
    DLog(@"price = %.1f Receivedlab = %.1f",[price doubleValue],[self.Receivedlab.text doubleValue]);
    
    if ([self.receivablelab.text doubleValue] >= [price doubleValue]&& [price floatValue] != 0) {
        self.favorablelab.text = [NSString stringWithFormat:@"%.2f",[self.receivablelab.text doubleValue] - [price doubleValue]];
        self.Receivedlab.text = [NSString stringWithFormat:@"%.2f",[price doubleValue] ];
    }
    else if([price floatValue] <= 0)
    {
        textField.text = self.receivablelab.text;
//        [SGInfoAlert showInfo:@"实退金额应小于等于0"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self
//                     vertical:0.7];
    }
    else
    {
        textField.text = self.receivablelab.text;
        
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
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
//                    [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
                if (single == '0') {
//                    [self alertView:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            if (single=='.')
            {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian=YES;
                    return YES;
                }else
                {
//                    [self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (_isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    int tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
//                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            [self alertView:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {  
        return YES;  
    }
    
}
- (void) textFieldDidChange:(UITextField*) textField {
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {
        NSRange ran=[textField.text rangeOfString:@"."];
        int tt=textField.text.length-ran.location;
        NSLog(@"............%d......",tt);
        if (tt > 3)
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
}
@end
