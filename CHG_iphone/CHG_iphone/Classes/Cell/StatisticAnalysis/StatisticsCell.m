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
    [self.bottomview addSubview:self.bgview];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStatistics:(NSString*)date number:(NSInteger)number baseData:(NSInteger)baseData;
{
    CGRect frame = self.bgview.frame;
    
    CGFloat scale = [self getShowData:baseData CurrentData:number];
    frame.size.width = self.bottomview.frame.size.width * scale;
    frame.origin.x = 0;
    frame.size.height = 30;
    self.bgview.frame = frame;
    
//    NSString * currentData = [NSObject currentTime];
    if ([date isEqualToString:[NSObject currentTime]]||[date isEqualToString:[[NSObject currentTime] substringToIndex:6]])
        self.bgview.backgroundColor = UIColorFromRGB(0xf5a541);
    else
        self.bgview.backgroundColor = [UIColor grayColor];
    
    self.dateLab = [[UILabel alloc] initWithFrame:frame];
    self.dateLab.textAlignment = NSTextAlignmentLeft;
    self.dateLab.font = FONT(12);
    self.dateLab.text = date;
    [self.bgview addSubview:self.dateLab];
    
    frame.size.width -= 10;
    self.numlab = [[UILabel alloc] initWithFrame:frame];
    self.numlab.textAlignment = NSTextAlignmentRight;
    self.numlab.font = FONT(12);
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
