//
//  pinCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pinCell : BaseCell
@property(nonatomic,weak)IBOutlet UILabel* datelab;
@property(nonatomic,weak)IBOutlet UILabel* statelab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,strong)NSString* strOrderId;
@property (nonatomic, copy) skipDetailsPage skipdetails;
-(IBAction)skipdetails:(UIButton*)sender;
@end
