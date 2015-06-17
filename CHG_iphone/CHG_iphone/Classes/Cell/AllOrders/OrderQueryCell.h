//
//  OrderQueryCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
typedef void(^SelectQRadioBtn)(NSString* strtitle);
typedef void(^QueryOrderList)(NSInteger tag);

@interface OrderQueryCell : UITableViewCell<QRadioButtonDelegate>
@property(nonatomic,weak)IBOutlet UITextField* starttime;
@property(nonatomic,weak)IBOutlet UITextField* endtime;
@property(nonatomic,strong)SelectQRadioBtn selectQradio;
@property(nonatomic,strong)QueryOrderList queryOrder;

-(IBAction)QueryOrderBtn:(UIButton*)sender;
-(void)setupCell;
@end
