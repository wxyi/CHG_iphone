//
//  PresellGoodsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PresellGoodsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    NSTimer * timer1;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;

@property(nonatomic,assign)BOOL isfinish;

@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* confirmbtn;
@property(nonatomic,strong)NSMutableArray* items;
@property(nonatomic,assign)SaleType orderSaletype;
@property(nonatomic,assign)OrderReturnType m_returnType;
-(IBAction)ConfirmInfo:(id)sender;

@end
