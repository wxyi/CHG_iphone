//
//  StoreManageCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/5.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreManageCell : BaseCell
@property(nonatomic,weak)IBOutlet UILabel* nameAndIphonelab;
@property(nonatomic,weak)IBOutlet UILabel* positionlab;
@property(nonatomic,weak)IBOutlet UIImageView* icon;
@property(nonatomic,weak)IBOutlet UIButton* Disablebtn;
@property(nonatomic,strong)NSIndexPath* IndexPath;
@property (nonatomic, copy) AccountBriefSelect didselectDisable;
-(IBAction)skipdetails:(UIButton*)sender;
@end
