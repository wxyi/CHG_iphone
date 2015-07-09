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
    
    
    self.bottomview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -20, 30)];
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
-(void)setStatistics:(NSString*)date number:(NSInteger)number baseData:(NSInteger)baseData;
{
    CGRect frame = self.bgview.frame;
    
    CGFloat scale = [self getShowData:baseData CurrentData:abs(number)];
    frame.size.width = self.bottomview.frame.size.width * scale;
    frame.origin.x = 0;
    frame.size.height = 30;
    self.bgview.frame = frame;
    
//    NSString * currentData = [NSObject currentTime];
    if (number < 0) {
        self.bgview.backgroundColor = UIColorFromRGB(0x99cd00);
    }
    else if ([date isEqualToString:[NSObject currentTime]]||[date isEqualToString:[[NSObject currentTime] substringToIndex:6]])
        self.bgview.backgroundColor = UIColorFromRGB(0xf5a541);
    else
        self.bgview.backgroundColor = COLOR(100, 100, 100, 0.3);
    
    self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.bgview.frame)-10, CGRectGetHeight(self.bgview.frame))];
    self.dateLab.textAlignment = NSTextAlignmentLeft;
    self.dateLab.font = FONT(12);
    self.dateLab.textColor = [UIColor whiteColor];
    self.dateLab.text = date;
    [self.bgview addSubview:self.dateLab];
    
    frame.size.width -= 10;
    self.numlab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.bgview.frame)-10, CGRectGetHeight(self.bgview.frame))];
    self.numlab.textAlignment = NSTextAlignmentRight;
    self.numlab.font = FONT(12);
    self.numlab.textColor = [UIColor whiteColor];
    self.numlab.text = [NSString stringWithFormat:@"%d",number];
    [self.bgview addSubview:self.numlab];
    
}
-(CGFloat)getShowData:(NSInteger)baseData CurrentData:(NSInteger)CurrentData
{
    CGFloat mMin = 0.4f;     // 最小的显示比例
    CGFloat mNormal = 0.6f;  // 正常的现实比例
    NSInteger mNormalData = baseData;  // 正常的值
    NSInteger mMaxData = baseData * 3;     // 最大值
    NSInteger mData = CurrentData;             // 当前值
    
    CGFloat result = 0.0f;
    if(mData < mNormalData) {
        result = mMin + (mNormal - mMin)/(mNormalData - mData);
    }
    else if(mData == mNormalData) {
        return mNormal;
    }
    else {
        if (mMaxData - mData <= 0) {
            result = 1;
        }
        else
        {
            result = mNormal + (1-mNormal)/(mMaxData - mData);
        }
        
    }
    
    return result;
}
@end
