//
//  CHGNavigationController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/21.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseNavigationController.h"
@interface CHGNavigationController : APBaseNavigationController
@property (nonatomic,strong)STAlertView* stAlertView;
@property (nonatomic,strong)UIPanGestureRecognizer* PanGest;
- (void)showMenu;
- (void)goback;
- (void)gobacktoSuccess;
- (void)gobackMemberCenter;
-(void)gobacktoSuccessFulldentify;
-(void)unbundlingbankCard;
-(void)skipPage;
-(void)RegisteSuccessful;

-(void)gotoOrderManagement;


-(void)gobacktolastpage;
@end
