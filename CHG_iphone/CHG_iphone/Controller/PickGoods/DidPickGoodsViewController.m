//
//  DidPickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "DidPickGoodsViewController.h"
#import "AllOrdersCell.h"
#import "OrderAmountCell.h"
#import "OrdersGoodsCell.h"
@interface DidPickGoodsViewController ()
@property UINib* OrdersGoodsNib;
@property UINib* AllOrdersNib;
@property UINib* OrderAmountNib;
@end

@implementation DidPickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已提货";
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
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithTitle:@"" status:@""];
        [self httpGetOrder];
    }
}
-(IBAction)orderProcessing:(UIButton*)sender
{
    DLog(@"退货");
    if ([[self.items objectForKey:@"productList"] count] != 0) {
        if (self.BtnSkipSelect) {
            self.BtnSkipSelect(sender.tag,self.items);
        }
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
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
    
    
    self.returnbtn.frame = CGRectMake(0, SCREEN_HEIGHT -80, SCREEN_WIDTH, 40);
    if (self.ManagementTyep == OrderManagementTypeAll) {
//        CGRect rect = self.tableview.frame;
//        rect.size.height = rect.size.height + 40;
//        self.tableview.frame = rect;
        self.returnbtn.hidden = YES;
        self.line.hidden = YES;
    }
    
//    rect = self.returnbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT -80;
//    self.returnbtn.frame = rect;
    [self setupRefresh];
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
//        //        NSDictionary* dict =  [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
//        
//        cell.GoodImage.image = [UIImage imageNamed:@"image1.jpg"];
//        cell.titlelab.text = @"理；大口日大日大田土日大田日土田大日";
//        cell.pricelab.text = @"111";//[dict objectForKey:@"price"];
//        cell.countlab.text = @"500";
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.picktype = PickUpTypeDid;
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
            cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        
        cell.receivablelab.text =[NSString stringWithFormat:@"%.2f", [self.items[@"orderAmount"] doubleValue]];
        cell.Receivedlab.text = [NSString stringWithFormat:@"%.2f", [self.items[@"orderFactAmount"] doubleValue]];
        [cell.Receivedlab setEnabled:NO];
        cell.favorablelab.text = [NSString stringWithFormat:@"%.2f", [self.items[@"orderDiscount"] doubleValue]];

        [cell.Receivedlab setEnabled:NO];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.m_height;
    }
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 1;
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
//    datelab.text = @"已提商品";
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
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section != 0) {
//        return nil;
//    }
//    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
////    v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    v_footer.backgroundColor = [UIColor clearColor];
//    UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//    goodscountlab.text = @" 共3件商品 1件赠品";
//    goodscountlab.font = FONT(14);
//    goodscountlab.textAlignment = NSTextAlignmentLeft;
//    [v_footer addSubview:goodscountlab];
//    
//    UILabel* Pickuplab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//    Pickuplab.text = @"共提货2次";
//    Pickuplab.font = FONT(14);
//    Pickuplab.textAlignment = NSTextAlignmentRight;
//    [v_footer addSubview:Pickuplab];
//    
//    return v_footer;
//}
-(void)httpGetOrder
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    [parameter setObject:self.strOrderId forKey:@"orderId"];
    
    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrder] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@,msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
            
            NSDictionary* tmitem = [data objectForKey:@"order"];
            NSArray* prolist = [tmitem objectForKey:@"productList"];
            
            NSMutableArray* productList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [prolist count]; i++) {
                
                NSInteger quantity = [[[prolist objectAtIndex:i] objectForKey:@"quantity"] integerValue] ;
                NSInteger remainQuantity = [[[prolist objectAtIndex:i] objectForKey:@"remainQuantity"] integerValue] ;
                if (quantity - remainQuantity > 0) {
                    [productList addObject:[prolist objectAtIndex:i]];
                }
                
            }
            
            NSMutableDictionary* testdict = [tmitem mutableCopy];
            [testdict setValue:productList forKey:@"productList"];
            
            self.items = [testdict copy];
            
//            self.items = [data objectForKey:@"order"];
            self.m_height = ([productList count] + 1)*65 - 5 + 30;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [self.tableview.header endRefreshing];
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
//    [header beginRefreshing];
    
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


@end
