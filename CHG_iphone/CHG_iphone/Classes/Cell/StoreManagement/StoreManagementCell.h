//
//  StoreManagementCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreManagementCell : BaseCell
@property(nonatomic,weak)IBOutlet UIImageView* icon;

@property(nonatomic,weak)IBOutlet UILabel* nameAndIphonelab;
@property(nonatomic,weak)IBOutlet UILabel* positionlab;
@property(nonatomic,weak)IBOutlet UIImageView* sconImage;
-(IBAction)showQrcode:(UIButton*)sender;
@end
