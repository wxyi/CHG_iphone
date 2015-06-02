//
//  SetPasswordCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,weak)IBOutlet UITextField* setpasswordField;
@property(nonatomic,weak)IBOutlet UITextField* confirmpasswordfield;
@property(nonatomic,weak)IBOutlet UITextField* Verificationfield;
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;
-(void)setupCell;
-(IBAction)SetPassword:(UIButton*)sender;
@end
