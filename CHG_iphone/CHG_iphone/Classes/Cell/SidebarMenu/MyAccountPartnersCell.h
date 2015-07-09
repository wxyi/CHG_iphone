//
//  MyAccountPartnersCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/7/8.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountPartnersCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView * tableview;
@property(nonatomic,strong)NSDictionary* dictionary;
@property(nonatomic,strong) MyAccountSkip accountSkip;
-(void)setUpCell;
@end
