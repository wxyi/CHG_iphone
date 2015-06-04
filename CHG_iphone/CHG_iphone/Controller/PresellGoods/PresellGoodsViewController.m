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
    
    
    self.items = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self setupView];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.ZBarReader stop];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"image",@"Hikid聪尔壮金装复合益生源或工工工工式工工工工工工",@"title",@"336",@"price",@"X 2",@"count", nil];
    
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
        self.title = @"提货货扫描";
    }
    for (int i = 0; i < 5; i++) {
        [self.items addObject:dict];
    }
    
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    v_header.backgroundColor = [UIColor lightGrayColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:v_header.frame];
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text = @"扫描结果";
    titlelab.font = FONT(14);
    [v_header addSubview:titlelab];
    self.tableview.tableHeaderView = v_header;
    
    self.PresellNib = [UINib nibWithNibName:@"PresellCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    
    [self loopDrawLine];
    
}
//-(void)viewDidAppear:(BOOL)animated
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *codeData=[[NSString alloc]init];
    for (ZBarSymbol *sym in symbols) {
        codeData = sym.data;
        break;
    }
    
    
    
    [self.tableview reloadData];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    
}
-(void)loopDrawLine
{
    CGRect  rect = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2, 15, ZbarRead_With, 2);
    if (self.lineImage) {
        [self.lineImage removeFromSuperview];
    }
    self.lineImage = [[UIImageView alloc] initWithFrame:rect];
    self.lineImage.image = [UIImage imageNamed:@"scan_laser.png"];
    //    imageview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_laser.png"]];
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改fream的代码写在这里
                         self.lineImage.frame =CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2, 185, ZbarRead_With, 2);
                         [self.lineImage setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         if (!self.is_Anmotion) {
                             [self loopDrawLine];
                         }
                         
                     }];
    
    if (!self.is_have) {
        UIImageView *topeview=[[UIImageView alloc] init];
        topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
        topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
        
        UIImageView *lefteview=[[UIImageView alloc] init];
        lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
        lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
        
        UIImageView *righteview=[[UIImageView alloc] init];
        righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
        righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
        
        UIImageView *bottomview=[[UIImageView alloc] init];
        bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
        bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
        
        self.ZBarReader.tag = 101;
        
        self.ZBarReader.readerDelegate = self;
        self.ZBarReader.allowsPinchZoom = YES;//使用手势变焦
        self.ZBarReader.trackingColor = [UIColor blueColor];
        self.ZBarReader.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示
        self.ZBarReader.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
        
        self.ZBarReader.torchMode = 0;
        [self.ZBarReader addSubview:topeview];
        [self.ZBarReader addSubview:lefteview];
        [self.ZBarReader addSubview:righteview];
        [self.ZBarReader addSubview:bottomview];
        
        [self.ZBarReader start];
        self.is_have = YES;
    }
    [self.view addSubview:self.lineImage];
}
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        cell.GoodImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        cell.titlelab.text = [dict  objectForKey:@"title"];
        cell.pricelab.text = @"111";//[dict objectForKey:@"price"];
        cell.countlab.text = [dict  objectForKey:@"count"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        PresellCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PresellCell"];
        if(cell==nil){
            cell = (PresellCell*)[[self.PresellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        NSDictionary* dict =  [self.items objectAtIndex:indexPath.row];
        
        cell.GoodsImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        cell.titlelab.text = [dict objectForKey:@"title"];
        cell.pricelab.text = @"111";//[dict objectForKey:@"price"];
        [cell setupCell];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(IBAction)ConfirmInfo:(id)sender
{
    DLog(@"确认信息");
    OrderCounterViewController* OrderCounterView = [[OrderCounterViewController alloc] initWithNibName:@"OrderCounterViewController" bundle:nil];
    OrderCounterView.orderSaletype = self.orderSaletype;
    [self.navigationController pushViewController:OrderCounterView animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
