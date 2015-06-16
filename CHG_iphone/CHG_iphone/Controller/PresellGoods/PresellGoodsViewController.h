//
//  PresellGoodsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresellGoodsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ZBarReaderViewDelegate,ZBarReaderDelegate>
@property(nonatomic,weak)IBOutlet ZBarReaderView* ZBarReader;
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)UIImageView* lineImage;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,assign)SaleType orderSaletype;
@property(nonatomic,assign)NSString* strCustId;
@property (assign)BOOL is_have;
@property (assign)BOOL is_Anmotion;

-(IBAction)ConfirmInfo:(id)sender;

@end
