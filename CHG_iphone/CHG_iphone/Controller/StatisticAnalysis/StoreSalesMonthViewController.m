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
    self.isSkip = NO;
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"本月会员消费(元)";
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strtitle = @"本月新增会员(人)";
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strtitle = @"本月动销奖励(元)";
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strtitle = @"本月消费分账奖励(元)";
            break;
        }
        default:
            break;
    }
    self.nameLab.text = self.strtitle;
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.nameLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35 );
    self.pricelab.frame = CGRectMake(0, 35, SCREEN_WIDTH, 35 );
    if (self.statisticalType == StatisticalTypeMembershipGrowth) {
        self.pricelab.text = @"0";
    }
    else
        self.pricelab.text = @"0.00";
    
    
    self.items = [[NSMutableArray alloc] init];
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 70 -40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.frame = CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT -70);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    self.StatisticAnalysisTopNib = [UINib nibWithNibName:@"StatisticAnalysisTopCell" bundle:nil];
    self.StatisticsNib = [UINib nibWithNibName:@"StatisticsCell" bundle:nil];
    
    
    [self setupRefreshPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    if ([self.items count] == 0 || self.isSkip) {
//        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//        [MMProgressHUD showWithTitle:@"" status:@""];
//        [self httpGetStatisticAnalysis];
        [self setupRefreshPage];
    }
    
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
        cell = (StatisticsCell*)[[self.StatisticsNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    //        [cell setStatistics:@"2015-5-10" number:[NSString stringWithFormat:@"%d",20*indexPath.section]];
    NSDictionary* dictionary = [self.items objectAtIndexSafe:indexPath.section ];
    
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            [cell setStatistics:[dictionary objectForKeySafe:@"day"] number:[NSString stringWithFormat:@"%.2f",[[dictionary objectForKeySafe:@"sellAmount"] doubleValue]]  baseData:self.nbaseData];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            [cell setStatistics:[dictionary objectForKeySafe:@"day"] number:[NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"count"] intValue]] baseData:self.nbaseData];
            break;
        }
        case StatisticalTypePinRewards:
        {
            [cell setStatistics:[dictionary objectForKeySafe: @"day"] number:[NSString stringWithFormat:@"%.2f",[[dictionary objectForKeySafe: @"awardSalerAmount"] doubleValue]] baseData:self.nbaseData];
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            [cell setStatistics:[dictionary objectForKeySafe: @"day"] number:[NSString stringWithFormat:@"%.2f",[[dictionary objectForKeySafe:@"awardPartnerAmount"] doubleValue]] baseData:self.nbaseData];
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

    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
//    if (section == 0) {
//        return 1;
//    }
//    else
//    {
//        return 10;
//    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.CellSkipSelect) {
        self.CellSkipSelect([self.items objectAtIndexSafe:indexPath.section ]);
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)setupRefreshPage
{
//    self.isRefresh = YES;
    [self setupRefresh];
}
-(void)httpGetStatisticAnalysis
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:self.strYear forKey:@"year"];
    [parameter setObjectSafe:self.strMonth forKey:@"month"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetShopSellStatOfMonth] parameters:parameter];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetMyNewCustCountStatOfMonth] parameters:parameter];
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardSalerStatOfMonth] parameters:parameter];
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardPartnerStatOfMonth] parameters:parameter];
            break;
        }
        default:
            break;
    }
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    
    [HttpClient asynchronousRequestWithProgress:self.strUrl parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
//        [MMProgressHUD dismiss];
        DLog(@"data = %@",data);
        if (success) {
            [MMProgressHUD dismiss];
            
            NSArray* tm_item;
//            [self.items removeAllObjects];
            if ([self.items count] != 0) {
                [self.items removeAllObjects];
            }
            switch (self.statisticalType) {
                case StatisticalTypeStoreSales:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe: @"sellCount"] doubleValue]];
                    tm_item = [data objectForKeySafe:@"sellList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe:i] objectForKeySafe: @"sellAmount"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                case StatisticalTypeMembershipGrowth:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%d",[[data objectForKeySafe: @"custCount"] intValue]];
//                    self.items = [data objectForKey:@"custList"];
                    tm_item = [data objectForKeySafe:@"custList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe: i] objectForKeySafe: @"count"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                case StatisticalTypePinRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe: @"awardSalerCount"] doubleValue]];
//                    self.items = [data objectForKey:@"awardSalerList"];
                  
                    tm_item = [data objectForKeySafe:@"awardSalerList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe: i] objectForKeySafe: @"awardSalerAmount"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                case StatisticalTypePartnersRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe: @"awardPartnerCount"] doubleValue]];
//                    self.items = [data objectForKey:@"awardPartnerList"];
                    tm_item = [data objectForKeySafe:@"awardPartnerList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe: i] objectForKeySafe: @"awardPartnerAmount"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            self.nbaseData = [[data objectForKeySafe: @"baseData"] intValue];
            
            NSDate *now = [NSDate date];
            NSLog(@"now date is: %@", now);
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

            int month = [dateComponent month];
            int year = [dateComponent year];
            if ([self.strMonth intValue] != month) {
                self.nameLab.text = [NSString stringWithFormat:@"%@年%@月%@",self.strYear,self.strMonth,[self GetCurrentTitle]];
            }
            else
            {
                if ([self.strYear intValue] != year) {
                    self.nameLab.text = [NSString stringWithFormat:@"%@年%@月%@",self.strYear,self.strMonth,[self GetCurrentTitle]];
                }
                else
                {
                    self.nameLab.text = self.strtitle;
                }
                
            }
            
            
//            if ([self.items count] == 0) {
//                [SGInfoAlert showInfo:[NSString stringWithFormat:@"%@-%@数据为空",self.strYear,self.strMonth]
//                              bgColor:[[UIColor darkGrayColor] CGColor]
//                               inView:self.view
//                             vertical:0.7];
//            }
            
            
            [self reLoadView];
//            [self.tableview.header endRefreshing];
//            [self.tableview.footer endRefreshing];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
//            [self.tableview.header endRefreshing];
//            [self.tableview.footer endRefreshing];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [self.tableview.header endRefreshing];
//        [self.tableview.footer endRefreshing];
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetStatisticAnalysis];
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
        self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
        
        NSDate *now = [NSDate date];
        NSLog(@"now date is: %@", now);
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        
        int year = [dateComponent year];
        int month = [dateComponent month];
        NSString *nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] + 1];
        NSString* nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue]];
        if ([nextMonth intValue] >= month ) {
            if ([nextYear intValue] >= year) {
                nextMonth = [NSString stringWithFormat:@"%d",month];
                nextYear = [NSString stringWithFormat:@"%d",year];
            }
            else
            {
                if ([nextMonth intValue] == 13) {
                    nextMonth = @"1";
                    nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue] + 1];
                }
            }
        }
        
        
        self.strYear = nextYear;
        self.strMonth = nextMonth;
        [self httpGetStatisticAnalysis];
        [self.tableview.header endRefreshing];
        
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
        
        
        
        NSString *lastMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue]- 1];
        
        NSString* lastYear =[NSString stringWithFormat:@"%d",[self.strYear intValue]];
        if ([lastMonth intValue] == 0) {
            lastMonth = @"12";
            lastYear = [NSString stringWithFormat:@"%d",[self.strYear intValue]- 1];
        }
        self.strYear = lastYear;
        self.strMonth = lastMonth;
        [self httpGetStatisticAnalysis];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableview.footer endRefreshing];
    });
}
-(NSString*)GetCurrentTitle
{
    NSString* title;
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            title = @"会员消费(元)";
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            title = @"新增会员(人)";
            break;
        }
        case StatisticalTypePinRewards:
        {
            title = @"动销奖励(元)";
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            title = @"消费分账奖励(元)";
            break;
        }
        default:
            break;
    }
    return title;
}
- (void)reLoadView {
    [self.tableview reloadData];
    if (self.items != nil && [self.items count] > 0) {
        [self.tableview setContentOffset:CGPointMake(0,0 ) animated:NO];
    }
}
@end
