//
//  IdentificationViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "IdentificationViewController.h"
#import "IdentificationCell.h"
#import "RegisteredMembersViewController.h"
#import "successfulIdentifyViewController.h"
#import "OrderManagementViewController.h"
#import "IdentUserInfoCell.h"
#import "PresellGoodsViewController.h"
#import "JTImageLabel.h"
@interface IdentificationViewController ()
@property UINib* IdentificationNib;
@property UINib* IdentUserInfoNib;
@end

@implementation IdentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"会员识别";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [timer invalidate];
    [_session removeOutput:self.output];
    [_session removeInput:self.input];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.ZBarReader stop];
//    self.is_have = NO;
//    self.is_Anmotion = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        
        NSString *tips = @"\n请授权本App可以访问相机\n设置方式:手机设置->隐私->相机\n允许本App使用相机";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描启动失败！" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
        return;
    }
    else{
        [self.tableview reloadData];
//        [self setupCamera];
//        [_session startRunning];
        self.isfinish = NO;
    }
//    self.is_have = NO;
//    self.isScan = NO;
//    self.is_Anmotion = YES;
//    [self loopDrawLine];
//    [self.ZBarReader start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    //增加监听，当键盘出现或改变时收出消息
    
    
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
//    self.tableview.tableHeaderView = v_header;
    self.IdentificationNib = [UINib nibWithNibName:@"IdentificationCell" bundle:nil];
    self.IdentUserInfoNib = [UINib nibWithNibName:@"IdentUserInfoCell" bundle:nil];
    
    self.nextbtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
    [self.view bringSubviewToFront:self.nextbtn];
//    rect = self.nextbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    self.nextbtn.frame = rect;
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.ZBarReader addGestureRecognizer:tapGestureRecognizer];
    
    
}


//-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
//{
//    NSString *codeData=[[NSString alloc]init];
//    for (ZBarSymbol *sym in symbols) {
//        codeData = sym.data;
//        break;
//    }
//    //判断是否包含 头'http:'
//    NSString *regex = @"http+:[^\\s]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    
//    //判断是否包含 头'ssid:'
//    NSString *ssid = @"ssid+:[^\\s]*";;
//    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//    
//    //判断是否为纯数字'
//    NSString * num        = @"^-?\\d+$";
//    NSPredicate * numpred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
//    
//    
//    if ([predicate evaluateWithObject:codeData]) {
//        
//        DLog(@"判断是否包含 头'http:");
//        [self httpValidateMobile:codeData];
//        
//    }
//    else if([ssidPre evaluateWithObject:codeData]){
//        DLog(@"判断是否包含 头'ssid:");
//    }
//    else if([numpred evaluateWithObject:codeData]){
//        DLog(@"判断是否为纯数字");
//        if ([IdentifierValidator isValid:IdentifierTypePhone value:codeData]) {
//            DLog(@"手机号");
//            self.isScan = YES;
//            [self httpValidateMobile:codeData];
//        }
//    }
//    
//    
//}
//
//-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    
//    
//    
//    //判断是否包含 头'http:'
//    NSString *regex = @"http+:[^\\s]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    
//    //判断是否包含 头'ssid:'
//    NSString *ssid = @"ssid+:[^\\s]*";;
//    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//    
//    
//}
//-(void)loopDrawLine
//{
////    self.is_Anmotion = ye;
//    CGRect  rect = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2, 15, ZbarRead_With, 2);
//    if (self.lineImage) {
//        [self.lineImage removeFromSuperview];
//    }
//    self.lineImage = [[UIImageView alloc] initWithFrame:rect];
//    self.lineImage.image = [UIImage imageNamed:@"scan_laser.png"];
//    //    imageview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_laser.png"]];
//    [UIView animateWithDuration:3.0
//                          delay: 0.0
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         //修改fream的代码写在这里
//                         self.lineImage.frame =CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2, 185, ZbarRead_With, 2);
//                         [self.lineImage setAnimationRepeatCount:0];
//                         
//                     }
//                     completion:^(BOOL finished){
//                         if (!self.is_Anmotion) {
//                             [self loopDrawLine];
//                         }
//                         
//                     }];
//    
//    if (!self.is_have) {
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//
//        //将触摸事件添加到当前view
//        
//        UIImageView *topeview=[[UIImageView alloc] init];
//        topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
//        topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
//        [topeview addGestureRecognizer:tapGestureRecognizer];
//        UIImageView *lefteview=[[UIImageView alloc] init];
//        lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
//        lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//        [lefteview addGestureRecognizer:tapGestureRecognizer];
//        UIImageView *righteview=[[UIImageView alloc] init];
//        righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
//        righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//        [righteview addGestureRecognizer:tapGestureRecognizer];
//        UIImageView *bottomview=[[UIImageView alloc] init];
//        bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
//        bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
//        [bottomview addGestureRecognizer:tapGestureRecognizer];
//        self.ZBarReader.tag = 101;
//        
//        self.ZBarReader.readerDelegate = self;
//        self.ZBarReader.allowsPinchZoom = YES;//使用手势变焦
//        self.ZBarReader.trackingColor = [UIColor blueColor];
//        self.ZBarReader.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示
//        self.ZBarReader.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
//        
//        self.ZBarReader.torchMode = 0;
//        [self.ZBarReader addSubview:topeview];
//        [self.ZBarReader addSubview:lefteview];
//        [self.ZBarReader addSubview:righteview];
//        [self.ZBarReader addSubview:bottomview];
//        
//        [self.ZBarReader start];
//        self.is_have = YES;
//        
//    }
//    [self.view addSubview:self.lineImage];
//}
//-(void)keyboardHide:(UITapGestureRecognizer*)tap{
//    UITextField* textfiled = (UITextField*)[self.view viewWithTag:100];
//    [textfiled resignFirstResponder];
//}
//- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
//{
//    CGFloat x,y,width,height;
//    
//    x = rect.origin.x / readerViewBounds.size.width;
//    y = rect.origin.y / readerViewBounds.size.height;
//    width = rect.size.width / readerViewBounds.size.width;
//    height = rect.size.height / readerViewBounds.size.height;
//    
//    return CGRectMake(x, y, width, height);
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isScan) {
        IdentUserInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IdentUserInfoCell"];
        if(cell==nil){
            cell = (IdentUserInfoCell*)[[self.IdentUserInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.iphonelab.text = [NSString stringWithFormat:@"手机号码:%@",self.dict[@"custMobile"]];
        cell.namelab.text = [NSString stringWithFormat:@"姓名:%@",self.dict[@"custName"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        IdentificationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IdentificationCell"];
        if(cell==nil){
            cell = (IdentificationCell*)[[self.IdentificationNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        cell.iphoneTextfiel.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isScan) {
        return 90;
    }
    return 40 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 255;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 40;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    nextBtn.frame = v_footer.frame;
//    [nextBtn.layer setMasksToBounds:YES];
//    [nextBtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
//    [nextBtn setBackgroundColor:UIColorFromRGB(0x171c61)];
//    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [nextBtn addTarget:self action:@selector(IdentificationMember:) forControlEvents:UIControlEventTouchUpInside];
//    [v_footer addSubview:nextBtn];
//    return v_footer;
//}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255)];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-170)/2, 15, 170, 170)];
    imageView.image = [UIImage imageNamed:@"scan.png"];
    [v_header addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-170)/2, 15, 170, 2)];
    _line.image = [UIImage imageNamed:@"scan_laser.png"];
    [v_header addSubview:_line];
    
    
    JTImageLabel *promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 50)];
    promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_small.png"];
    promptlabel.textLabel.text = @"扫描二维码识别商品信息";
    promptlabel.textLabel.font = FONT(12);
    promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
    promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
    //    promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_header addSubview:promptlabel];

    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    // Device
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus != AVAuthorizationStatusRestricted && authStatus != AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        // Preview
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame =CGRectMake(0,0,SCREEN_WIDTH,220);
        [v_header.layer insertSublayer:self.preview atIndex:0];
        [_session startRunning];
    }

    
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    //将触摸事件添加到当前view
    
    UIImageView *topeview=[[UIImageView alloc] init];
    topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
    topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
//    [topeview addGestureRecognizer:tapGestureRecognizer];
    UIImageView *lefteview=[[UIImageView alloc] init];
    lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
    lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//    [lefteview addGestureRecognizer:tapGestureRecognizer];
    UIImageView *righteview=[[UIImageView alloc] init];
    righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
    righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//    [righteview addGestureRecognizer:tapGestureRecognizer];
    UIImageView *bottomview=[[UIImageView alloc] init];
    bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
    bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
//    [bottomview addGestureRecognizer:tapGestureRecognizer];
    [v_header addSubview:topeview];
    [v_header addSubview:lefteview];
    [v_header addSubview:righteview];
    [v_header addSubview:bottomview];
    v_header.backgroundColor = [UIColor clearColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 35)];
    titlelab.backgroundColor = UIColorFromRGB(0xdddddd);
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text = @"用户信息";
    titlelab.textColor = UIColorFromRGB(0x323232);
    titlelab.font = FONT(14);
    [v_header addSubview:titlelab];
    return v_header;
}

-(IBAction)IdentificationMember:(UIButton*)sender
{

    if (self.isScan) {
        [self skipVariousPages];
    }
    else
    {
        UITextField* texield = (UITextField*)[self.view viewWithTag:100];
        [texield resignFirstResponder];
        NSString * info  = @"";
        if (texield.text.length == 0)
        {
            info = @"请输入手机号";
        }
        else if (![IdentifierValidator isValid:IdentifierTypePhone value:texield.text]) {
            info = @"手机号格式错误";
        }
        if (info.length != 0) {
            [SGInfoAlert showInfo:info
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            return ;
        }
        [self httpValidateMobile:texield.text];
    }
    
    
   
    
}
-(void)setBtnTitle
{
//    UIButton* button = (UIButton*)[self.view viewWithTag:1010];
    if (self.m_MenuType == MenuTypeMemberCenter) {
        
//        self.nextbtn.titleLabel.text = @"下一步";
        [self.nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else if (self.m_MenuType == MenuTypeOrderManagement)
    {
//        button.titleLabel.text = @"订单管理";
        [self.nextbtn setTitle:@"订单管理" forState:UIControlStateNormal];
    }
    else if (self.m_MenuType == MenuTypeSellingGoods)
    {
//        button.titleLabel.text = @"卖货";
        [self.nextbtn setTitle:@"卖货" forState:UIControlStateNormal];
    }
    else if (self.m_MenuType == MenuTypePresell)
    {
//        button.titleLabel.text = @"预售";
        [self.nextbtn setTitle:@"预售" forState:UIControlStateNormal];
    }
}

-(void)httpValidateMobile:(NSString*)custMobile
{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:custMobile forKey:@"mobile"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiValidateMobile] parameters:parameter];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,[data objectForKey:@"msg"]);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            self.isfinish = NO;
            
            [MMProgressHUD dismiss];
            [ConfigManager sharedInstance].strCustId = [NSString stringWithFormat:@"%d",[[[[data objectForKey:@"datas"] objectForKey:@"Cust"] objectForKey:@"custId"] intValue]];
            DLog(@"识别成功");
            self.dict = [[data objectForKey:@"datas"] objectForKey:@"Cust"];
            self.isScan = YES;
//            [self.tableview reloadData];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            [self setBtnTitle];
//            if (self.isScan){
//                
//                [self.tableview reloadData];
//                return ;
//            }
//            else  {
//                [self skipVariousPages];
//
//            }
        }
        else if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==47001)
        {
            DLog(@"识别失败");
            
            self.isfinish = NO;
            
            if ([IdentifierValidator isValid:IdentifierTypePhone value:custMobile])
            {
                [MMProgressHUD dismiss];
                self.stAlertView = [[STAlertView alloc] initWithTitle:@"未识别会员信息" message:@"是否注册为新会员" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                    DLog(@"否");
                    //                UITextField* textfield = (UITextField*)[self.view viewWithTag:100];
                    //                textfield.text = @"";
                    //                [_session stopRunning];
                    //                [_session startRunning];
                    self.isfinish = NO;
                } otherButtonBlock:^{
                    DLog(@"是");
                    self.isScan = NO;
                    //                [self.ZBarReader stop];
                    
                    self.isfinish = YES;
                    UITextField* texield = (UITextField*)[self.view viewWithTag:100];
                    RegisteredMembersViewController* RegisteredMembersView = [[RegisteredMembersViewController alloc] initWithNibName:@"RegisteredMembersViewController" bundle:nil];
                    RegisteredMembersView.strIphone = texield.text;
                    [self.navigationController pushViewController:RegisteredMembersView animated:YES];
                }];
                
                [self.stAlertView show];
            }
            else
            {
//                [MMProgressHUD dismissWithError:@"手机号码不正确"];
                [MMProgressHUD dismiss];
                [SGInfoAlert showInfo:@"手机号码不正确"
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            }
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }

    } failureBlock:^(NSString *description) {
//         [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
-(void)skipVariousPages
{
    
    self.isScan = NO;
//    [self.ZBarReader stop];
//    [_session stopRunning];
    switch (self.m_MenuType) {
        case MenuTypeMemberCenter:
        {
            DLog(@"注册成功")
            successfulIdentifyViewController* successfulIdentifyView = [[successfulIdentifyViewController alloc] initWithNibName:@"successfulIdentifyViewController" bundle:nil];
            successfulIdentifyView.m_CustDict = self.dict;
            [self.navigationController pushViewController:successfulIdentifyView animated:YES];
            break;
        }
        case MenuTypeOrderManagement:
        {
            DLog(@"订单管理")
            OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
            OrderManagementView.m_returnType = OrderReturnTypeHomePage;
            OrderManagementView.ManagementTyep = OrderManagementTypeSingle;
            [self.navigationController pushViewController:OrderManagementView animated:YES];
            break;
        }
        case MenuTypeSellingGoods:
        case MenuTypePresell:
        {
            
            DLog(@"预售");
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            

            if (self.m_MenuType == MenuTypePresell)
            {
                PresellGoodsView.orderSaletype = SaleTypePresell;
            }
            else
            {
                PresellGoodsView.orderSaletype = SaleTypeSellingGoods;
            }
            
            [self.navigationController pushViewController:PresellGoodsView animated:YES];
            break;
        }
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setupCamera
{
//    // Device
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    // Input
//    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
//    
//    // Output
//    _output = [[AVCaptureMetadataOutput alloc]init];
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    // Session
//    _session = [[AVCaptureSession alloc]init];
//    [_session setSessionPreset:AVCaptureSessionPresetHigh];
//    if ([_session canAddInput:self.input])
//    {
//        [_session addInput:self.input];
//    }
//    
//    if ([_session canAddOutput:self.output])
//    {
//        [_session addOutput:self.output];
//    }
//    
//    // 条码类型 AVMetadataObjectTypeQRCode
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
//    
//    // Preview
//    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _preview.frame =CGRectMake(0,0,SCREEN_WIDTH,220);
//    [self.view.layer insertSublayer:self.preview atIndex:0];
//    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    
//    //将触摸事件添加到当前view
//    
//    UIImageView *topeview=[[UIImageView alloc] init];
//    topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
//    [topeview addGestureRecognizer:tapGestureRecognizer];
//    UIImageView *lefteview=[[UIImageView alloc] init];
//    lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//    [lefteview addGestureRecognizer:tapGestureRecognizer];
//    UIImageView *righteview=[[UIImageView alloc] init];
//    righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//    [righteview addGestureRecognizer:tapGestureRecognizer];
//    UIImageView *bottomview=[[UIImageView alloc] init];
//    bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
//    [bottomview addGestureRecognizer:tapGestureRecognizer];
//    [self.view addSubview:topeview];
//    [self.view addSubview:lefteview];
//    [self.view addSubview:righteview];
//    [self.view addSubview:bottomview];
    // Start
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        
//        [_session stopRunning];
//        [timer invalidate];
        if (!self.isfinish) {
            self.isfinish = YES;
            //判断是否包含 头'http:'
            NSString *regex = @"http+:[^\\s]*";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            
            //判断是否包含 头'ssid:'
//            NSString *ssid = @"ssid+:[^\\s]*";;
//            NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//            
            //判断是否为纯数字'
            NSString * number        = @"^-?\\d+$";
            NSPredicate * numpred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
            self.isScan = YES;
            
            if ([predicate evaluateWithObject:stringValue]) {
                
                DLog(@"判断是否包含 头'http:");
                //            [_session stopRunning];
                [self httpValidateMobile:stringValue];
                
            }
            else if([numpred evaluateWithObject:stringValue]){
                DLog(@"判断是否为纯数字");
                //            if ([IdentifierValidator isValid:IdentifierTypePhone value:stringValue])
                {
                    DLog(@"手机号");
                    
                    //               [_session stopRunning];
                    [self httpValidateMobile:stringValue];
                }
            }
        }
        
        
    }
    NSLog(@"%@",stringValue);
    
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(75, 15+2*num, 170, 2);
        if (2*num == 170) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(75, 15+2*num, 170, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isScan = NO;
//     [self animateTextField: textField up: YES];
}




- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
//    [self animateTextField: textField up: NO];
    
}



- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    
    const int movementDistance = 80; // tweak as needed
    
    const float movementDuration = 0.3f; // tweak as needed
    
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    CGRect rect = self.tableview.frame;
    rect.origin.y = rect.origin.y + movement;
    self.tableview.frame = rect;
    DLog(@"frame = %@",NSStringFromCGRect(self.tableview.frame));
    [UIView commitAnimations];
    
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyHeight = keyboardRect.size.height;
    
//    const int movementDistance = self.keyHeight; // tweak as needed
    
    const float movementDuration = 0.3f; // tweak as needed
    
//    DLog(@"dever = %@",);
    
//    int movement = (up ? -movementDistance : movementDistance);
    
    
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    CGRect rect = self.tableview.frame;
    NSString* deviceName = [ConfigManager sharedInstance].deviceName;
    if ([deviceName isEqualToString:@"iPhone 4S"] || [deviceName isEqualToString:@"iPhone 4"]) {
        rect.origin.y = rect.origin.y - 100;
        
    }
    else
    {
        rect.origin.y = rect.origin.y - self.keyHeight;
    }
    
    self.tableview.frame = rect;
    
    rect = self.nextbtn.frame;
    rect.origin.y = rect.origin.y - self.keyHeight;
    self.nextbtn.frame = rect;
    
    DLog(@"frame = %@",NSStringFromCGRect(self.nextbtn.frame));
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    const float movementDuration = 0.3f; // tweak as needed
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    CGRect rect = self.tableview.frame;
    NSString* deviceName = [ConfigManager sharedInstance].deviceName;
    if ([deviceName isEqualToString:@"iPhone 4S"] || [deviceName isEqualToString:@"iPhone 4"]) {
        rect.origin.y = rect.origin.y + 100;
        
    }
    else
    {
        rect.origin.y = rect.origin.y + self.keyHeight;
        
    }
//    rect.origin.y = rect.origin.y + self.keyHeight;
    self.tableview.frame = rect;
    
    rect = self.nextbtn.frame;
    rect.origin.y = rect.origin.y + self.keyHeight;
    self.nextbtn.frame = rect;
    
    DLog(@"frame = %@",NSStringFromCGRect(self.nextbtn.frame));
    [UIView commitAnimations];
}
//-(void)httpScanInfo
//{
//    DLog(@"data = %@",[NSObject currentTime]);
//    
//    self.isfinish = YES;
//}
@end
