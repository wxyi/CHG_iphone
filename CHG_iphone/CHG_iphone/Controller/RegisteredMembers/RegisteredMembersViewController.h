//
//  RegisteredMembersViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteredMembersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSString* strIphone;
@property(nonatomic,strong)NSString* strCheckCode;
@property(nonatomic,assign)OrderReturnType ordertype;
@end
