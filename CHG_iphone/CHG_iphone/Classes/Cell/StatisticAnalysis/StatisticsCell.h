//
//  StatisticsCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsCell : UITableViewCell
@property(nonatomic,strong) UIView* bgview;
@property(nonatomic,strong) UILabel* dateLab;
@property(nonatomic,strong) UILabel* numlab;

-(void)setStatistics:(NSString*)date number:(NSString*)number;
@end
