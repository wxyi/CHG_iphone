//
//  UIWindow+YUBottomPoper.h
//  YUANBAOAPP
//
//  Created by yxy on 14/11/20.
//  Copyright (c) 2014年 ATAW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUBottomPopSelctView.h"

@interface UIWindow (YUBottomPoper)

-(void)showPopWithButtonTitles:(NSArray *)titles styles:(NSArray *)styles deledge:(id<YUBottomPopSelctViewDeledge>)deledge;

-(void)showPopWithButtonTitles:(NSArray *)titles styles:(NSArray *)styles whenButtonTouchUpInSideCallBack:(_int_type_block)callBack;


-(void)disMissPopSelectView;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
