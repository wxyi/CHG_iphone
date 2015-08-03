//
//  IdentUserInfoCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentUserInfoCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet NoCopyTextField* iphonelab;
@property(nonatomic,weak)IBOutlet UILabel* namelab;
@property (nonatomic, copy) GetCheckCode didGetCode;
@end
