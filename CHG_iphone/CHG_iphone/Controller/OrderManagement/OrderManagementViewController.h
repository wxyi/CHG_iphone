//
//  OrderManagementViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "AllOrdersViewController.h"
#import "OutstandingOrdersViewController.h"
#import "CompleteOrderViewController.h"
@interface OrderManagementViewController : UIViewController<QCSlideSwitchViewDelegate>
@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) AllOrdersViewController *AllOrdersView;
@property (nonatomic, strong) OutstandingOrdersViewController *OutstandingOrdersView;
@property (nonatomic, strong) CompleteOrderViewController *CompleteOrderView;
@property(nonatomic,strong)STAlertView* stAlertView;
@property (nonatomic, strong) BaseViewController *vcAll;
@property (nonatomic, strong) NSString* strCustId;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
@end
