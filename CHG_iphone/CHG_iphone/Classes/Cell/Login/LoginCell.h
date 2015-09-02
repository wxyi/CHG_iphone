//
//  LoginCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "UITableView+DataSourceBlocks.h"
@class TableViewWithBlock;
@interface LoginCell : UITableViewCell<UITextFieldDelegate>
{
    BOOL isOpened;
}
@property (nonatomic, assign) BOOL isOpened;
@property (strong, nonatomic) TableViewWithBlock *tb;
@property (strong, nonatomic) UIButton *openButton;
@property(nonatomic,weak)IBOutlet UIView* bgView;
@property(nonatomic,weak)IBOutlet NoCopyTextField* userTextfield;
@property(nonatomic,weak)IBOutlet NoCopyTextField* passwordTextfield;
@property (nonatomic, copy) BaseViewSkipAction didSkipSubItem;
@property(nonatomic,strong)NSArray* arr_Account;
-(IBAction)Login:(UIButton*)sender;

-(void)CreateDropDown;
-(IBAction)DropDownBtn:(id)sender;
@end
