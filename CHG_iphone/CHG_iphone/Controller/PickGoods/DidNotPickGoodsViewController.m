//
//  DidNotPickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "DidNotPickGoodsViewController.h"
#import "AllOrdersCell.h"
#import "OrderAmountCell.h"
#import "OrdersGoodsCell.h"

@interface DidNotPickGoodsViewController ()
@property UINib* AllOrdersNib;
@property UINib* OrderAmountNib;
@property UINib* OrdersGoodsNib;
@end

@implementation DidNotPickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未提货";
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    
    if ([self.items allKeys] == 0) {
//        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//        [MMProgressHUD showWithTitle:@"" status:@""];
        [self httpGetOrder];
    }
    
}

-(void)setupView
{

//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 80;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-80);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
//    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
    self.Terminationbtn.frame = CGRectMake(0, SCREEN_HEIGHT -80, SCREEN_WIDTH/2, 40);
    self.Pickupbtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT -80, SCREEN_WIDTH/2, 40);
    if (self.ManagementTyep == OrderManagementTypeAll) {
//        CGRect rect = self.tableview.frame;
//        rect.size.height = rect.size.height + 40;
//        self.tableview.frame = rect;
        self.Pickupbtn.hidden = YES;
        self.Terminationbtn.hidden = YES;
        self.line.hidden = YES;
        self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40);
    }
    else
    {
        self.Pickupbtn.hidden = NO;
        self.Terminationbtn.hidden = NO;
        self.line.hidden = NO;
    }
//    rect = self.Pickupbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 80;
//    rect.size.width = SCREEN_WIDTH/2;
//    self.Pickupbtn.frame = rect;
//    
//    rect = self.Terminationbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 80;
//    rect.size.width = SCREEN_WIDTH/2;
//    self.Terminationbtn.frame = rect;
    
    [self setupRefresh];
}
-(IBAction)orderProcessing:(UIButton*)sender
{
    if ([[self.items objectForKeySafe:@"productList"] count] != 0) {
        if (self.BtnSkipSelect) {
            self.BtnSkipSelect(sender.tag,self.items);
        }
    }
    else
    {
        NSString* strinfo ;
        if (sender.tag == 100) {
            strinfo = @"无商品";
        }
        else
        {
            strinfo = @"无提货商品";
        }
        [SGInfoAlert showInfo:strinfo
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
//        if(cell==nil){
//            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        NSDictionary* dict =  [[self.items objectForKey:@"productList"] objectAtIndex:indexPath.row] ;
//        
//        [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
//        cell.titlelab.text = dict[@"productName"];
//        cell.pricelab.text = dict[@"productPrice"];;
//        cell.countlab.text = [dict objectForKey:@"count"];
//
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        cell.picktype = PickUpTypeDidNot;
       
        cell.height = self.m_height;
        [cell setupAllOrderView:self.items];
        cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
            if (self.didSelectedSubItemAction) {
                self.didSelectedSubItemAction(indexPath);
            }
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
        if(cell==nil){
            cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
       
        NSArray* prolist = [self.items objectForKeySafe:@"productList"];
        CGFloat orderAmount = 0.0;
//        CGFloat orderFactAmount = 0.0;

        for (int i = 0; i < [prolist count]; i ++) {
            CGFloat price = [[[prolist objectAtIndexSafe: i] objectForKeySafe: @"productPrice"] doubleValue];
            orderAmount += price * [[[prolist objectAtIndexSafe: i] objectForKeySafe: @"remainQuantity"] floatValue];
            
        }
        
        
        CGFloat orderAmountWth = [[self.items objectForKeySafe:@"orderAmountWth"] floatValue];
        CGFloat orderFactAmountWth = [[self.items objectForKeySafe:@"orderFactAmountWth"] floatValue];
        cell.receivablelab.text =[NSString stringWithFormat:@"￥%.2f", orderAmountWth];
        cell.Receivedlab.text = [NSString stringWithFormat:@"￥%.2f", orderFactAmountWth];
        
//        orderFactAmount += [[self.items objectForKey:@"orderFactAmount"] floatValue] /self.quantity * self.remainQuantity;
//        cell.receivablelab.text =[NSString stringWithFormat:@"%.2f", orderAmount];
//        cell.Receivedlab.text = [NSString stringWithFormat:@"%.2f", orderFactAmount];
        [cell.Receivedlab setEnabled:NO];
        cell.favorablelab.text = [NSString stringWithFormat:@"￥%.2f", orderAmountWth - orderFactAmountWth];
//        if ([self.items[@"getGoodsNum"] intValue] == 0) {
//            cell.receivablelab.text =@"0.00";
//            cell.Receivedlab.text = @"0.00";
//            [cell.Receivedlab setEnabled:NO];
//            cell.favorablelab.text = @"0.00";
//            
//            [cell.Receivedlab setEnabled:NO];
//        }
//        else
//        {
//            NSArray* prolist = [self.items objectForKey:@"productList"];
//            CGFloat orderAmount;
//            CGFloat orderFactAmount;
//            for (int i = 0; i < [prolist count]; i ++) {
//                CGFloat price = [prolist[i][@"productPrice"] doubleValue];
//                orderAmount += price * [prolist[i][@"remainQuantity"] doubleValue];
//                orderFactAmount += price * [prolist[i][@"remainQuantity"] doubleValue];
//            }
//            
//            
//            cell.receivablelab.text =[NSString stringWithFormat:@"%.2f", orderAmount];
//            cell.Receivedlab.text = [NSString stringWithFormat:@"%.2f", orderFactAmount];
//            [cell.Receivedlab setEnabled:NO];
//            cell.favorablelab.text = [NSString stringWithFormat:@"%.2f", [self.items[@"orderDiscount"] doubleValue]];
//        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.m_height;
    }
    else if(indexPath.section == 1)
    {
        return 90;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section != 0) {
//        return nil;
//    }
//    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
//    //    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    v_header.backgroundColor = [UIColor clearColor];
//    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//    line.backgroundColor = UIColorFromRGB(0xdddddd);
//    [v_header addSubview:line];
//    
//    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
//    datelab.textAlignment = NSTextAlignmentLeft;
//    datelab.font = FONT(13);
//    datelab.textColor = UIColorFromRGB(0x878787);;
//    datelab.text = @"未提商品";
//    [v_header addSubview:datelab];
//    
//    
//    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
//    orderstatus.textAlignment = NSTextAlignmentRight;
//    orderstatus.font = FONT(13);
//    orderstatus.textColor = UIColorFromRGB(0x878787);;
//    orderstatus.text = @"制单人:武新义(导购)";
//    [v_header addSubview:orderstatus];
//    
//    return v_header;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
////        v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        v_footer.backgroundColor = [UIColor clearColor];
//        UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//        goodscountlab.text = @" 共3件商品";
//        goodscountlab.font = FONT(13);
////        goodscountlab.textColor = UIColorFromRGB(<#rgbValue#>)
//        goodscountlab.textAlignment = NSTextAlignmentLeft;
//        [v_footer addSubview:goodscountlab];
//        
//        return v_footer;
//    }
//    return nil;
//    
//}
-(void)httpGetOrder
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];

    [parameter setObjectSafe:self.strOrderId forKey:@"orderId"];

    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrder] parameters:parameter];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@,msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
//            self.items = [data objectForKey:@"order"];
            
            NSDictionary* tmitem = [data objectForKeySafe:@"order"];
            NSArray* prolist = [tmitem objectForKeySafe:@"productList"];
            
            NSMutableArray* productList = [[NSMutableArray alloc] init];
            self.quantity = 0.0;
            self.remainQuantity = 0.0;
            for (int i = 0; i < [prolist count]; i++) {
                if ([[[prolist objectAtIndexSafe:i] objectForKeySafe:@"remainQuantity"] intValue] != 0) {
                    [productList addObjectSafe:[prolist objectAtIndexSafe:i]];
                }
                self.quantity += [[[prolist objectAtIndexSafe:i] objectForKeySafe:@"quantity"] floatValue];
                self.remainQuantity += [[[prolist objectAtIndexSafe:i] objectForKeySafe:@"remainQuantity"] floatValue];
            }
            
            NSMutableDictionary* testdict = [tmitem mutableCopy];
            [testdict setValue:productList forKey:@"productList"];
            
            self.items = [testdict copy];
            self.m_height = ([productList count] + 1)*65 - 5 + 30;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
        }
        else
        {
            [self.tableview.header endRefreshing];
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
        [self httpGetOrder];
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
- (void)setupRefresh
{
//    __weak __typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableview.header = header;
    
   
}
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        
        
        [self httpGetOrder];
        
//        [self.tableview.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
-(void)RefreshOrder
{
    [self httpGetOrder];
}

@end
