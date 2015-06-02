//
//  StoreManagementViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/26.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"
@interface StoreManagementViewController : UIViewController<DropDownChooseDelegate,DropDownChooseDataSource>
-(IBAction)goSkipStore:(id)sender;
@end
