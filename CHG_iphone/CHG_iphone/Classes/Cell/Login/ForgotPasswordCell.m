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
    if (self.userField.text.length == 0) {
        return;
    }
    [self httpGetCheckCode];
    
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
        
    }];
}

-(void)httpGetCheckCode
{
//    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:self.userField.text forKey:@"mobile"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetCheckCode] parameters:parameter];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        
//        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        [delegate setupHomePageViewController];
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
