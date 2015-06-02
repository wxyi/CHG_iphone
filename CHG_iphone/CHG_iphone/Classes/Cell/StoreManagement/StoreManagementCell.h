//
//  StoreManagementCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreManagementCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* icon;
@property(nonatomic,weak)IBOutlet UILabel* clerkName;
@property(nonatomic,weak)IBOutlet UILabel* clerktype;
@property(nonatomic,weak)IBOutlet UILabel* clerkiphone;
@property(nonatomic,weak)IBOutlet UIImageView* sconImage;
@end
