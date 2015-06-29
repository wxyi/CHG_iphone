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
@property (strong, nonatomic) JTImageLabel *promptlabel;
@property (weak, nonatomic) IBOutlet UIButton *submitbtn;

@property(nonatomic, strong) NSString *strCustMobile; //手机号码
@property(nonatomic, strong) NSString *strCustName; //用户名
@property(nonatomic, strong) NSString *strBabyBirthday;//昵称
@property(nonatomic, strong) NSString *strBabyGender; //性别
@property(nonatomic, strong) NSString *strBabyRelation; //关系
@property(nonatomic, strong) NSString *strCheckCode;//验证码

-(IBAction)SubmitCompleted:(id)sender;
@end
