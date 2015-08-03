//
//  AddShoppersCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/5.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShoppersCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UILabel* namelab;
@property(nonatomic,weak)IBOutlet NoCopyTextField* nametext;
@end
