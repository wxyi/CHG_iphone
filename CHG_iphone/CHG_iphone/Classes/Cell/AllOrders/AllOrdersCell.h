//
//  AllOrdersCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrdersCell : MyTableViewCell<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSDictionary* allitems;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)PickUpType picktype;
-(void)setupAllOrderView:(NSDictionary *)items;
@end
