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
    self.userTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.userTextfield) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 32) {
            return NO;
        }
    }
    else if (textField == self.passwordTextfield) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    return YES;
}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    if (textField.text.length < 6 && textField.text.length != 0) {
//        [SGInfoAlert showInfo:@"密码不能小于6位"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self
//                     vertical:0.6];
//        [textField resignFirstResponder];
//    }
//}
@end
