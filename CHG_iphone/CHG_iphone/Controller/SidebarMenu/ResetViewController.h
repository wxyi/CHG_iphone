//
//  ResetViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/17.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)NSString* strCheckCode;

@end
