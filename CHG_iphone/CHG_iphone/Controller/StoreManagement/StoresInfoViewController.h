//
//  StoresInfoViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoresInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* addbtn;
@property(nonatomic,weak)IBOutlet UIButton* addshopperbtn;
@property(nonatomic,weak)IBOutlet UIButton* addonebtn;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,strong)NSDictionary* shopinfo;
@property(nonatomic,strong)STAlertView* stAlertView;
@property(nonatomic,strong)UserConfig* config;
@property (nonatomic,strong)NSString* stAlert;
@property(nonatomic,assign)BOOL ispush;
-(IBAction)addStoresInfo:(UIButton*)sender;
@end
