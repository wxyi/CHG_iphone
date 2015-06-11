//
//  MyTableViewCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (nonatomic, copy) AccountBriefSelect didSelectedSubItemAction;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong)NSMutableArray* items;

-(void)setupView:(NSMutableArray*)items;
@end
