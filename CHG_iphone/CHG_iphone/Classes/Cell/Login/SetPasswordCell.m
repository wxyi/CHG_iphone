//
//  SetPasswordCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SetPasswordCell.h"

@implementation SetPasswordCell

- (void)awakeFromNib {
    // Initialization code
    self.setpasswordField.delegate = self;
    self.confirmpasswordfield.delegate = self;
    self.Verificationfield.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)SetPassword:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender
{
    
    [self.setpasswordField resignFirstResponder];
    [self.confirmpasswordfield resignFirstResponder];
    [self.Verificationfield resignFirstResponder];
    
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    
    NSString* AlertInfo = [NSString stringWithFormat:@"已向手机号*******%@成功发送验证码,请注意查收!",[config.strMobile substringFromIndex:7]];
    
    self.stAlertView = [[STAlertView alloc] initWithTitle:AlertInfo message:@"" cancelButtonTitle:nil otherButtonTitle:@"确认" cancelButtonBlock:^{
        DLog(@"否");
        
        [self httpGetCheckCode];
        
    } otherButtonBlock:^{
        
    }];
    [self.stAlertView show];
    DLog(@"是");
    
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
//    __weak typeof(self) weakSelf = self;
//    sender.titleLabel.textColor = UIColorFromRGB(0xdddddd);
    [sender setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
    sender.alpha=0.4;
    
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d秒后重发",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        sender.alpha=1;
//        sender.titleLabel.tintColor = UIColorFromRGB(0x171C61);
        [sender setTitleColor:UIColorFromRGB(0x171C61) forState:UIControlStateNormal];
        countDownButton.enabled = YES;
        return @"点击重新获取";
        
        
    }];
}
-(void)httpGetCheckCode
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    [parameter setObjectSafe:config.strMobile forKey:@"mobile"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetCheckCode] parameters:parameter];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
            if (self.didGetCode) {
                self.didGetCode([data objectForKeySafe:@"checkCode"]);
            }
        }
        else
        {
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self
                         vertical:0.7];
        }

        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetCheckCode];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.setpasswordField) {
        if (string.length == 0) return YES;
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    else if (textField == self.confirmpasswordfield) {
        if (string.length == 0) return YES;
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    else if (textField == self.Verificationfield) {
        if (string.length == 0) return YES;
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
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
//    if (textField.text.length < 6) {
//        [SGInfoAlert showInfo:@"密码不能小于6位"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self
//                     vertical:0.7];
//        [textField resignFirstResponder];
//    }
//}
@end
