//
//  PickAndReturnCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickAndReturnCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UILabel* receivableNameLab;
@property(nonatomic,weak)IBOutlet UILabel* actualNameLab;
@property(nonatomic,weak)IBOutlet NoCopyTextField* receivableLab;
@property(nonatomic,weak)IBOutlet NoCopyTextField* actualtext;
@property(nonatomic,strong)NSString* returnPrice;
@property(nonatomic,assign)BOOL isHaveDian;
@property(nonatomic,copy)OrderPrice orderpriceBlock;
@end
