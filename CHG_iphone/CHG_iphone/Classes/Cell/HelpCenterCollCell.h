//
//  HelpCenterCollCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^skipWebView)(NSDictionary* dict);
typedef void(^SelectCurrentBtn)(NSIndexPath* indexPath);
@interface HelpCenterCollCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,copy)SelectCurrentBtn selectBtn;
@property(nonatomic,copy)skipWebView skipweb;
@property(nonatomic,strong)NSIndexPath* indexPath;
-(void)setupTableview:(NSArray*)items;
@end
