//
//  ForgotPasswordCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,weak)IBOutlet UITextField* userField;
@property(nonatomic,weak)IBOutlet UITextField* Verificationfield;
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;
-(void)setupCell;
-(IBAction)ForgotPassword:(UIButton*)sender;
@end
