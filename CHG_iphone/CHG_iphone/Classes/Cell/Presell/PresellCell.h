//
//  PresellCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextStepperField.h"
@interface PresellCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* GoodsImage;
@property(nonatomic,weak)IBOutlet UILabel* titlelab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,weak)IBOutlet TextStepperField* TextStepper;
@property(nonatomic,assign)NSInteger counter;
- (IBAction)ibStepperDidStep:(id)sender ;

-(void)setupCell;
@end
