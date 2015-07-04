//
//  StoreSalesDayViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreSalesDayViewController.h"
#import "StatisticAnalysisTopCell.h"
#import "StoresInfoCell.h"
#import "pinCell.h"
#import "PartnersCell.h"
#import "MembegrowthCell.h"
@interface StoreSalesDayViewController ()
@property UINib* StatisticAnalysisTopNib;
@property UINib* StoresInfoNib;
@end

@implementation StoreSalesDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"今日销售额(元)";
            self.width = 120;
            self.strNibName = @"StoresInfoCell";
            
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strtitle = @"今日新增会员(人)";
            self.width = 75;
            self.strNibName = @"MembegrowthCell";
            
             break;
        }
        case StatisticalTypePinRewards:
        {
            self.strtitle = @"今日动销奖励(元)";
            self.width = 100;
            self.strNibName = @"pinCell";

            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strtitle = @"今日合作商消费账奖励(元)";
            self.width = 120;
            self.strNibName = @"PartnersCell";

            break;
        }
        default:
            break;
    }
    
    self.title = @"日";
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.nameLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35 );
    self.pricelab.frame = CGRectMake(0, 35, SCREEN_WIDTH, 35 );
    self.nameLab.text = self.strtitle;
    if (self.statisticalType == StatisticalTypeMembershipGrowth) {
        self.pricelab.text = @"0";
    }
    else
    {
        self.pricelab.text = @"0.00";
    }
    
    self.isSkip = NO;
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 70 -40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.frame = CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT -70);
    DLog(@"-----%@",NSStringFromCGRect(self.tableview.frame))
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
//    self.StatisticAnalysisTopNib = [UINib nibWithNibName:@"StatisticAnalysisTopCell" bundle:nil];
    self.StoresInfoNib = [UINib nibWithNibName:self.strNibName bundle:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    
    if ([self.items count] == 0 || self.isSkip) {
        [self setupRefreshPage];
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    DLog(@"self.items.count = %d",self.items.count);
    return self.items.count ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            StoresInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (StoresInfoCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            NSDictionary* dictionary = [self.items objectAtIndex:indexPath.section ];
            DLog(@"%@",dictionary);
            
            cell.datelab.text = dictionary[@"orderDate"];
            cell.statelab.text = [NSString stringWithFormat:@"订单编号:%d",[dictionary[@"orderCode"] intValue]];
            cell.namelab.text = dictionary[@"custName"];
            cell.producerlab.text = [NSString stringWithFormat:@"制单人:%@",dictionary[@"orderCreator"]];
            cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[dictionary[@"orderAmount"] doubleValue]];
            
            cell.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
            cell.skipdetails=^(NSString* orderID){
                [self goskipdetails:orderID];
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            MembegrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (MembegrowthCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            cell.datelab.text = self.items[indexPath.section][@"joinDate"];
            cell.statelab.text = self.items[indexPath.section][@"joinType"];
            
            
            cell.namelab.text = self.items[indexPath.section][@"name"];
            cell.iphonelab.text = [NSString stringWithFormat:@"%d",[[self.items[indexPath.section] objectForKey:@"mobile"] intValue]];
            
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         
            return cell;
            break;
        }
        case StatisticalTypePinRewards:
        {
            pinCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (pinCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            cell.datelab.text =  self.items[indexPath.section][@"awardSalerDate"];
            cell.statelab.text = [NSString stringWithFormat:@"订单编号:%@", self.items[indexPath.section][@"orderCode"]];;
            cell.pricelab.text = [NSString stringWithFormat:@"%.2f",[[self.items[indexPath.section]objectForKey:@"awardSalerMoney"] doubleValue]];
            
            cell.strOrderId = [NSString stringWithFormat:@"%d",[self.items[indexPath.section][@"orderId"] intValue]];
            cell.skipdetails=^(NSString* orderID){
                [self goskipdetails:orderID];
            };
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            PartnersCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (PartnersCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            cell.datelab.text = self.items[indexPath.section][@"awardSalerDate"];
            cell.statelab.text = [NSString stringWithFormat:@"订单编号:%@", self.items[indexPath.section][@"orderCode"]];
            cell.namelab.text = self.items[indexPath.section][@"partnerName"];
            cell.pricelab.text = [NSString stringWithFormat:@"%.2f",[[self.items[indexPath.section]objectForKey:@"awardSalerMoney"] doubleValue]];
            
            cell.strOrderId = [NSString stringWithFormat:@"%d",[self.items[indexPath.section][@"orderId"] intValue]];
            cell.skipdetails=^(NSString* orderID){
                [self goskipdetails:orderID];
            };
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
            break;
        }
        default:
            break;
    }

//    if (indexPath.section == 0) {
//        StatisticAnalysisTopCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StatisticAnalysisTopCell"];
//        if(cell==nil){
//            cell = (StatisticAnalysisTopCell*)[[self.StatisticAnalysisTopNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        cell.nameLab.text = self.strtitle;
//        cell.pricelab.text = [NSString stringWithFormat:@"%d",self.custCount];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
//    else
//    {
//
//        
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return self.width;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
    
}

-(void)goskipdetails:(NSString*)orderId
{
    
    if (self.skipdetails) {
        self.skipdetails(orderId);
    }
    
}
-(void)setupRefreshPage
{

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:self.strYear forKey:@"year"];
    [parameter setObject:self.strMonth forKey:@"month"];
    [parameter setObject:self.strDay forKey:@"day"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetShopSellStatOfDay] parameters:parameter];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetMyNewCustCountStatOfDay] parameters:parameter];
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardSalerStatOfDay] parameters:parameter];
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardPartnerStatOfDay] parameters:parameter];
            break;
        }
        default:
            break;
    }

    
    [self setupRefresh];
}

-(void)httpGetStatisticAnalysis
{
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:self.strUrl parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
//        [MMProgressHUD dismiss];
        DLog(@"data = %@",data);
        if (success) {
//            [MMProgressHUD dismiss];

            self.nameLab.text = self.strtitle;
//            self.pricelab.text = [NSString stringWithFormat:@"%d",[data[@"custCount"] intValue]];
//            self.items = [data objectForKey:@"custList"];
            
            switch (self.statisticalType) {
                case StatisticalTypeStoreSales:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[data[@"custCount"] doubleValue]];
                    self.items = [data objectForKey:@"custList"];
                    break;
                }
                case StatisticalTypeMembershipGrowth:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%d",[data[@"custCount"] intValue]];
                    self.items = [data objectForKey:@"custList"];
                    break;
                }
                case StatisticalTypePinRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[data[@"awardSalerCount"] doubleValue]];
                    self.items = [data objectForKey:@"awardSalerList"];
                    break;
                }
                case StatisticalTypePartnersRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[data[@"awardPartnerCount"] doubleValue]];
                    self.items = [data objectForKey:@"awardPartnerList"];
                    break;
                }
                default:
                    break;
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
        [self.tableview.header endRefreshing];
        [self.tableview.footer endRefreshing];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        
        [self httpGetStatisticAnalysis];
//        [self.tableview.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        [self httpGetStatisticAnalysis];
        // 拿到当前的上拉刷新控件，结束刷新状态
//        [self.tableview.footer endRefreshing];
    });
}


@end
