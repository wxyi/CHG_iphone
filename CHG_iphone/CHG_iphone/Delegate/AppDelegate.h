//
//  AppDelegate.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/18.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)setupLoginViewController;
-(void)setupHomePageViewController;
-(void)setupStoreManagementViewController;
@end

