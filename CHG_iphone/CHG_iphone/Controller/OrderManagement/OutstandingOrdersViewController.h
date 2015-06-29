//
//  OutstandingOrdersViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutstandingOrdersViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* returnBtn;
@property(nonatomic,weak)IBOutlet UIButton* PickupBtn;
@property(nonatomic,strong)NSMutableArray* items;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
@property(nonatomic,strong)STAlertView* stAlertView;
@property(nonatomic,assign)NSInteger m_nPageNumber;
-(IBAction)Returngoods:(UIButton*)sender;
@end
