//
//  SettlementCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettlementCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel* namelab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,weak)IBOutlet UILabel* BankCardlab;
@property(nonatomic,weak)IBOutlet UILabel* CardNumlab;
@end