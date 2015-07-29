//
//  PresellCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextStepperField.h"
typedef void(^showOrderCount)(NSString* state,CGFloat price,NSIndexPath* indexPath,NSInteger count);
@interface PresellCell : SWTableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* GoodsImage;
@property(nonatomic,weak)IBOutlet UILabel* titlelab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,weak)IBOutlet TextStepperField* TextStepper;
@property(nonatomic,assign)NSInteger counter;
@property(nonatomic,strong)showOrderCount showCount;
@property(nonatomic,strong)NSIndexPath * indexPath;
@property(nonatomic,strong)NSString * operationPage;
@property(nonatomic,assign)CGFloat price;
- (IBAction)ibStepperDidStep:(id)sender ;

-(void)setupCell;
@end
