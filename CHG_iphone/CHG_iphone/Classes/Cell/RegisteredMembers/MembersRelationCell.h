//
//  MembersRelationCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface MembersRelationCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIView* bgview;
@property (nonatomic, strong) IBOutlet UILabel* bglabel;
@property (nonatomic, strong) IBOutlet RadioButton* radioButton;

-(IBAction)selectRadio:(UIButton*)sender;
@end
