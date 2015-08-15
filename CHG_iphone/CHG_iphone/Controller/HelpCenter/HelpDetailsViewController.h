//
//  HelpDetailsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpDetailsViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong) UIWebView* webview;
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic,strong)NSDictionary* dict;
@property (assign)BOOL isWebViewLoad;
@property (assign)CGFloat m_height;
@end
