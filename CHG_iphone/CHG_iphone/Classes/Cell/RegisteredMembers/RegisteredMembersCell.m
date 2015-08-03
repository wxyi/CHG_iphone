//
//  RegisteredMembersCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "RegisteredMembersCell.h"

@implementation RegisteredMembersCell

- (void)awakeFromNib {
    // Initialization code
    self.iphoneField.delegate = self;
    self.nameField.delegate = self;
    self.codeField.delegate = self;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender
{
    [self.iphoneField resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.codeField resignFirstResponder];
    if (![self isCorrect]) {
        return;
    }
    if (self.iphoneField.text.length == 11  ) {
        
        sender.enabled = NO;
        [self httpCustomerBefore];
        

    }
//    else
//    {
//        
//        if (self.didshowInfo) {
//            self.didshowInfo(@"请输入手机号码");
//        }
//    }
    
    
}
-(void)sendCheck
{
    JKCountDownButton* sender = (JKCountDownButton*)[self viewWithTag:10000];
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    sender.backgroundColor = UIColorFromRGB(0xdddddd);
    sender.alpha=0.4;
    //        sender.titleLabel.textColor = UIColorFromRGB(0xdddddd);
    [sender setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d秒后重新发送",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        sender.alpha=1;
        countDownButton.enabled = YES;
        sender.backgroundColor = UIColorFromRGB(0x171c61);
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //            sender.titleLabel.tintColor = UIColorFromRGB(0x171C61);
        return @"点击重新获取";
        
    }];
}
-(BOOL)isCorrect
{
    
    NSString* info ;
    if (self.iphoneField.text.length == 0) {
        info = @"请输入手机号码";
    }
    else if (![IdentifierValidator isValid:IdentifierTypePhone value:self.iphoneField.text ])
    {
        info = @"手机格式不正确";
    }
    else if(self.nameField.text.length == 0)
    {
        info = @"请输入姓名";
    }
    
    if (info.length != 0) {
        
        if (self.didshowInfo) {
            self.didshowInfo(info);
        }
        return NO;
    }
    return YES;
    
}
-(void)httpValidateCustMobile
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:self.iphoneField.text forKey:@"mobile"];
    
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
            
            if (self.didshowInfo) {
                self.didshowInfo(msg);
            }
        }
        
        
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpValidateCustMobile];
    }];
}

-(void)httpCustomerBefore
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:self.iphoneField.text forKey:@"mobile"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCreateCustomerBefore] parameters:parameter];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setObjectSafe:self.iphoneField.text forKey:@"mobile"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:parame successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            
            
            NSString* AlertInfo = [NSString stringWithFormat:@"已向手机号*******%@成功发送验证码,请注意查收!",[self.iphoneField.text substringFromIndex:7]];
            
            self.stAlertView = [[STAlertView alloc] initWithTitle:AlertInfo message:@"" cancelButtonTitle:nil otherButtonTitle:@"确认" cancelButtonBlock:^{
                DLog(@"否");
                
                JKCountDownButton* sender = (JKCountDownButton*)[self viewWithTag:10000];
                sender.enabled = YES;
                [self sendCheck];
                
            } otherButtonBlock:^{
                
            }];
            [self.stAlertView show];
            
            if (self.didGetCode) {
                self.didGetCode([[data objectForKeySafe:@"datas"] objectForKeySafe:@"checkCode"]);
            }
            
        }
        else
        {
            JKCountDownButton* sender = (JKCountDownButton*)[self viewWithTag:10000];
            sender.enabled = YES;
            if (self.didshowInfo) {
                self.didshowInfo([data objectForKeySafe:@"msg"]);
            }
        }
        
        
    } failureBlock:^(NSString *description) {
        
        if (self.didGetCode) {
            self.didGetCode(description);
        }
        JKCountDownButton* sender = (JKCountDownButton*)[self viewWithTag:10000];
        sender.enabled = YES;
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpCustomerBefore];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField == self.iphoneField) {
        if (string.length == 0) return YES;
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    else if (textField == self.nameField) {
        if (string.length == 0) return YES;
        
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
        
        
        
        if (textField.text.length >= 15 && string.length > range.length) {
            return NO;
        }
//        if (existedLength - selectedLength + replaceLength > 20) {
//            return NO;
//        }
    }
    else if (textField == self.codeField) {
        if (string.length == 0) return YES;
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    return YES;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    
//    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]*";
//////
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![pred evaluateWithObject:string]) {
//        return NO;
//    }
//    if (textField == self.iphoneField) {
//        if (self.iphoneField.text.length > 0) {
//            if ([[self.iphoneField.text substringToIndex:1] intValue]!= 1) {
//                if (self.didGetCode) {
//                    self.didGetCode(@"手机格式不正确");
//                }
//            }
//        }
//    }
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (self.iphoneField.text.length != 11) {
//        if (self.didGetCode) {
//            self.didGetCode(@"手机格式不正确");
//        }
//    }
//}
@end
