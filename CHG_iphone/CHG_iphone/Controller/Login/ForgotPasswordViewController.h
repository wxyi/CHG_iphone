//
//  ForgotPasswordViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSString* strmobile;
@property(nonatomic,strong)NSString* strCheckCode;
@end
