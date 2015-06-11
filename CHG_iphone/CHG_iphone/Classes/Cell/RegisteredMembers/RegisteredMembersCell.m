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

    if ([self isCorrect ]) {
        
        
        [self httpValidateCustMobile];
        sender.enabled = NO;
        //button type要 设置成custom 否则会闪动
        [sender startWithSecond:60];
        sender.backgroundColor = UIColorFromRGB(0xdddddd);
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
            
        }];
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
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiValidateMobile] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.iphoneField.text forKey:@"custMobile"];
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:self.nameField.text forKey:@"custName"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"daata = %@",data);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
        }
        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

@end
