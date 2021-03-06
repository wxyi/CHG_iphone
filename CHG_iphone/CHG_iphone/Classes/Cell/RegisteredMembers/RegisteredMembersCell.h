//
//  RegisteredMembersCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"
@interface RegisteredMembersCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet NoCopyTextField* iphoneField;
@property(nonatomic,weak)IBOutlet NoCopyTextField* nameField;
@property(nonatomic,weak)IBOutlet NoCopyTextField* codeField;
@property(nonatomic,strong)STAlertView* stAlertView;
@property (nonatomic, copy) ShowInfoAlert didshowInfo;
@property (nonatomic, copy) GetCheckCode didGetCode;
@property (weak, nonatomic) IBOutlet JKCountDownButton *countDownXib;
- (IBAction)countDownXibTouched:(JKCountDownButton*)sender;
@end
