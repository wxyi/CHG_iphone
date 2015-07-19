//
//  ForgotPasswordCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ForgotPasswordCell.h"

@implementation ForgotPasswordCell

- (void)awakeFromNib {
    // Initialization code
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
//    
//    self.userField.leftView = paddingView;
//    
//    self.userField.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.Verificationfield.leftView = paddingView;
//    self.Verificationfield.leftViewMode = UITextFieldViewModeAlways;
    self.Verificationfield.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)ForgotPassword:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender
{
    [self.userField resignFirstResponder];
    [self.Verificationfield resignFirstResponder];
    if (self.userField.text.length == 0) {
        [SGInfoAlert showInfo:@"请输入手机号码"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self
                     vertical:0.7];
    }
    
    
    if (self.userField.text.length == 11)
    {
        NSString* AlertInfo = [NSString stringWithFormat:@"已向手机号*******%@成功发送验证码,请注意查收!",[self.userField.text substringFromIndex:7]];
        
        self.stAlertView = [[STAlertView alloc] initWithTitle:AlertInfo message:@"" cancelButtonTitle:nil otherButtonTitle:@"确认" cancelButtonBlock:^{
            DLog(@"否");
            [self httpGetCheckCode];
            
            
        } otherButtonBlock:^{
            
        }];
        [self.stAlertView show];
        //    [self httpGetCheckCode];
        
        sender.enabled = NO;
        
//        sender.titleLabel.textColor = ;
        [sender setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
        //button type要 设置成custom 否则会闪动
        [sender startWithSecond:60];
        sender.alpha=0.4;
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            sender.alpha=1;
//            sender.titleLabel.tintColor = UIColorFromRGB(0x171C61);
            [sender setTitleColor:UIColorFromRGB(0x171C61) forState:UIControlStateNormal];
            countDownButton.enabled = YES;
            return @"点击重新获取";
            
        }];
    }
    
}

-(void)httpGetCheckCode
{
//    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:self.userField.text forKey:@"mobile"];
//    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetCheckCode] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        
        if (success) {
            [MMProgressHUD dismiss];
            if (self.didGetCode) {
                self.didGetCode([data objectForKey:@"checkCode"]);
            }
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
////            [SGInfoAlert showInfo:msg
////                          bgColor:[[UIColor darkGrayColor] CGColor]
////                           inView:self
////                         vertical:0.7];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.Verificationfield) {
        if (string.length == 0) return YES;
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
    return YES;
}

@end
