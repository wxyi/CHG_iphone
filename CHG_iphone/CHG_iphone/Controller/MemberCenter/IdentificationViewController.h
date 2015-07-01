//
//  IdentificationViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface IdentificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate,UITextFieldDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    NSTimer * timer1;
}
@property(nonatomic,assign)BOOL isfinish;

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, strong) UIImageView * line;


@property(nonatomic,weak)IBOutlet UITableView* tableview;
@property(nonatomic,weak)IBOutlet UIButton* nextbtn;
@property(nonatomic,assign)MenuType m_MenuType;
@property(nonatomic,strong)NSDictionary* dict;
@property(nonatomic,assign)BOOL isScan;
@property(nonatomic,assign)CGFloat keyHeight;

@property (assign)BOOL is_have;
@property (assign)BOOL is_Anmotion;




@property (nonatomic, strong) STAlertView *stAlertView;
-(IBAction)IdentificationMember:(UIButton*)sender;

@end
