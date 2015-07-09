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
    if (self.iphoneField.text.length == 11) {
        NSString* AlertInfo = [NSString stringWithFormat:@"已向手机号*******%@成功发送验证码,请注意查收!",[self.iphoneField.text substringFromIndex:7]];
        
        self.stAlertView = [[STAlertView alloc] initWithTitle:AlertInfo message:@"" cancelButtonTitle:nil otherButtonTitle:@"确认" cancelButtonBlock:^{
            DLog(@"否");
            
            
            [self httpCustomerBefore];
            
        } otherButtonBlock:^{
            
        }];
        [self.stAlertView show];
        
        sender.enabled = NO;
        //button type要 设置成custom 否则会闪动
        [sender startWithSecond:60];
        sender.backgroundColor = UIColorFromRGB(0xdddddd);
        sender.alpha=0.4;
//        sender.titleLabel.textColor = UIColorFromRGB(0xdddddd);
        [sender setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            sender.alpha=1;
            countDownButton.enabled = YES;
            [sender setTitleColor:UIColorFromRGB(0x171C61) forState:UIControlStateNormal];
//            sender.titleLabel.tintColor = UIColorFromRGB(0x171C61);
            return @"点击重新获取";
            
        }];
       
        
    }
    else
    {
        
        if (self.didshowInfo) {
            self.didshowInfo(@"请输入手机号码");
        }
    }
    
    
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
    [parameter setObject:self.iphoneField.text forKey:@"mobile"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetCheckCode] parameters:parameter];
    
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
            if (self.didGetCode) {
                self.didGetCode([data objectForKey:@"checkCode"]);
            }
        }
        else
        {
            
            if (self.didshowInfo) {
                self.didshowInfo(msg);
            }
        }
        
        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

-(void)httpCustomerBefore
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:self.iphoneField.text forKey:@"mobile"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCreateCustomerBefore] parameters:parameter];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setObject:self.iphoneField.text forKey:@"mobile"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:parame successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200)
        {
            
            if (self.didGetCode) {
                self.didGetCode([[data objectForKey:@"datas"] objectForKey:@"checkCode"]);
            }
            
        }
        else
        {
            if (self.didshowInfo) {
                self.didshowInfo([data objectForKey:@"msg"]);
            }
        }
        
        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
