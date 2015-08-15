//
//  HelpCenterViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpCenterCollCell.h"
@interface HelpCenterViewController : UIViewController
@property(nonatomic,weak)IBOutlet UICollectionView* collection;
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,assign)NSInteger category;
@end
