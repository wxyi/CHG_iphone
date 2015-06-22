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
@interface PresellGoodsViewController ()
@property UINib* PresellNib;
@property UINib* OrdersGoodsNib;
@end

@implementation PresellGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    self.items = [[NSMutableArray alloc] init];
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
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
//    self.tableview.tableHeaderView = v_header;
    
    self.PresellNib = [UINib nibWithNibName:@"PresellCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    
   
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 15, 170, 170)];
    imageView.image = [UIImage imageNamed:@"scan.png"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(75, 15, 170, 2)];
    _line.image = [UIImage imageNamed:@"scan_laser.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(httpScanInfo) userInfo:nil repeats:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [timer invalidate];
    [timer1 invalidate];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
}


//-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
//{
//    NSString *codeData=[[NSString alloc]init];
//    for (ZBarSymbol *sym in symbols) {
//        codeData = sym.data;
//        break;
//    }
//    DLog(@"codeData = %@",codeData);
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
//    if ([predicate evaluateWithObject:codeData]) {
//        
//        DLog(@"判断是否包含 头'http:");
//        [self httpQrCode:codeData];
//        
//    }
//    else if([ssidPre evaluateWithObject:codeData]){
//        DLog(@"判断是否包含 头'ssid:");
//    }
//    else if([numpred evaluateWithObject:codeData]){
//        DLog(@"判断是否为纯数字");
//        if (self.orderSaletype != SaleTypeReturnGoods && self.orderSaletype != SaleTypeReturnEngageGoods) {
//            [self httpQrCode:codeData];
//        }
//
//        
//    }
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
//-(void)loopDrawLine
//{
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
//        
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
//    }
//    [self.view addSubview:self.lineImage];
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
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        NSDictionary* dict =  [self.items objectAtIndex:indexPath.row];


         [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        cell.titlelab.text = dict[@"productName"] ;
        cell.pricelab.text = dict[@"productPrice"];
        cell.countlab.text = [NSString stringWithFormat:@"%d",[dict[@"QrcList"] count]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        PresellCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PresellCell"];
        if(cell==nil){
            cell = (PresellCell*)[[self.PresellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        
        NSDictionary* dict =  [self.items objectAtIndex:indexPath.row];

        [cell.GoodsImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        cell.titlelab.text = dict[@"productName"] ;
        cell.pricelab.text = dict[@"productPrice"];

        
        cell.TextStepper.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
        cell.counter = [dict[@"QrcList"] count];
        NSInteger Qrclistcount;
        if ([dict[@"QrcList"] count] > 60) {
            Qrclistcount = 60;
        }
        else
        {
            Qrclistcount = [dict[@"QrcList"] count];
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
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    v_header.backgroundColor = [UIColor clearColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:v_header.frame];
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text = @"扫描结果";
    titlelab.font = FONT(13);
    titlelab.textColor = UIColorFromRGB(0x323232);
    [v_header addSubview:titlelab];
    return v_header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(IBAction)ConfirmInfo:(id)sender
{
    DLog(@"确认信息");
    if (self.orderSaletype == SaleTypePickingGoods|| self.orderSaletype == SaleTypeReturnGoods) {
        [self httpValidateOrderProduct];
    }
    else
    {
        OrderCounterViewController* OrderCounterView = [[OrderCounterViewController alloc] initWithNibName:@"OrderCounterViewController" bundle:nil];
        OrderCounterView.orderSaletype = self.orderSaletype;
        
        if (self.orderSaletype == SaleTypeSellingGoods ) {
            OrderCounterView.items = self.items;
        }
        else if(self.orderSaletype == SaleTypePresell)
        {
            for (int i = 0; i < self.items.count; i++) {
                NSInteger tag  = [[NSString stringWithFormat:@"101%d",i] intValue];
                TextStepperField* TextStepper = (TextStepperField*)[self.view viewWithTag:tag];
                DLog(@"textstepper = %.f",TextStepper.Current);
                NSMutableDictionary *anotherDict = [NSMutableDictionary dictionary];
                anotherDict = [self.items objectAtIndex:i];
                [anotherDict setObject:[NSString stringWithFormat:@"%.2f", TextStepper.Current ] forKey:@"quantity"];
                [self.items replaceObjectAtIndex:i withObject:anotherDict];
            }
            OrderCounterView.items = self.items;
        }

        [self.navigationController pushViewController:OrderCounterView animated:YES];
    }
    
}

-(void)httpQrCode:(NSString*)parame
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:parame forKey:@"productCode"];
    [parameter setObject:[ConfigManager sharedInstance].strCustId forKey:@"custId"];
    
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
    [parameter setObject:type forKey:@"type"];
//    NSMutableDictionary *productpar = [NSMutableDictionary dictionary];
//    [productpar setObject:parame forKey:@"productCode"];
//    DLog(@"parameter = %@",productpar);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetProductBrief] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
            if (self.orderSaletype == SaleTypeSellingGoods || self.orderSaletype == SaleTypePickingGoods ||self.orderSaletype == SaleTypeReturnEngageGoods ||self.orderSaletype == SaleTypeReturnGoods) {
                [self addProductforSingleHair:[data objectForKey:@"datas"]];
            }
            else if(self.orderSaletype == SaleTypePresell)
            {
                [self addProductforSingleMultiple:[data objectForKey:@"datas"]];
            }
        }
        else
        {
            [MMProgressHUD dismissWithError:msg];
//            [SGInfoAlert showInfo:msg
//                          bgColor:[[UIColor darkGrayColor] CGColor]
//                           inView:self.view
//                         vertical:0.7];
        }
        
        
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
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
        [self.items addObject:product];
    }
    else
    {
        NSMutableArray* tempArray = [self.items mutableCopy];
        BOOL isSameId = NO;
        NSInteger index = 0 ;
        for (int i = 0; i < tempArray.count; i++) {
            
            NSInteger productId = [[tempArray[i] objectForKey:@"productId"] intValue];
            NSInteger dataproId = [product[@"productId"] intValue];
            
            if (productId == dataproId) {
                isSameId = YES;
                index = i;
                

            }

        }
        if (!isSameId) {
            [self.items addObject:product];
        }
        else
        {
            NSMutableArray *QrcArr = tempArray[index][@"QrcList"];
            NSMutableArray *prodQrcArr = product[@"QrcList"];
            
            for (int i = 0; i < prodQrcArr.count; i++) {
                if (i > 60) {
                    break;
                }
                [QrcArr addObject:prodQrcArr[i]];
            }
            [product setObject:QrcArr forKey:@"QrcList"];
            [self.items replaceObjectAtIndex:index withObject:product];
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
        [self.items addObject:product];
    }
    else
    {
        NSMutableArray* tempArray = [self.items copy];
        BOOL isSameId = NO;
        NSInteger index = 0 ;
        for (int i = 0; i < tempArray.count; i++) {
            
                NSInteger productId = [[tempArray[i] objectForKey:@"productId"] intValue];
                NSInteger dataproId = [product[@"productId"] intValue];
                
                if (productId == dataproId) {
                    isSameId = YES;
                    index = i;
                }
            
        }

        if (!isSameId) {
            [self.items addObject:product];
        }
        else
        {
            NSMutableArray *QrcArr = self.items[index][@"QrcList"];
            NSMutableArray *prodQrcArr = product[@"QrcList"];
            
    
            NSPredicate * QrcPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",QrcArr];
            
            NSArray * prodQrcfilter = [prodQrcArr filteredArrayUsingPredicate:QrcPredicate];
            
            NSPredicate * prodQrcredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",prodQrcArr];
            NSArray * Qrcfilter = [QrcArr filteredArrayUsingPredicate:prodQrcredicate];
            
            
            if (prodQrcfilter.count == 0 && Qrcfilter.count == 0) {
                [self.items removeObjectAtIndex:index];
            }
            else
            {
                NSMutableArray *datas = [[NSMutableArray alloc] init];
                datas = [Qrcfilter mutableCopy];
                if (prodQrcfilter.count != 0) {
                    for (int i = 0; i < prodQrcfilter.count; i++) {

                        if ([datas count] < 60) {
                            [datas addObject:prodQrcfilter[i]];
                        }
                        
                    }
                }
                [product setObject:datas forKey:@"QrcList"];
                [self.items replaceObjectAtIndex:index withObject:product];
                
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
        [anotherDict setObject:[datas[0] objectForKey:@"productName"] forKey:@"productName"];
        [anotherDict setObject:[datas[0] objectForKey:@"productPrice"] forKey:@"productPrice"];
        [anotherDict setObject:[datas[0] objectForKey:@"productSmallUrl"] forKey:@"productSmallUrl"];
        [anotherDict setObject:[datas[0] objectForKey:@"productId"] forKey:@"productId"];

        for (int i = 0; i < datas.count; i++) {
            
            [QrcArr addObject:datas[i][@"productCode"]];
        }
        [anotherDict setObject:QrcArr forKey:@"QrcList"];
        
        
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
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
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
    
    
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:[ConfigManager sharedInstance].strCustId forKey:@"custId"];


    NSString* productCode = @"";
    for (int i = 0; i < [self.items count]; i++) {
        
        productCode = [productCode stringByAppendingString:[self.items[i][@"QrcList"] componentsJoinedByString:@","]]  ;
        productCode = [productCode stringByAppendingString:@","]  ;
    }
    DLog(@"productCode = %@",productCode)
    
    [param setObject:productCode forKey:@"productCodeStr"];
    __weak typeof(self) weakSelf = self;
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
        
            [MMProgressHUD dismiss];
            OrderCounterViewController* OrderCounterView = [[OrderCounterViewController alloc] initWithNibName:@"OrderCounterViewController" bundle:nil];
            OrderCounterView.orderSaletype = weakSelf.orderSaletype;
            OrderCounterView.items = weakSelf.items;
            OrderCounterView.priceDict = [data objectForKey:@"datas"];
            [weakSelf.navigationController pushViewController:OrderCounterView animated:YES];
            
        }
        else
        {
            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
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
- (void)setupCamera
{
    // Device
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
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
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
    [self.view addSubview:lefteview];
    [self.view addSubview:righteview];
    [self.view addSubview:bottomview];
    // Start
    [_session startRunning];
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
-(void)httpScanInfo
{
    DLog(@"data = %@",[NSObject currentTime]);

    self.isfinish = YES;
}
@end
