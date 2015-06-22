//
//  StoreSalesMonthViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreSalesMonthViewController.h"
#import "StatisticsCell.h"
@interface StoreSalesMonthViewController ()
@property UINib* StatisticAnalysisTopNib;
@property UINib* StatisticsNib;
@end

@implementation StoreSalesMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"月";
    [self PageInfo];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    self.StatisticAnalysisTopNib = [UINib nibWithNibName:@"StatisticAnalysisTopCell" bundle:nil];
    self.StatisticsNib = [UINib nibWithNibName:@"StatisticsCell" bundle:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    [self setupRefresh];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StatisticsCell"];
    if(cell==nil){
        cell = (StatisticsCell*)[[self.StatisticsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    //        [cell setStatistics:@"2015-5-10" number:[NSString stringWithFormat:@"%d",20*indexPath.section]];
    NSDictionary* dictionary = [self.items objectAtIndex:indexPath.section ];
    
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            [cell setStatistics:dictionary[@"day"] number:[dictionary[@"sellAmount"] intValue] baseData:self.nbaseData];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            [cell setStatistics:dictionary[@"day"] number:[dictionary[@"count"] intValue] baseData:self.nbaseData];
            break;
        }
        case StatisticalTypePinRewards:
        {
            [cell setStatistics:dictionary[@"day"] number:[dictionary[@"awardSalerAmount"] intValue] baseData:self.nbaseData];
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            [cell setStatistics:dictionary[@"day"] number:[dictionary[@"awardPartnerAmount"] intValue] baseData:self.nbaseData];
            break;
        }
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
//    if (indexPath.section == 0) {
//        StatisticAnalysisTopCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StatisticAnalysisTopCell"];
//        if(cell==nil){
//            cell = (StatisticAnalysisTopCell*)[[self.StatisticAnalysisTopNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        cell.nameLab.text = self.strtitle;
//        cell.pricelab.text =[NSString stringWithFormat:@"%d",self.custCount];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
//    else
//    {
//        StatisticsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StatisticsCell"];
//        if(cell==nil){
//            cell = (StatisticsCell*)[[self.StatisticsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
////        [cell setStatistics:@"2015-5-10" number:[NSString stringWithFormat:@"%d",20*indexPath.section]];
//        NSDictionary* dictionary = [self.items objectAtIndex:indexPath.section - 1];
//        [cell setStatistics:dictionary[@"day"] number:[dictionary[@"sellAmount"] intValue] baseData:self.nbaseData];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//       
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 10;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedSubItemAction) {
        self.didSelectedSubItemAction(indexPath);
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)PageInfo
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"2015" forKey:@"year"];
    [parameter setObject:@"6" forKey:@"month"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"本月销售额(元)";
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetShopSellStatOfMonth] parameters:parameter];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strtitle = @"本月新增会员(人)";
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetMyNewCustCountStatOfMonth] parameters:parameter];
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strtitle = @"本月动销奖励(元)";
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardSalerStatOfMonth] parameters:parameter];
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strtitle = @"本月合作商消费账奖励(元)";
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardPartnerStatOfMonth] parameters:parameter];
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
            switch (self.statisticalType) {
                case StatisticalTypeStoreSales:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%d",[data[@"sellCount"] intValue]];
                    self.items = [data objectForKey:@"sellList"];
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
                    self.pricelab.text =[NSString stringWithFormat:@"%d",[data[@"awardSalerCount"] intValue]];
                    self.items = [data objectForKey:@"custList"];
                    break;
                }
                case StatisticalTypePartnersRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%d",[data[@"awardPartnerCount"] intValue]];
                    self.items = [data objectForKey:@"custList"];
                    break;
                }
                default:
                    break;
            }
            self.nbaseData = [data[@"baseData"] intValue];
            self.nameLab.text = self.strtitle;
            
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
            [self.tableview.footer endRefreshing];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [self.tableview.header endRefreshing];
            [self.tableview.footer endRefreshing];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
        [self.tableview.header endRefreshing];
        [self.tableview.footer endRefreshing];
//        [MMProgressHUD dismissWithError:description];
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
