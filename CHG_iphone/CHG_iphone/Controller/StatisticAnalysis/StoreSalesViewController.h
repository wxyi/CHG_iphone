//
//  StoreSalesViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "StoreSalesDayViewController.h"
#import "StoreSalesMonthViewController.h"
#import "StoreSalesYearViewController.h"
@interface StoreSalesViewController : UIViewController<QCSlideSwitchViewDelegate>
@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) StoreSalesDayViewController *StoreSalesDay;
@property (nonatomic, strong) StoreSalesMonthViewController *StoreSalesMonth;
@property (nonatomic, strong) StoreSalesYearViewController *StoreSalesYear;

@property (nonatomic, assign) StatisticalType statisticalType;
@property (nonatomic, strong) BaseViewController *vcAll;

@property (nonatomic, assign) BOOL isSkip;
@property (nonatomic, assign) BOOL isRefresh;
@property(nonatomic,strong)NSString* strYear;
@property(nonatomic,strong)NSString* strMonth;
@property(nonatomic,strong)NSString* strDay;
@end
