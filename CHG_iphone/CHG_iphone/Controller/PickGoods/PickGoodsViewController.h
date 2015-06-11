//
//  PickGoodsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "DidNotPickGoodsViewController.h"
#import "DidPickGoodsViewController.h"
@interface PickGoodsViewController : UIViewController<QCSlideSwitchViewDelegate>
@property (nonatomic, strong) QCSlideSwitchView *slideSwitchView;
@property (nonatomic, strong) DidNotPickGoodsViewController *DidNotPickGoodsView;
@property (nonatomic, strong) DidNotPickGoodsViewController *DidPickGoodsView;
@property (nonatomic, strong) BaseViewController *vcAll;
@end
