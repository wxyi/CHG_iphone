//
//  BaseViewController.h
//  SunLightCloud
//
//  Created by wuxinyi on 14-10-31.
//  Copyright (c) 2014年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;
@property (nonatomic, copy) AccountBriefSelect didSelectedSubItemAction;
@property (nonatomic, copy) skipDetailsPage skipdetails;
@property (nonatomic, copy) TableViewBtnSkipSelect BtnSkipSelect;
@property (nonatomic, copy) TableViewCellSkipSelect CellSkipSelect;
- (void)viewDidCurrentView;
@end
