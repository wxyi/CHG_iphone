//
//  StatisticsCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StatisticsCell.h"

@implementation StatisticsCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.bottomview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -20, 35)];
    self.bottomview.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:self.bottomview];
    
    self.bgview = [[UIView alloc] initWithFrame:CGRectZero];
//    self.bgview.backgroundColor = UIColorFromRGB(0x)
    [self.bottomview addSubview:self.bgview];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStatistics:(NSString*)date number:(NSString*)number baseData:(NSInteger)baseData;
{
    CGRect frame = self.bgview.frame;
    
    CGFloat scale = [self getShowData:baseData CurrentData:abs([number doubleValue])];
    frame.size.width = self.bottomview.frame.size.width * scale;
    frame.origin.x = 0;
    frame.size.height = 35;
    self.bgview.frame = frame;
    
//    NSString * currentData = [NSObject currentTime];
    
    
    
    self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.bgview.frame)-10, CGRectGetHeight(self.bgview.frame))];
    self.dateLab.textAlignment = NSTextAlignmentLeft;
    self.dateLab.font = FONT(12);
    self.dateLab.textColor = [UIColor whiteColor];
    NSString* strdate;
    if (date.length > 6) {
        strdate = [date substringFromIndex:6];
        strdate = [NSString stringWithFormat:@"%d日",[strdate intValue]];
    }
    else
    {

        strdate = [date substringFromIndex:4];
        strdate = [NSString stringWithFormat:@"%d月",[strdate intValue]];
    }
    self.dateLab.text = strdate;
    [self.bgview addSubview:self.dateLab];
    
    frame.size.width -= 10;
    self.numlab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.bgview.frame)-10, CGRectGetHeight(self.bgview.frame))];
    self.numlab.textAlignment = NSTextAlignmentRight;
    self.numlab.font = FONT(12);
    self.numlab.textColor = [UIColor whiteColor];
    self.numlab.text = number;
    [self.bgview addSubview:self.numlab];
    
    if ([date isEqualToString:[NSObject currentTime]]||[date isEqualToString:[[NSObject currentTime] substringToIndex:6]])
    {
        if ([number doubleValue] < 0) {
            self.bgview.backgroundColor = UIColorFromRGB(0x99cd00);
        }
        //        else
        //        if(scale == 1)
        //        {
        //            self.bgview.backgroundColor = UIColorFromRGB(0x99cd00);
        //        }
        else
        {
            self.bgview.backgroundColor = UIColorFromRGB(0xf5a541);
        }
    }
    else
    {
        self.bgview.backgroundColor = COLOR(100, 100, 100, 0.3);
        self.numlab.textColor = UIColorFromRGB(0x646464);
        self.dateLab.textColor = UIColorFromRGB(0x646464);
    }
    
    
}
-(CGFloat)getShowData:(NSInteger)baseData CurrentData:(NSInteger)CurrentData
{
    CGFloat mMin = 0.4f;     // 最小的显示比例
    CGFloat mNormal = 0.6f;  // 正常的现实比例
    NSInteger mNormalData = baseData;  // 正常的值
    NSInteger mMaxData = baseData * 3;     // 最大值
    CGFloat mData = CurrentData;             // 当前值
    
    CGFloat result = 0.0f;
    if(mData < mNormalData) {
        result = mMin + (mNormal - mMin) * mData / mNormalData;
    }
    else if(mData == mNormalData) {
        return mNormal;
    }
    else if(mData < mMaxData) {
        result = mNormal + (1 - mNormal) * mData/ mMaxData;
    }
    else {
        result = 1.0;
    }
    
    return result;
}
@end
