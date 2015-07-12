//
//  LoginCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,weak)IBOutlet UITextField* userTextfield;
@property(nonatomic,weak)IBOutlet UITextField* passwordTextfield;
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;

-(IBAction)Login:(UIButton*)sender;

@end
