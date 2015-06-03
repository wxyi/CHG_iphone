//
//  RegisteredMembersCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"
@interface RegisteredMembersCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UITextField* textField;
@property(nonatomic,weak)IBOutlet UILabel* namelab;
@property(nonatomic,weak)IBOutlet UIButton* Verification;
@property (weak, nonatomic) IBOutlet JKCountDownButton *countDownXib;
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender;
@end
