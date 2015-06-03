//
//  MemberInfoViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"
#import "JTImageLabel.h"
@interface MemberInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)UUDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet JTImageLabel *promptlabel;
-(IBAction)SubmitCompleted:(id)sender;
@end
