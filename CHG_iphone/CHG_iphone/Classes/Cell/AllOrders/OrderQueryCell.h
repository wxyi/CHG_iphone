//
//  OrderQueryCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
@interface OrderQueryCell : UITableViewCell<QRadioButtonDelegate>
@property(nonatomic,weak)IBOutlet UITextField* starttime;
@property(nonatomic,weak)IBOutlet UITextField* endtime;
-(IBAction)QueryOrderBtn:(UIButton*)sender;
-(void)setupCell;
@end
