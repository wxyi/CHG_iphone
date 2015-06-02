//
//  MyTableViewCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AccountBriefSelect)(NSIndexPath* indexPath);
@interface MyTableViewCell : UITableViewCell
@property (nonatomic, copy) AccountBriefSelect didSelectedSubItemAction;
@property(nonatomic,strong)NSArray* items;

-(void)setupView:(NSArray*)items;
@end
