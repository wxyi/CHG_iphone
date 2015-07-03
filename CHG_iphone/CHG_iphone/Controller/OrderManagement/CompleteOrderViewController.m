//
//  CompleteOrderViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "CompleteOrderViewController.h"
#import "OrdersGoodsCell.h"
#import "PickGoodsViewController.h"
#import "PresellGoodsViewController.h"
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
@interface CompleteOrderViewController ()
@property UINib* OrdersGoodsNib;
@end

@implementation CompleteOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"已完成订单";
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT  - 40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-80);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.items = [[NSMutableArray alloc] init];
    
    self.returnBtn.frame = CGRectMake(0, SCREEN_HEIGHT -80, SCREEN_WIDTH, 40);
//    self.ManagementTyep = OrderManagementTypeSingle;
    if (self.ManagementTyep == OrderManagementTypeAll) {
        CGRect rect = self.tableview.frame;
        rect.size.height = rect.size.height + 40;
        self.tableview.frame = rect;
    }
    
//    rect = self.returnBtn.frame;
//    rect.origin.y = SCREEN_HEIGHT- 40;
//    self.returnBtn.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);

    if ([self.items count] == 0) {
        [self setupRefresh];
    }
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.items objectAtIndex:section] objectForKey:@"productList"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
    if(cell==nil){
        cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    NSArray* array = [[self.items objectAtIndex:indexPath.section] objectForKey:@"productList"];
    NSDictionary* dict = [array objectAtIndex:indexPath.row];
    
    [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    cell.titlelab.text = dict[@"productName"];
    cell.pricelab.text = dict[@"productPrice"];;
    cell.countlab.text = [NSString stringWithFormat:@"x %d",[[dict objectForKey:@"quantity"] intValue] ];
    
    if ([dict[@"returnQuantity"] intValue] != 0) {
        cell.returnCountlab.text = [NSString stringWithFormat:@"已退货%d件",[dict[@"returnQuantity"] intValue]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
//    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_header.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_header addSubview:line];
     NSDictionary* dict = [self.items objectAtIndex:section] ;
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = UIColorFromRGB(0x878787);;
    datelab.text = dict[@"orderDate"];
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = UIColorFromRGB(0x878787);
    
    NSString* orderType;
    if ([dict[@"orderType"] isEqualToString:@"ShopSale"]) {
        orderType = @"卖货订单";
    }
    else if([dict[@"orderType"] isEqualToString:@"ShopEngage"])
    {
        orderType = @"预订订单";
    }

    orderstatus.text = [NSString stringWithFormat:@"%@ ",orderType];
    
    [v_header addSubview:orderstatus];
    
    return v_header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 65;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
//    v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_footer.backgroundColor = [UIColor clearColor];
    
    NSDictionary* dict = [self.items objectAtIndex:section] ;
    NSArray* productList = dict[@"productList"];
    NSInteger count = 0;
    for (int i = 0; i< [productList count]; i++) {
        count += [productList[i][@"quantity"] intValue];
    }
    NSString* string = [NSString stringWithFormat:@"共%d件商品",count];
    NSRange rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%d",count]];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
    
    NIAttributedLabel* goodscountlab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.font = FONT(15);
    goodscountlab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    goodscountlab.attributedText = text;
    [v_footer addSubview:goodscountlab];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UILabel* line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line1];
    
    UIButton* orderDetailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderDetailsbtn.tag = [[NSString stringWithFormat:@"10%d",section] intValue];
    [orderDetailsbtn.layer setMasksToBounds:YES];
    [orderDetailsbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [orderDetailsbtn.layer setBorderWidth:1.0]; //边框
    [orderDetailsbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
    orderDetailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 32, 80, 30);
    [orderDetailsbtn setTitle:@"详情" forState:UIControlStateNormal];
    orderDetailsbtn.titleLabel.font = FONT(13);
    [orderDetailsbtn setTitleColor:UIColorFromRGB(0x171c61) forState:UIControlStateNormal];
    [orderDetailsbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:orderDetailsbtn];
    
    
    return v_footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict;
    if (self.CellSkipSelect) {
        self.CellSkipSelect(dict);
    }
}
-(void)goskipdetails:(UIButton*)sender
{
    
    NSString* tag = [NSString stringWithFormat:@"%d",sender.tag];
    NSInteger section = [[tag substringFromIndex:2] intValue];
    NSDictionary* dict = [self.items objectAtIndex:section];
    if (self.BtnSkipSelect) {
        self.BtnSkipSelect(sender.tag,dict);
    }
}
-(IBAction)returnGoods:(UIButton*)sender
{
    DLog(@"退货");
//    NSString* tag = [NSString stringWithFormat:@"%d",sender.tag];
//    NSInteger section = [[tag substringFromIndex:2] intValue];
//    NSDictionary* dict = [self.items objectAtIndex:section];
    if (self.BtnSkipSelect) {
        self.BtnSkipSelect(sender.tag,nil);
    }
    
}
-(void)httpGetCompleteOrderList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    if (self.ManagementTyep == OrderManagementTypeAll) {
        [parameter setObject:@""  forKey:@"custId"];
    }
    else
    {
        [parameter setObject:[ConfigManager sharedInstance].strCustId  forKey:@"custId"];
    }
    [parameter setObject:@"1" forKey:@"orderStatus"];
    
    [parameter setObject:PAGESIZE forKey:@"pageSize"];
    [parameter setObject:[NSString stringWithFormat:@"%d",self.m_nPageNumber] forKey:@"pageNumber"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrderList] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
//            [MMProgressHUD dismiss];
            NSArray* dataArr = [data objectForKey:@"datas"];
            for (int i = 0; i< dataArr.count; i++) {
                [self.items addObject:dataArr[i]];
            }
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
            [self.tableview.footer endRefreshing];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [self.tableview.header endRefreshing];
            [self.tableview.footer endRefreshing];
            
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
    __weak __typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.tableview.header = header;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        
        self.m_nPageNumber = 1;
        [self.items removeAllObjects];
        [self httpGetCompleteOrderList];
        
//        [self.tableview.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        self.m_nPageNumber ++;
        [self httpGetCompleteOrderList];
        // 拿到当前的上拉刷新控件，结束刷新状态
//        [self.tableview.footer endRefreshing];
    });
}
@end
