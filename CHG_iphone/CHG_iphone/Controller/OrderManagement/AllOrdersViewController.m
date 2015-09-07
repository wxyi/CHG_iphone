//
//  AllOrdersViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AllOrdersViewController.h"
//#import "AllOrdersCell.h"
#import "GoodsDetailsViewController.h"
#import "OrdersGoodsCell.h"
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
#import "CompletedOrderDetailsViewController.h"
@interface AllOrdersViewController ()
//@property UINib* AllOrdersNib;
@property UINib* OrdersGoodsNib;
@end

@implementation AllOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部订单";

//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RefreshOrder)
                                                 name:REFRESH_ORDER
                                               object:nil];
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view from its nib.
//    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    // 1.注册cell
    self.isRefresh = YES;
    self.isLastData = NO;
    self.items = [[NSMutableArray alloc] init];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
//    [SGInfoAlert removeFromSuperview];
//    [SGInfoAlert removeSGInfoAlert];
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
    return [[[self.items objectAtIndexSafe:section] objectForKeySafe:@"productList"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
    if(cell==nil){
        cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }

    NSArray* array = [[self.items objectAtIndexSafe:indexPath.section] objectForKeySafe:@"productList"];
    NSDictionary* dict = [array objectAtIndexSafe:indexPath.row];
    
//    NSString* strurl = @"http://111.202.33.27:9080/chg/pic/qrc/wx/100790.jpg";
    [cell.GoodImage setImageWithURL:[NSURL URLWithString:[dict objectForKeySafe:@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    cell.titlelab.text = [dict objectForKeySafe:@"productName"];
    cell.pricelab.text = [NSString stringWithFormat:@"￥%@",[dict objectForKeySafe:@"productPrice"]];
    cell.countlab.text = [NSString stringWithFormat:@"x %d",[[dict objectForKeySafe:@"quantity"] intValue] ];
    
    if ([[dict objectForKeySafe:@"returnQuantity"] intValue] != 0) {
        cell.returnCountlab.text = [NSString stringWithFormat:@"已退%d件",[[dict objectForKeySafe:@"returnQuantity"] intValue]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
//    AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
//    if(cell==nil){
//        cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//        
//    }
//    cell.height = 360;
//    [cell setupView:nil];
//    cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
//        if (self.didSelectedSubItemAction) {
//            self.didSelectedSubItemAction(indexPath);
//        }
//    };
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    v_header.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_header addSubview:line];
    
    NSDictionary* dict = [self.items objectAtIndexSafe:section] ;
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = UIColorFromRGB(0x878787);;
    datelab.text = [dict objectForKeySafe:@"orderDate"];
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = UIColorFromRGB(0x878787);
    NSString* statue;
    if ([[dict objectForKeySafe:@"orderStatus"] intValue] == 1)
        statue = @"已完成";
    else if ([[dict objectForKeySafe:@"orderStatus"] intValue] == 0)
        statue = @"未完成";
    NSString* orderType;
    if ([[dict objectForKeySafe:@"orderType"] isEqualToString:@"ShopSale"]) {
        orderType = @"卖货订单";
    }
    else if([[dict objectForKeySafe:@"orderType"] isEqualToString:@"ShopEngage"])
    {
        orderType = @"预售订单";
    }
    orderstatus.text = [NSString stringWithFormat:@"%@ %@",statue,orderType];
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
    v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    v_footer.backgroundColor = [UIColor clearColor];
    NSDictionary* dict = [self.items objectAtIndexSafe:section] ;
    
    NSArray* productList = [dict objectForKeySafe:@"productList"];
    NSInteger count = 0;
    for (int i = 0; i< [productList count]; i++) {
        count += [[[productList objectAtIndexSafe: i] objectForKeySafe: @"quantity"] intValue];
    }
    NSString* string = [NSString stringWithFormat:@"共%ld件商品",(long)count];
    NSRange rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%ld",(long)count]];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
    
    NIAttributedLabel* goodscountlab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.font = FONT(15);
    goodscountlab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    goodscountlab.attributedText = text;
    [v_footer addSubview:goodscountlab];
    
    
    string = [NSString stringWithFormat:@"订单金额 %.2f元",[[dict objectForKeySafe:@"orderFactAmount"] doubleValue]];
    rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%.2f",[[dict objectForKeySafe:@"orderFactAmount"] doubleValue] ]];
    text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
    
    
    
    
    //设置一个行高上限
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [string sizeWithFont:FONT(15) constrainedToSize:size];
    
    
    NIAttributedLabel* pricelab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelsize.width+5, 0, labelsize.width, 30)];
    
    pricelab.font = FONT(15);
    pricelab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    pricelab.textAlignment = NSTextAlignmentRight;
    pricelab.attributedText = text;
    [v_footer addSubview:pricelab];
    
    
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailsbtn.tag = [[NSString stringWithFormat:@"10%d",section] intValue];
    [detailsbtn.layer setMasksToBounds:YES];
    [detailsbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [detailsbtn.layer setBorderWidth:1.0]; //边框
    [detailsbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
    detailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 32, 80, 30);
    [detailsbtn setTitle:@"详情" forState:UIControlStateNormal];
    detailsbtn.titleLabel.font = FONT(13);
    [detailsbtn setTitleColor:UIColorFromRGB(0x171c61) forState:UIControlStateNormal];
    [detailsbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:detailsbtn];
    
    UILabel* line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line1];
    if ([[dict objectForKeySafe:@"orderStatus"] intValue] == 0 && self.ManagementTyep != OrderManagementTypeAll)
    {
        UIButton* Terminationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Terminationbtn.tag = [[NSString stringWithFormat:@"11%d",section] intValue];
        [Terminationbtn.layer setMasksToBounds:YES];
        [Terminationbtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [Terminationbtn.layer setBorderWidth:1.0]; //边框
        [Terminationbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
        Terminationbtn.frame = CGRectMake(SCREEN_WIDTH-90*2, 32, 80, 30);
        [Terminationbtn setTitle:@"终止订单" forState:UIControlStateNormal];
        Terminationbtn.titleLabel.font = FONT(14);
        [Terminationbtn setTitleColor:UIColorFromRGB(0x171c61)  forState:UIControlStateNormal];
        [Terminationbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
        [v_footer addSubview:Terminationbtn];
    }
    

    return v_footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict  = [self.items objectAtIndexSafe:indexPath.section];
    if (self.CellSkipSelect) {
        self.CellSkipSelect([[dict objectForKeySafe:@"productList"] objectAtIndexSafe:indexPath.row]);
    }
}
-(void)goskipdetails:(UIButton*)sender
{
    
    NSString* tag = [NSString stringWithFormat:@"%d",sender.tag];
    NSInteger section = [[tag substringFromIndex:2] intValue];
    NSInteger ntag = [[tag substringToIndex:2] intValue];
    NSDictionary* dict = [self.items objectAtIndexSafe:section];
    
//    if (ntag == 11) {
//        DLog(@"终止定单")
//        self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
//            DLog(@"否");
//            
//            
//        } otherButtonBlock:^{
//            DLog(@"是");
////            [self httpCancelOrder :dict];
//            CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
//            CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[dict[@"orderId"] intValue]];
//            CompletedOrderDetailsView.ManagementTyep = self.ManagementTyep;
//            CompletedOrderDetailsView.Comordertype = TerminationOrder;
//            [self.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
//        }];
//        
//        [self.stAlertView show];
//    
//    }
//    else
    {
        if (self.BtnSkipSelect) {
            self.BtnSkipSelect(sender.tag,dict);
        }
    }
    
    
}

-(void)httpGetAllOrderList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    if (self.ManagementTyep == OrderManagementTypeAll) {
        [parameter setObjectSafe:@""  forKey:@"custId"];
    }
    else
    {
        [parameter setObjectSafe:[ConfigManager sharedInstance].strCustId  forKey:@"custId"];
    }
    
    [parameter setObjectSafe:@"2" forKey:@"orderStatus"];
    [parameter setObjectSafe:PAGESIZE forKey:@"pageSize"];
    [parameter setObjectSafe:[NSString stringWithFormat:@"%d",self.m_nPageNumber] forKey:@"pageNumber"];
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrderList] parameters:parameter];
    
    DLog(@"url = %@",url);
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
//            [MMProgressHUD dismiss];
            
            self.isRefresh = YES;
            NSArray* dataArr = [data objectForKeySafe:@"datas"];
            if (dataArr.count < 20) {
                self.isLastData = YES;
                [SGInfoAlert showInfo:@"最后一页不再刷新"
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            }
            for (int i = 0; i< dataArr.count; i++) {
                [self.items addObjectSafe:dataArr[i]];
            }
            
            [self.tableview reloadData];
            
//            [self.tableview.header endRefreshing];
//            [self.tableview.footer endRefreshing];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
//            [self.tableview.header endRefreshing];
//            [self.tableview.footer endRefreshing];
        }
        
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
//        [MMProgressHUD dismissWithError:description];
//        [self.tableview.header endRefreshing];
//        [self.tableview.footer endRefreshing];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetAllOrderList];
    }];
}

-(void)httpCancelOrder:(NSDictionary*)dict
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCancelOrder] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObjectSafe:dict[@"orderId"] forKey:@"orderId"];
    [param setObjectSafe:dict[@"orderFactAmount"] forKey:@"factAmount"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",[data objectForKeySafe:@"datas"],[data objectForKeySafe:@"msg"]);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"] intValue]==200){
            
            self.m_nPageNumber = 1;
//            [self.items removeAllObjects];
            if ([self.items count] != 0) {
                [self.items removeAllObjects];
            }
            [self httpGetAllOrderList];

        }
        else
        {
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpCancelOrder:dict];
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
    if (self.isRefresh) {
        
        self.isRefresh = NO;
        __weak __typeof(self) weakSelf = self;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.autoChangeAlpha = YES;
        
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        
        
        [header beginRefreshing];
        
        // 马上进入刷新状态
        
        
        // 设置header
        self.tableview.header = header;
        
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
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
        self.isLastData = NO;
        self.m_nPageNumber = 1;
//        [self.items removeAllObjects];
        if ([self.items count] != 0) {
            [self.items removeAllObjects];
        }
        [self httpGetAllOrderList];
        [self.tableview.header endRefreshing];
        [self.tableview.footer endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{

    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
//        [self.tableView reloadData];
        if (!self.isLastData) {
            self.m_nPageNumber ++;
            [self httpGetAllOrderList];
            // 拿到当前的上拉刷新控件，结束刷新状态
            
            [self.tableview.footer endRefreshing];
        }
        else
        {
            [self.tableview.footer noticeNoMoreData];
        }
        
        
        
    });
}
//#pragma mark 加载最后一份数据
//- (void)loadLastData
//{
//
//    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableview reloadData];
//        
//        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//        [self.tableview.footer noticeNoMoreData];
//    });
//}
-(void)RefreshOrder
{
    self.m_nPageNumber = 1;
//    [self.items removeAllObjects];
    if ([self.items count] != 0) {
        [self.items removeAllObjects];
    }
    [self httpGetAllOrderList];
}

@end
