//
//  successfulIdentifyCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
@interface successfulIdentifyCell : UITableViewCell
@property(nonatomic,weak)IBOutlet NIAttributedLabel* goodscountlab;
@property(nonatomic,weak)IBOutlet UILabel* iphoneLab;
@property(nonatomic,weak)IBOutlet UILabel* nameLab;
@end
