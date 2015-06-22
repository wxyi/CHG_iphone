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
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    
    NSString* AlertInfo = [NSString stringWithFormat:@"已向手机号*******%@成功发送验证码,请注意查收!",[config.strMobile substringFromIndex:7]];
    
    self.stAlertView = [[STAlertView alloc] initWithTitle:AlertInfo message:@"" cancelButtonTitle:nil otherButtonTitle:@"确认" cancelButtonBlock:^{
        DLog(@"否");
        
        
        
    } otherButtonBlock:^{
        
    }];
    [self.stAlertView show];
    DLog(@"是");
    
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
//    __weak typeof(self) weakSelf = self;
    
    [self httpGetCheckCode];
    
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
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    [parameter setObject:config.strMobile forKey:@"mobile"];
    
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
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self
                         vertical:0.7];
        }

        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
