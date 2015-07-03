//
//  MyAccountViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)NSDictionary* dictionary;
@property(nonatomic,strong)UserConfig* config;

@property(nonatomic,strong)NSString* strYear;
@property(nonatomic,strong)NSString* strMonth;
@property(nonatomic,strong)NSString* strDay;
@end
