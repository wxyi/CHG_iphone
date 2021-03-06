//
//  OrderQuryViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"
#import "QRadioButton.h"
@interface OrderQuryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QRadioButtonDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIView* bg_view;
@property(nonatomic,weak)IBOutlet NoCopyTextField* starttime;
@property(nonatomic,weak)IBOutlet NoCopyTextField* endtime;
@property (nonatomic,assign)OrderManagementType ManagementTyep;
@property (nonatomic,assign)OrderReturnType m_returnType;

@property(nonatomic,assign)NSInteger m_nPageNumber;

@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,assign)BOOL ispulldown;
@property(nonatomic,strong)UUDatePicker *startdatePicker;
@property(nonatomic,strong)UUDatePicker *enddatePicker;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,assign)CGFloat m_height;
@property(nonatomic,strong)NSString* strOrderType;
//@property (nonatomic,assign)OrderManagementType ManagementTyep;
@property(nonatomic,assign)BOOL isLastData;
-(IBAction)QueryOrderBtn:(UIButton*)sender;
@end
