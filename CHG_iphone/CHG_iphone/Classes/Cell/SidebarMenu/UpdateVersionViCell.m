//
//  UpdateVersionViCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "UpdateVersionViCell.h"

@implementation UpdateVersionViCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)setUpdateVersionCell
//{
//    self.image.layer.masksToBounds =YES;
//    
//    self.image.layer.cornerRadius =20;
//    
//    UIButton* DownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    DownBtn.backgroundColor = [UIColor blueColor];
//    [DownBtn.layer setMasksToBounds:YES];
//    [DownBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
////    [DownBtn.layer setBorderWidth:1.0]; //边框宽度
//    DownBtn.tag = 100;
//    DownBtn.frame = CGRectMake(SCREEN_WIDTH-90, 10, 80, 40);
//    [DownBtn setTitle:@"下载" forState:UIControlStateNormal];
//    [DownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [DownBtn addTarget:self action:@selector(DownVersion:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:DownBtn];
//}
-(IBAction)DownVersion:(id)sender
{
    DLog(@"下载");
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d",111];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
