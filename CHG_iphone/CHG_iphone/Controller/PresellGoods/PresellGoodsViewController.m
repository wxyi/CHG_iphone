//
//  PresellGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PresellGoodsViewController.h"
#import "PresellCell.h"
#import "OrdersGoodsCell.h"
#import "OrderCounterViewController.h"
#import "JTImageLabel.h"
#import "PresellOperation.h"
//
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <QRCodeReader.h>
//#import <TwoDDecoderResult.h>
//
//#import <AudioToolbox/AudioToolbox.h>

#import "ZBarReaderView.h"
@interface PresellGoodsViewController ()<SWTableViewCellDelegate,ZBarReaderViewDelegate>
@property UINib* PresellNib;
@property UINib* OrdersGoodsNib;
@property (strong,nonatomic)ZBarReaderView* readerView;
@property (strong,nonatomic)ZBarImageScanner *scanner;
//@property (nonatomic, strong) ZXCapture *capture;
//@property (nonatomic) BOOL startScan;
@end

@implementation PresellGoodsViewController

//- (void)setCapture {
//    self.capture = nil;
//    self.capture = [[ZXCapture alloc] init];
//    self.capture.camera = self.capture.back;
////    [self.capture setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
////    self.capture.focusMode = ;
////    self.capture.rotation = 90.0f;
////    self.capture.layer.cornerRadius = 5.0f;
//    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
//    self.capture.layer.frame = frame;
//    [self.view.layer insertSublayer: self.capture.layer atIndex:0];
//
//    [self.capture start];
////    [self setBackground];
//    self.startScan = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //导航
//    JTImageButton *leftbtn = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
//    [leftbtn createTitle:@"返回" withIcon:[UIImage imageNamed:@"btn_back.png"] font:[UIFont systemFontOfSize:17] iconHeight:JTImageButtonIconHeightDefault iconOffsetY:1.0];
//    leftbtn.titleColor = [UIColor whiteColor];
//    
//    leftbtn.iconColor = [UIColor whiteColor];
//    leftbtn.padding = JTImageButtonPaddingSmall;
//    leftbtn.borderColor = [UIColor clearColor];
//    leftbtn.iconSide = JTImageButtonIconSideLeft;
//    [leftbtn addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
////    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePresellGoods:)
                                                 name:DELETE_PRESELL_GOODS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ClickSingleGoods:)
                                                 name:DELETE_SINGLE_GOODS
                                               object:nil];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    if (self.m_returnType == OrderReturnTypeAMember && (self.orderSaletype == SaleTypeReturnGoods || self.orderSaletype == SaleTypePickingGoods)) {
        
        if (self.skiptype == SkipFromOrderFinish && self.orderSaletype == SaleTypePickingGoods) {
            [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccessFulldentify) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (self.skiptype == SkipFromPopPage)
        {
            [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gotoOrderManagement) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    else if (self.m_returnType == OrderReturnTypePopPage)
    {
        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if(self.m_returnType == OrderReturnTypeAMember && (self.orderSaletype == SaleTypeSellingGoods || self.orderSaletype == SaleTypePresell))
        {
            [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccessFulldentify) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    self.items = [[NSMutableArray alloc] init];
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    //将触摸事件添加到当前view
    
    UIImageView *topeview=[[UIImageView alloc] init];
    topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
    topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
    [topeview addGestureRecognizer:tapGestureRecognizer];
    UIImageView *lefteview=[[UIImageView alloc] init];
    lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
    lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
    [lefteview addGestureRecognizer:tapGestureRecognizer];
    UIImageView *righteview=[[UIImageView alloc] init];
    righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
    righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
    [righteview addGestureRecognizer:tapGestureRecognizer];
    UIImageView *bottomview=[[UIImageView alloc] init];
    bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
    bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
    [bottomview addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:topeview];
    [self.view bringSubviewToFront:topeview];
    [self.view addSubview:lefteview];
    [self.view bringSubviewToFront:lefteview];
    [self.view addSubview:righteview];
    [self.view bringSubviewToFront:righteview];
    [self.view addSubview:bottomview];
    [self.view bringSubviewToFront:bottomview];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    
    
    if (self.orderSaletype == SaleTypePresell) {
        self.title = @"预售";
    }
    else if (self.orderSaletype == SaleTypeSellingGoods) {
        self.title = @"卖货";
    }
    else if(self.orderSaletype == SaleTypeReturnGoods)
    {
        self.title = @"退货扫描";
    }
    else if (self.orderSaletype == SaleTypePickingGoods)
    {
        self.title = @"提货扫描";
    }
    
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT -220 - 40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
//    self.tableview.tableHeaderView = v_header;
    
    self.PresellNib = [UINib nibWithNibName:@"PresellCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    
   
//    rect = self.confirmbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    self.confirmbtn.frame = rect;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-170)/2, 15, 170, 170)];
    imageView.image = [UIImage imageNamed:@"scan.png"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-170)/2, 15, 170, 2)];
    _line.image = [NSObject createImageWithColor:UIColorFromRGB(0xF5A541)];
    [self.view addSubview:_line];
//    [self.view bringSubviewToFront:_line];
    
    JTImageLabel *promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 50)];
    promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
    promptlabel.textLabel.text = @"扫描二维码识别商品信息";
    promptlabel.textLabel.font = FONT(12);
    promptlabel.textLabel.textColor = [UIColor whiteColor];
    promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
    //    promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
    [self.view addSubview:promptlabel];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
    [timer1 invalidate];
    
//    [_session stopRunning];
//    [_session removeInput:self.input];
//    [_session removeOutput:self.output];
//    [self.preview removeFromSuperlayer];
//    [self stopCapture];
    [self.readerView stop];
    [self.readerView removeFromSuperview];
    self.readerView.readerDelegate = nil;
    self.readerView = nil;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(httpScanInfo) userInfo:nil repeats:YES];
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        
        NSString *tips = @"\n请授权本App可以访问相机\n设置方式:手机设置->隐私->相机\n允许本App使用相机";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描启动失败！" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
        
    }
    else
    {
        
//        [self setCapture];
//        self.capture.delegate = self;
//        [self initCapture];
//        [self setupCamera];
        [self loopDrawLine];
    }
    
}


-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *codeData=[[NSString alloc]init];
    for (ZBarSymbol *sym in symbols) {
        codeData = sym.data;
        break;
    }
    if (self.isfinish) {
        self.isfinish = NO;
        NSString *regex = @"http+:[^\\s]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        //判断是否包含 头'ssid:'
        NSString *ssid = @"ssid+:[^\\s]*";;
        NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
        
        //判断是否为纯数字'
        NSString * num = @"^-?\\d+$";
        NSPredicate * numpred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
        if ([predicate evaluateWithObject:codeData]) {
            
            DLog(@"判断是否包含 头'http:");
            [self httpQrCode:codeData];
            
        }
        else if([ssidPre evaluateWithObject:codeData]){
            DLog(@"判断是否包含 头'ssid:");
        }
        else if([numpred evaluateWithObject:codeData]){
            DLog(@"判断是否为纯数字");
            if (self.orderSaletype != SaleTypeReturnGoods && self.orderSaletype != SaleTypeReturnEngageGoods) {
                [self httpQrCode:codeData];
            }
            else
            {
                [SGInfoAlert showInfo:@"不支持扫箱码退货"
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            }
        }
        else
        {
            [self httpQrCode:codeData];
        }
        
    }
}

//-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    
//    
////    
////    //判断是否包含 头'http:'
////    NSString *regex = @"http+:[^\\s]*";
////    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
////    
////    //判断是否包含 头'ssid:'
////    NSString *ssid = @"ssid+:[^\\s]*";;
////    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//    
//    
//}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    UITextField* textfiled = (UITextField*)[self.view viewWithTag:100];
    [textfiled resignFirstResponder];
}
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
    return self.items.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderSaletype == SaleTypeSellingGoods
     || self.orderSaletype == SaleTypeReturnGoods
     ||self.orderSaletype == SaleTypePickingGoods) {
        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
        if(cell==nil){
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        NSDictionary* dict =  [self.items objectAtIndexSafe:indexPath.row];


         [cell.GoodImage setImageWithURL:[NSURL URLWithString:[dict objectForKeySafe: @"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        cell.titlelab.text = [dict objectForKeySafe:@"productName"] ;
//        cell.pricelab.text = [dict objectForKeySafe:@"productPrice"];
        cell.pricelab.text = [NSString stringWithFormat:@"￥%@",[dict objectForKeySafe:@"productPrice"]];;
        cell.countlab.text = [NSString stringWithFormat:@"x%lu",(unsigned long)[(NSArray*)[dict objectForKeySafe:@"QrcList"] count]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        PresellCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PresellCell"];
        if(cell==nil){
            cell = (PresellCell*)[[self.PresellNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                         icon:[UIImage imageNamed:@"left_slide_delete.png"]];
            [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
            cell.delegate = self;
        }
        cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [cell setupCell];
        
        cell.indexPath = indexPath;
        cell.operationPage = @"0";
        NSDictionary* dict =  [self.items objectAtIndexSafe:indexPath.row];

        [cell.GoodsImage setImageWithURL:[NSURL URLWithString:[dict objectForKeySafe:@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        cell.titlelab.text = [dict objectForKeySafe:@"productName"] ;
//        cell.pricelab.text = [dict objectForKeySafe:@"productPrice"];
        cell.pricelab.text = [NSString stringWithFormat:@"￥%@",[dict objectForKeySafe:@"productPrice"]];;
        
        cell.TextStepper.tag = [[NSString stringWithFormat:@"101%ld",(long)indexPath.row] intValue];
        cell.counter = [(NSArray*)[dict objectForKeySafe:@"QrcList"] count];
        NSInteger Qrclistcount;
        if ([(NSArray*)[dict objectForKeySafe:@"QrcList"] count] > 60) {
            Qrclistcount = 60;
            
            
        }
        else
        {
            Qrclistcount = [(NSArray*)[dict objectForKeySafe:@"QrcList"] count];
        }
        [cell.TextStepper setCurrent:Qrclistcount];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 15, 170, 170)];
//    imageView.image = [UIImage imageNamed:@"scan.png"];
//    [v_header addSubview:imageView];
//    
//    upOrdown = NO;
//    num =0;
//    _line = [[UIImageView alloc] initWithFrame:CGRectMake(75, 15, 170, 2)];
//    _line.image = [UIImage imageNamed:@"scan_laser.png"];
//    [v_header addSubview:_line];
//    
//    
//    JTImageLabel *promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 50)];
//    promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_small.png"];
//    promptlabel.textLabel.text = @"扫描二维码识别商品信息";
//    promptlabel.textLabel.font = FONT(12);
//    promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
//    promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
//    //    promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
//    [v_header addSubview:promptlabel];
//
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
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
//    [v_header.layer insertSublayer:self.preview atIndex:0];
//    
//    //    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    
//    //将触摸事件添加到当前view
//    [_session startRunning];
//    UIImageView *topeview=[[UIImageView alloc] init];
//    topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
//    //    [topeview addGestureRecognizer:tapGestureRecognizer];
//    UIImageView *lefteview=[[UIImageView alloc] init];
//    lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//    //    [lefteview addGestureRecognizer:tapGestureRecognizer];
//    UIImageView *righteview=[[UIImageView alloc] init];
//    righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
//    //    [righteview addGestureRecognizer:tapGestureRecognizer];
//    UIImageView *bottomview=[[UIImageView alloc] init];
//    bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
//    bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
//    //    [bottomview addGestureRecognizer:tapGestureRecognizer];
//    [v_header addSubview:topeview];
//    [v_header addSubview:lefteview];
//    [v_header addSubview:righteview];
//    [v_header addSubview:bottomview];
//    v_header.backgroundColor = [UIColor clearColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    titlelab.backgroundColor = UIColorFromRGB(0xdddddd);
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text = @"扫描结果";
    titlelab.textColor = UIColorFromRGB(0x323232);
    titlelab.font = FONT(14);
    [v_header addSubview:titlelab];
    return v_header;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(IBAction)ConfirmInfo:(id)sender
{
    if ([self.items count] == 0) {
        [SGInfoAlert showInfo:@"未扫描到商品"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return;
    }
    DLog(@"确认信息");
    if (self.orderSaletype == SaleTypePickingGoods|| self.orderSaletype == SaleTypeReturnGoods) {
        [self httpValidateOrderProduct];
    }
    else
    {
        OrderCounterViewController* OrderCounterView = [[OrderCounterViewController alloc] initWithNibName:@"OrderCounterViewController" bundle:nil];
        OrderCounterView.orderSaletype = self.orderSaletype;
        OrderCounterView.m_returnType = self.m_returnType;
        if (self.orderSaletype == SaleTypeSellingGoods ) {
            OrderCounterView.items = self.items;
        }
        else if(self.orderSaletype == SaleTypePresell)
        {
            for (int i = 0; i < self.items.count; i++) {
                NSInteger tag  = [[NSString stringWithFormat:@"101%d",i] intValue];
                TextStepperField* TextStepper = (TextStepperField*)[self.view viewWithTag:tag];
                DLog(@"textstepper = %.f",TextStepper.Current);
                
                NSDictionary* dict = [self.items objectAtIndexSafe:i];
                NSMutableDictionary *anotherDict = [NSMutableDictionary dictionary];
                anotherDict = [self.items objectAtIndexSafe:i];
                
                [anotherDict setObjectSafe:[NSString stringWithFormat:@"%lu", (unsigned long)[(NSArray*)[dict objectForKeySafe:@"QrcList"] count]] forKey:@"quantity"];
                [self.items replaceObjectAtIndexSafe:i withObject:anotherDict];
            }
            OrderCounterView.items = self.items;
        }

        [self.navigationController pushViewController:OrderCounterView animated:YES];
    }
    
}

-(void)httpQrCode:(NSString*)parame
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObjectSafe:parame forKey:@"productCode"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].strCustId forKey:@"custId"];
    
    NSString* type;
    if (self.orderSaletype == SaleTypeSellingGoods) {
        type = @"0";
    }
    else if(self.orderSaletype == SaleTypePresell)
    {
        type = @"1";
    }
    else if(self.orderSaletype == SaleTypePickingGoods)
    {
        type = @"2";
    }
    else if(self.orderSaletype == SaleTypeReturnEngageGoods||self.orderSaletype == SaleTypeReturnGoods)
    {
        type = @"3";
    }
    [parameter setObjectSafe:type forKey:@"type"];
//    NSMutableDictionary *productpar = [NSMutableDictionary dictionary];
//    [productpar setObject:parame forKey:@"productCode"];
//    DLog(@"parameter = %@",productpar);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetProductBrief] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
            if (self.orderSaletype == SaleTypeSellingGoods || self.orderSaletype == SaleTypePickingGoods ||self.orderSaletype == SaleTypeReturnEngageGoods ||self.orderSaletype == SaleTypeReturnGoods) {
                [self addProductforSingleHair:[data objectForKeySafe:@"datas"]];
            }
            else if(self.orderSaletype == SaleTypePresell)
            {
                [self addProductforSingleMultiple:[data objectForKeySafe:@"datas"]];
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
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpQrCode:parame];
    }];
}

-(void)addProductforSingleMultiple:(NSArray*)datas
{
    /**
     *  首次添加扫描信息，将二维码信息重新打包
     */
    NSMutableDictionary* product = [self productInfo:datas];
    if (product == nil) {
        return;
    }
    if (self.items.count == 0 ) {
        [self.items addObjectSafe:product];
    }
    else
    {
        NSMutableArray* tempArray = [self.items mutableCopy];
        BOOL isSameId = NO;
        NSInteger index = 0 ;
        for (int i = 0; i < tempArray.count; i++) {
            
            NSInteger productId = [[[tempArray objectAtIndexSafe: i] objectForKeySafe:@"productId"] intValue];
            NSInteger dataproId = [[product objectForKeySafe: @"productId"] intValue];
            
            if (productId == dataproId) {
                isSameId = YES;
                index = i;
                

            }

        }
        if (!isSameId) {
//            [self.items addObjectSafe:product];
            [self.items insertObjectSafe:product atIndex:0];
        }
        else
        {
            NSMutableArray *QrcArr = [[tempArray objectAtIndexSafe: index] objectForKeySafe: @"QrcList"];
            NSMutableArray *prodQrcArr = [product objectForKeySafe: @"QrcList"];
            
            if (QrcArr.count + prodQrcArr.count > 60) {
                [SGInfoAlert showInfo:@"该商量已超过销售数量限制，禁止添加商品！"
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            }
            for (int i = 0; i < prodQrcArr.count; i++) {
                if (QrcArr.count == 60) {
                    break;
                }
                [QrcArr addObjectSafe:prodQrcArr[i]];
            }
            [product setObjectSafe:QrcArr forKey:@"QrcList"];
            [self.items replaceObjectAtIndexSafe:index withObject:product];
        }
    }
    
    [self.tableview reloadData];
}

-(void)addProductforSingleHair:(NSArray*)datas
{
    
    NSMutableDictionary* product = [self productInfo:datas];
    if (product == nil) {
        return;
    }
    if (self.items.count == 0 ) {
        [self.items addObjectSafe:product];
    }
    else
    {
        NSMutableArray* tempArray = [self.items copy];
        BOOL isSameId = NO;
        NSInteger index = 0 ;
        for (int i = 0; i < tempArray.count; i++) {
            
                NSInteger productId = [[tempArray[i] objectForKeySafe:@"productId"] intValue];
                NSInteger dataproId = [[product objectForKeySafe: @"productId"] intValue];
                
                if (productId == dataproId) {
                    isSameId = YES;
                    index = i;
                }
            
        }

        if (!isSameId) {
//            [self.items addObjectSafe:product];
            [self.items insertObjectSafe:product atIndex:0];
        }
        else
        {
            NSMutableArray *QrcArr = [[self.items objectAtIndexSafe: index] objectForKeySafe: @"QrcList"];
            NSMutableArray *prodQrcArr = [product objectForKeySafe: @"QrcList"];
            
    
            NSPredicate * QrcPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",QrcArr];
            
            NSArray * prodQrcfilter = [prodQrcArr filteredArrayUsingPredicate:QrcPredicate];
            
            NSPredicate * prodQrcredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",prodQrcArr];
            NSArray * Qrcfilter = [QrcArr filteredArrayUsingPredicate:prodQrcredicate];
            
            
            if (prodQrcfilter.count == 0 && Qrcfilter.count == 0) {
                [self.items removeObjectAtIndexSafe:index];
            }
            else
            {
                NSMutableArray *datas = [[NSMutableArray alloc] init];
                datas = [Qrcfilter mutableCopy];
                
                if (datas.count + prodQrcfilter.count > 60) {
                    [SGInfoAlert showInfo:@"该商量已超过销售数量限制，禁止添加商品！"
                                  bgColor:[[UIColor blackColor] CGColor]
                                   inView:self.view
                                 vertical:0.7];
                }
                else  if (prodQrcfilter.count != 0) {
                    for (int i = 0; i < prodQrcfilter.count; i++) {

                        [datas addObjectSafe:prodQrcfilter[i]];
//                        if ([datas count] < 60) {
//                            
//                        }
                        
                    }
                }
                [product setObjectSafe:datas forKey:@"QrcList"];
                [self.items replaceObjectAtIndexSafe:index withObject:product];
                
            }
            
           
        }
    }
    
    [self.tableview reloadData];
}
-(NSMutableDictionary*)productInfo:(NSArray*)datas
{
    if (datas.count > 0) {
        NSMutableDictionary *anotherDict = [NSMutableDictionary dictionary];
        NSMutableArray *QrcArr = [[NSMutableArray alloc] init];
        [anotherDict setObjectSafe:[[datas objectAtIndexSafe: 0] objectForKeySafe:@"productName"] forKey:@"productName"];
        [anotherDict setObjectSafe:[[datas objectAtIndexSafe: 0] objectForKeySafe:@"productPrice"] forKey:@"productPrice"];
        [anotherDict setObjectSafe:[[datas objectAtIndexSafe: 0] objectForKeySafe:@"productSmallUrl"] forKey:@"productSmallUrl"];
        [anotherDict setObjectSafe:[[datas objectAtIndexSafe: 0] objectForKeySafe:@"productId"] forKey:@"productId"];

        for (int i = 0; i < datas.count; i++) {
            
            [QrcArr addObjectSafe:datas[i][@"productCode"]];
        }
        [anotherDict setObjectSafe:QrcArr forKey:@"QrcList"];
        
        
        return anotherDict;

    }
    else
    {
        return nil;
    }
    
}
//提货时点击“确认信息”调用本接口
-(void)httpValidateOrderProduct
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    //post 参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *strurl ;
    //验证订单商品
    if (self.orderSaletype == SaleTypePickingGoods) {
        strurl = [APIAddress ApiValidateOrderProduct];
    }
    else
    {
        strurl = [APIAddress ApiValidateProductReturn];
    }
    NSString* url = [NSObject URLWithBaseString:strurl parameters:parameter];
    
    
    [param setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObjectSafe:[ConfigManager sharedInstance].strCustId forKey:@"custId"];


    NSString* productCode = @"";
    for (int i = 0; i < [self.items count]; i++) {
        
        productCode = [productCode stringByAppendingString:[[[self.items objectAtIndexSafe: i] objectForKeySafe: @"QrcList"] componentsJoinedByString:@","]]  ;
        productCode = [productCode stringByAppendingString:@","]  ;
    }
    DLog(@"productCode = %@",productCode)
    
    [param setObjectSafe:productCode forKey:@"productCodeStr"];
    
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200){
        
            [MMProgressHUD dismiss];
            
            
            OrderCounterViewController* OrderCounterView = [[OrderCounterViewController alloc] initWithNibName:@"OrderCounterViewController" bundle:nil];
            OrderCounterView.orderSaletype = self.orderSaletype;
            OrderCounterView.m_returnType = self.m_returnType;
            OrderCounterView.items = self.items;
            OrderCounterView.priceDict = [data objectForKeySafe:@"datas"];
            [self.navigationController pushViewController:OrderCounterView animated:YES];
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            if (self.orderSaletype == SaleTypePickingGoods) {
                OrderCounterViewController* OrderCounterView = [[OrderCounterViewController alloc] initWithNibName:@"OrderCounterViewController" bundle:nil];
                OrderCounterView.orderSaletype = self.orderSaletype;
                OrderCounterView.m_returnType = self.m_returnType;
                OrderCounterView.items = self.items;
                OrderCounterView.priceDict = [data objectForKeySafe:@"datas"];
                [self.navigationController pushViewController:OrderCounterView animated:YES];
            }
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpValidateOrderProduct];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loopDrawLine
{
    self.scanner = [ZBarImageScanner new];
    self.readerView =  [[ZBarReaderView alloc]
                                    initWithImageScanner: self.scanner];
    self.readerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    self.readerView.tag = 101;
    self.readerView.readerDelegate = self;
    self.readerView.allowsPinchZoom = YES;//使用手势变焦
    self.readerView.trackingColor = [UIColor blueColor];
    self.readerView.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示
    self.readerView.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
    self.readerView.tracksSymbols = NO;
    self.readerView.torchMode = 0;
    [self.view addSubview:self.readerView];
    [self.view sendSubviewToBack:self.readerView];
    
//    [self.view.layer insertSublayer:self.readerView.layer atIndex:0];
    [self.readerView start];
    
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    [_device setVideoZoomFactor:50.0f];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [_output setRectOfInterest:CGRectMake((SCREEN_WIDTH-170)/2, 15, 170, 170)];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat tm_X = 15.0/height;
    CGFloat tm_Y = ((width - 170.0)/2)/width;
    CGFloat tm_Width = 170.0/height;
    CGFloat tm_Height = 170.0/width;
    [_output setRectOfInterest:CGRectMake(tm_X,tm_Y,tm_Width ,tm_Height)];    // Session
    DLog(@"cgrectmake = %@",NSStringFromCGRect(_output.rectOfInterest));
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        _session.sessionPreset = AVCaptureSessionPreset1920x1080;
        
    }
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
//    _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
//    _captureOutput.alwaysDiscardsLateVideoFrames = YES;
//    [_captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
//    NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
//    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
//    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
//    [_captureOutput setVideoSettings:videoSettings];
//    [_session addOutput:_captureOutput];
//    _session.sessionPreset = AVCaptureSessionPresetMedium;
    
//    [_session beginConfiguration];
//    
//
//    
//    
//    [_session commitConfiguration];
//    [_session beginConfiguration];
//    [_device lockForConfiguration:nil];
//    
//    // Set torch to on
//    [_device setTorchMode:AVCaptureTorchModeOn];
//    
//    [_device unlockForConfiguration];
//    [_session commitConfiguration];
    
    // 条码类型 AVMetadataObjectTypeQRCode
//    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,nil]];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _preview.frame =CGRectMake(0,0,SCREEN_WIDTH,220);
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    // Start
    [_session startRunning];


    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndexSafe:0];
        stringValue = metadataObject.stringValue;
        
        
//        [_session stopRunning];
//        [timer invalidate];
        
        //判断是否包含 头'http:'
        
        if (self.isfinish) {
            self.isfinish = NO;
            NSString *regex = @"http+:[^\\s]*";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            
            //判断是否包含 头'ssid:'
            NSString *ssid = @"ssid+:[^\\s]*";;
            NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
            
            //判断是否为纯数字'
            NSString * num = @"^-?\\d+$";
            NSPredicate * numpred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
            if ([predicate evaluateWithObject:stringValue]) {
                
                DLog(@"判断是否包含 头'http:");
                [self httpQrCode:stringValue];
                
            }
            else if([ssidPre evaluateWithObject:stringValue]){
                DLog(@"判断是否包含 头'ssid:");
            }
            else if([numpred evaluateWithObject:stringValue]){
                DLog(@"判断是否为纯数字");
                if (self.orderSaletype != SaleTypeReturnGoods && self.orderSaletype != SaleTypeReturnEngageGoods) {
                    [self httpQrCode:stringValue];
                }
                else
                {
                    [SGInfoAlert showInfo:@"不支持扫箱码退货"
                                  bgColor:[[UIColor blackColor] CGColor]
                                   inView:self.view
                                 vertical:0.7];
                }
            }
            else
            {
                [self httpQrCode:stringValue];
            }

        }

    }
    
    
    NSLog(@"%@",stringValue);
    
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake((SCREEN_WIDTH-170)/2, 15+2*num, 170, 2);
        if (2*num == 170) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake((SCREEN_WIDTH-170)/2, 15+2*num, 170, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)httpScanInfo
{
    DLog(@"data = %@",[NSObject currentTime]);

    self.isfinish = YES;
}

-(void)deletePresellGoods:(NSNotification*)aNotification
{
    NSIndexPath *cellIndexPath = [aNotification object];
    if ([self.items count] != 0 /*&& [self.items count] > (cellIndexPath.row -1)*/) {
//        [self.items removeObjectAtIndexSafe:[index intValue]];
        [self.items removeObjectAtIndexSafe:cellIndexPath.row];
        [self.tableview reloadData];
    }
    
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否删除此商品" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
                DLog(@"否");
                
                NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
                
                [self.items removeObjectAtIndex:cellIndexPath.row];
//                [self.items removeObjectAtIndexSafe:index];
                [self.tableview reloadData];
                
            } otherButtonBlock:^{
                DLog(@"是");
                
                
            }];
            
            [self.stAlertView show];
            
            
            break;
        }
        default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}
-(void)ClickSingleGoods:(NSNotification*)aNotification
{
    PresellOperation * operatino = [[PresellOperation alloc] init];
   operatino = [aNotification object];
    NSMutableDictionary* product = [NSMutableDictionary dictionary];
    NSMutableArray* tempArray = [self.items mutableCopy];
    product = [tempArray objectAtIndexSafe: operatino.indexpath.row];
    NSMutableArray *QrcArr = [product objectForKeySafe: @"QrcList"];
    DLog(@"clicktype = %@ indexpath.row = %d",operatino.strClickType,operatino.indexpath.row)
//    NSMutableArray *prodQrcArr = product[@"QrcList"];
    if([operatino.strClickType intValue] == 1)//减去一
    {
        DLog(@"减去一");
        [QrcArr removeLastObject];
    }
    else if ([operatino.strClickType intValue] == 2)// 加一
    {
        DLog(@"增加一");
        [QrcArr addObjectSafe:[QrcArr objectAtIndexSafe:0]];
    }
    else
    {
        DLog(@"无操作");
    }
    [product setObjectSafe:QrcArr forKey:@"QrcList"];
    [self.items replaceObjectAtIndexSafe:operatino.indexpath.row withObject:product];
    
    
    if ([operatino.operationPage intValue] == 1) {
        [self.tableview reloadData];
    }
}


- (void)initCapture
{
    _session = [[AVCaptureSession alloc]init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //    [_device setVideoZoomFactor:50.0f];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
//    AVCaptureDevice* inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
//    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [_session addInput:_input];
    
    _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    _captureOutput.alwaysDiscardsLateVideoFrames = YES;
    [_captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    NSString* key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [_captureOutput setVideoSettings:videoSettings];
    [_session addOutput:_captureOutput];
    
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height;
//    CGFloat tm_X = 15.0/height;
//    CGFloat tm_Y = ((width - 170.0)/2)/width;
//    CGFloat tm_Width = 170.0/height;
//    CGFloat tm_Height = 170.0/width;
//    [_output setRectOfInterest:CGRectMake(tm_X,tm_Y,tm_Width ,tm_Height)];    // Session
//    DLog(@"cgrectmake = %@",NSStringFromCGRect(_output.rectOfInterest));
    
    
    NSString* preset = 0;
//    if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
//        [UIScreen mainScreen].scale > 1 &&
//        [_device
//         supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
//            // NSLog(@"960");
//            preset = AVCaptureSessionPresetiFrame960x540;
//        }
    if (!preset) {
        // NSLog(@"MED");
        preset = AVCaptureSessionPresetMedium;
    }
    _session.sessionPreset = preset;
    
    if (!self.preview) {
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    // NSLog(@"prev %p %@", self.prevLayer, self.prevLayer);
//    self.preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
//    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.view.layer addSublayer: self.preview];
//    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _preview.frame =CGRectMake(0,0,SCREEN_WIDTH,220);
    _preview.frame =CGRectMake(0,0,SCREEN_WIDTH,220);;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    self.isScanning = YES;
    [_session startRunning];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

//- (void)decodeImage:(UIImage *)image
//{
//    NSMutableSet *qrReader = [[NSMutableSet alloc] init];
//    QRCodeReader *qrcoderReader = [[QRCodeReader alloc] init];
//    [qrReader addObject:qrcoderReader];
//    
//    Decoder *decoder = [[Decoder alloc] init];
//    decoder.delegate = self;
//    decoder.readers = qrReader;
//    [decoder decodeImage:image];
//}

//#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
//{
//    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    
//    [self decodeImage:image];
//
//}
#pragma mark - DecoderDelegate
//- (void)decoder:(Decoder *)decoder willDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset;
//{
////    [self decodeImage:image];
//////    NSString* stringValue = result.text;
////    
////    
////    
////    //        [_session stopRunning];
////    //        [timer invalidate];
////    
////    //判断是否包含 头'http:'
////    
////    if (self.isfinish) {
////        self.isfinish = NO;
////        NSString *regex = @"http+:[^\\s]*";
////        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
////        
////        //判断是否包含 头'ssid:'
////        NSString *ssid = @"ssid+:[^\\s]*";;
////        NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
////        
////        //判断是否为纯数字'
////        NSString * num = @"^-?\\d+$";
////        NSPredicate * numpred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
////        if ([predicate evaluateWithObject:stringValue]) {
////            
////            DLog(@"判断是否包含 头'http:");
////            [self httpQrCode:stringValue];
////            
////        }
////        else if([ssidPre evaluateWithObject:stringValue]){
////            DLog(@"判断是否包含 头'ssid:");
////        }
////        else if([numpred evaluateWithObject:stringValue]){
////            DLog(@"判断是否为纯数字");
////            if (self.orderSaletype != SaleTypeReturnGoods && self.orderSaletype != SaleTypeReturnEngageGoods) {
////                [self httpQrCode:stringValue];
////            }
////            else
////            {
////                [SGInfoAlert showInfo:@"不支持扫箱码退货"
////                              bgColor:[[UIColor blackColor] CGColor]
////                               inView:self.view
////                             vertical:0.7];
////            }
////        }
////        else
////        {
////            [self httpQrCode:stringValue];
////        }
////        
////    }
//}
//- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)result
//{
////    self.isScanning = NO;
////    [self.session stopRunning];
//    DLog(@"result = %@",result.text);
//    NSString* stringValue = result.text;
//    
//    
//    
//    //        [_session stopRunning];
//    //        [timer invalidate];
//    
//    //判断是否包含 头'http:'
//    
//    if (self.isfinish) {
//        self.isfinish = NO;
//        NSString *regex = @"http+:[^\\s]*";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//        
//        //判断是否包含 头'ssid:'
//        NSString *ssid = @"ssid+:[^\\s]*";;
//        NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//        
//        //判断是否为纯数字'
//        NSString * num = @"^-?\\d+$";
//        NSPredicate * numpred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
//        if ([predicate evaluateWithObject:stringValue]) {
//            
//            DLog(@"判断是否包含 头'http:");
//            [self httpQrCode:stringValue];
//            
//        }
//        else if([ssidPre evaluateWithObject:stringValue]){
//            DLog(@"判断是否包含 头'ssid:");
//        }
//        else if([numpred evaluateWithObject:stringValue]){
//            DLog(@"判断是否为纯数字");
//            if (self.orderSaletype != SaleTypeReturnGoods && self.orderSaletype != SaleTypeReturnEngageGoods) {
//                [self httpQrCode:stringValue];
//            }
//            else
//            {
//                [SGInfoAlert showInfo:@"不支持扫箱码退货"
//                              bgColor:[[UIColor blackColor] CGColor]
//                               inView:self.view
//                             vertical:0.7];
//            }
//        }
//        else
//        {
//            [self httpQrCode:stringValue];
//        }
//        
//    }
//}

//- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason
//{
//    if (!self.isScanning) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有发现二维码" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
//}
- (void)stopCapture {

    self.isScanning = NO;
    [_session stopRunning];
    
    [_session removeInput:_input];

    [_session removeOutput:_captureOutput];
    [self.preview removeFromSuperlayer];
    
    self.preview = nil;
    self.session = nil;
}

//- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
//    switch (format) {
//        case kBarcodeFormatAztec:
//            return @"Aztec";
//        case kBarcodeFormatCodabar:
//            return @"CODABAR";
//        case kBarcodeFormatCode39:
//            return @"Code 39";
//        case kBarcodeFormatCode93:
//            return @"Code 93";
//        case kBarcodeFormatCode128:
//            return @"Code 128";
//        case kBarcodeFormatDataMatrix:
//            return @"Data Matrix";
//        case kBarcodeFormatEan8:
//            return @"EAN-8";
//        case kBarcodeFormatEan13:
//            return @"EAN-13";
//        case kBarcodeFormatITF:
//            return @"ITF";
//        case kBarcodeFormatPDF417:
//            return @"PDF417";
//        case kBarcodeFormatQRCode:
//            return @"QR Code";
//        case kBarcodeFormatRSS14:
//            return @"RSS 14";
//        case kBarcodeFormatRSSExpanded:
//            return @"RSS Expanded";
//        case kBarcodeFormatUPCA:
//            return @"UPCA";
//        case kBarcodeFormatUPCE:
//            return @"UPCE";
//        case kBarcodeFormatUPCEANExtension:
//            return @"UPC/EAN extension";
//        default:
//            return @"Unknown";
//    }
//}



@end
