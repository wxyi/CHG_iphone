//
//  BanKCardCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface BanKCardCell : SWTableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* BankImage;
@property(nonatomic,weak)IBOutlet UILabel* BankNameLab;
@property(nonatomic,weak)IBOutlet UILabel* tailNumLab;
@property(nonatomic,weak)IBOutlet UILabel* CardTypeLab;
@end
