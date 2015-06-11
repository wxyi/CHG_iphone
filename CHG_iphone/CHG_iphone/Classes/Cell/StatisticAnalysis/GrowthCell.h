//
//  GrowthCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowthCell : BaseCell
@property(nonatomic,weak)IBOutlet UILabel* datelab;
@property(nonatomic,weak)IBOutlet UILabel* statelab;
@property(nonatomic,weak)IBOutlet UILabel* namelab;
@property(nonatomic,weak)IBOutlet UILabel* iphonelab;

-(IBAction)skipdetails:(UIButton*)sender;
@end
