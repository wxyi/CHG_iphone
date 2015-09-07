//
//  LoginCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "LoginCell.h"
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
@implementation LoginCell

- (void)awakeFromNib {
    // Initialization code
    self.userTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    if (!self.tb) {
        self.tb = [[TableViewWithBlock alloc] initWithFrame:CGRectMake(self.bgView.frame.origin.x + 7, 40, self.bgView.frame.size.width -14, 1)];
        self.tb.backgroundColor = UIColorFromRGB(0x323232);
        self.tb.alpha = 0.7;//COLOR(50, 50, 50, 0.8);
        self.tb.bounces = NO;
        self.tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self addSubview:self.tb];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CreateDropDown
{
    UIView* rightView = [[UIView alloc]initWithFrame:CGRectMake(0,0,40,40)];

    self.openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.openButton setFrame:CGRectMake(0, 0, 40, 40)];
    [self.openButton setImageEdgeInsets:UIEdgeInsetsMake(16, 14, 16, 14) ];
    [self.openButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.openButton setImage:[UIImage imageNamed:@"btn_down_blue.png"] forState:UIControlStateNormal];

    
    [self.openButton addTarget:self action:@selector(DropDownBtn:) forControlEvents:UIControlEventTouchUpInside];

    [rightView addSubview:self.openButton];
    self.userTextfield.rightView = rightView;
    self.userTextfield.rightViewMode = UITextFieldViewModeAlways;
    self.isOpened=NO;
    
    self.arr_Account = [[ConfigManager sharedInstance].Arr_Account componentsSeparatedByString:@","];
    //    [_tb setFrame:CGRectMake(0, 0, 200, 0)];
    NSInteger count = self.arr_Account.count;
    
    [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return count;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell.lb setText:[self.arr_Account objectAtIndex:indexPath.row]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.userTextfield.text=cell.lb.text;
        self.passwordTextfield.text = @"";
        [self.passwordTextfield becomeFirstResponder];
        [self.openButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [_tb.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tb.layer setBorderWidth:1];
}
-(void)DropDownBtn:(id)sender
{
    DLog(@"下拉");
    if (self.isOpened) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *closeImage=[UIImage imageNamed:@"btn_down_blue.png"];
            [self.openButton setImage:closeImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            
            frame.size.height=1;
            [_tb setFrame:frame];
            
        } completion:^(BOOL finished){
            
            self.isOpened=NO;
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *openImage=[UIImage imageNamed:@"btn_top.png"];
            [self.openButton setImage:openImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            if (self.arr_Account.count < 3) {
                frame.size.height = 40* self.arr_Account.count;
            }
            else
            {
                frame.size.height=120;
            }
            
            [_tb setFrame:frame];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tb.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.tb.bounds;
            maskLayer.path = maskPath.CGPath;
            _tb.layer.mask = maskLayer;
        } completion:^(BOOL finished){
            
            self.isOpened=YES;
        }];
        
        
    }
}
-(IBAction)Login:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.userTextfield) {
        if (string.length == 0) return YES;
        
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    else if (textField == self.passwordTextfield) {
        if (string.length == 0) return YES;
        
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
    }
    return YES;
}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    if (textField.text.length < 6 && textField.text.length != 0) {
//        [SGInfoAlert showInfo:@"密码不能小于6位"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self
//                     vertical:0.6];
//        [textField resignFirstResponder];
//    }
//}
@end
