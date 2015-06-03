//
//  OrderGiftCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/26.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextStepperField.h"
@interface OrderGiftCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* GoodImage;
@property(nonatomic,weak)IBOutlet UILabel* titlelab;
@property(nonatomic,weak)IBOutlet TextStepperField* TextStepper;
@property(nonatomic,assign)NSInteger counter;
- (IBAction)ibStepperDidStep:(id)sender ;
-(void)setupCell;
@end
