//
//  StoresDetailsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
@interface StoresDetailsViewController : UIViewController<LMComBoxViewDelegate>

@property(nonatomic,weak)IBOutlet UILabel* storeNamelab;
@property(nonatomic,weak)IBOutlet UITextField* locationField;
-(IBAction)locationAddress:(UIButton*)sender;
@end
