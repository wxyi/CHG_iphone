//
//  ResetPasswordCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,weak)IBOutlet NoCopyTextField* resetpasswordField;
@property(nonatomic,weak)IBOutlet NoCopyTextField* confirmpasswordfield;
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;

-(IBAction)ResetPassword:(UIButton*)sender;
@end
