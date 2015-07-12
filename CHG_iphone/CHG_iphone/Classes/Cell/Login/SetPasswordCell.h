//
//  SetPasswordCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"


@interface SetPasswordCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,weak)IBOutlet UITextField* setpasswordField;
@property(nonatomic,weak)IBOutlet UITextField* confirmpasswordfield;
@property(nonatomic,weak)IBOutlet UITextField* Verificationfield;
@property (weak, nonatomic) IBOutlet JKCountDownButton *countDownXib;
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;
@property (nonatomic, copy) GetCheckCode didGetCode;
@property(nonatomic,strong)STAlertView* stAlertView;

-(IBAction)SetPassword:(UIButton*)sender;
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender;
@end
