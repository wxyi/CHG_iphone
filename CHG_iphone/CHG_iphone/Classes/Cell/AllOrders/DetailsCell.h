//
//  DetailsCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* imageview;
@property(nonatomic,weak)IBOutlet UILabel* titlelab;
@property(nonatomic,weak)IBOutlet UILabel* describelab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@end
