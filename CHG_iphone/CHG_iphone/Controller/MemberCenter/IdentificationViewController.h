//
//  IdentificationViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ZBarReaderViewDelegate,ZBarReaderDelegate>
@property(nonatomic,weak)IBOutlet ZBarReaderView* ZBarReader;
@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,strong)UIImageView* lineImage;
@property(nonatomic,assign)MenuType m_MenuType;
@property(nonatomic,strong)NSDictionary* dict;
@property(nonatomic,assign)BOOL isScan;
@property (assign)BOOL is_have;
@property (assign)BOOL is_Anmotion;

@property (nonatomic, strong) STAlertView *stAlertView;
-(IBAction)IdentificationMember:(UIButton*)sender;

@end
