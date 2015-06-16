//
//  GoodsDetailsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)NSString* strProductId;
@property (nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIWebView *myWebView;//商品详情ＷＥＢ
@property (assign)BOOL isWebViewLoad;
@property (assign)CGFloat m_height;
@end
