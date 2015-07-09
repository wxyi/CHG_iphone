//
//  MyAccountViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)IBOutlet UICollectionView* collection;
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIImageView * line;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)NSArray* collonitems;
@property(nonatomic,strong)NSDictionary* dictionary;
@property(nonatomic,strong)UserConfig* config;

@property(nonatomic,strong)NSString* strYear;
@property(nonatomic,strong)NSString* strMonth;
@property(nonatomic,strong)NSString* strDay;
@end
