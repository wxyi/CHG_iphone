//
//  ForgetViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)STAlertView* stAlertView;
@property(nonatomic,strong)NSString* strCheckCode;
@end

