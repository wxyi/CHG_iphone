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
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"今日会员消费(元)";
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
            self.strtitle = @"今日消费分账奖励(元)";
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
    self.pricelab.frame = CGRectMake(0, 30, SCREEN_WIDTH, 35 );
    self.line.frame = CGRectMake(0, 65, SCREEN_WIDTH, 5 );
    self.nameLab.text = self.strtitle;
    if (self.statisticalType == StatisticalTypeMembershipGrowth) {
        self.pricelab.text = @"0";
    }
    else
    {
        self.pricelab.text = @"0.00";
    }
    self.items = [[NSMutableArray alloc] init];
    self.isSkip = NO;
    self.isRefresh = YES;
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 70 -40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.frame = CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT -70 - 40);
    DLog(@"-----%@",NSStringFromCGRect(self.tableview.frame))
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
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
                cell = (StoresInfoCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            NSDictionary* dictionary = [self.items objectAtIndexSafe:indexPath.section ];
            DLog(@"%@",dictionary);
            
            cell.datelab.text = [dictionary objectForKeySafe:@"orderDate"];
            cell.statelab.text = [NSString stringWithFormat:@"订单编号:%d",[[dictionary objectForKeySafe:@"orderCode"] intValue]];
            cell.namelab.text = [dictionary objectForKeySafe:@"custName"];
            cell.producerlab.text = [NSString stringWithFormat:@"制单人:%@",[dictionary objectForKeySafe:@"orderCreator"]];
            cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[[dictionary objectForKeySafe:@"orderFactAmount"] doubleValue]];
            
            cell.items = [self.items objectAtIndexSafe:indexPath.section];
            cell.CellSkipSelect=^(NSDictionary* dictionary){
                [self goskipdetails:dictionary];
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            MembegrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (MembegrowthCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            cell.datelab.text = [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe: @"joinDate"];
            cell.statelab.text = [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"comeFrom"];
            
            
            cell.namelab.text = [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"name"];
            
            NSString* text = [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"mobile"];
            NSMutableString *nsiphone = [[NSMutableString alloc] initWithString:text];
            [nsiphone insertString:@" " atIndex:7];
            [nsiphone insertString:@" " atIndex:3];
            
            cell.iphonelab.text = nsiphone;
            
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
         
            return cell;
            break;
        }
        case StatisticalTypePinRewards:
        {
            pinCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (pinCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            cell.datelab.text =  [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"awardSalerDate"];
            cell.statelab.text = [NSString stringWithFormat:@"订单编号:%@", [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"orderCode"]];;
            cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.items[indexPath.section]objectForKeySafe:@"awardSalerMoney"] doubleValue]];
            
            cell.items = [self.items objectAtIndexSafe:indexPath.section];
            cell.CellSkipSelect=^(NSDictionary* dictionary){
                [self goskipdetails:dictionary];
            };
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            PartnersCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
            if(cell==nil){
                cell = (PartnersCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            cell.datelab.text = [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"awardSalerDate"];
            cell.statelab.text = [NSString stringWithFormat:@"订单编号:%@", [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"orderCode"]];
            cell.namelab.text = [[self.items objectAtIndexSafe: indexPath.section] objectForKeySafe:@"partnerName"];
            cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.items[indexPath.section]objectForKeySafe:@"awardSalerMoney"] doubleValue]];
            
            cell.items = [self.items objectAtIndexSafe: indexPath.section];
            cell.CellSkipSelect=^(NSDictionary* dictionary){
                [self goskipdetails:dictionary];
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
    if (StatisticalTypeMembershipGrowth == self.statisticalType) {
        return 0.1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}

-(void)goskipdetails:(NSDictionary*)dictionary
{
    
    if (self.CellSkipSelect) {
        self.CellSkipSelect(dictionary);
    }
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
    [parameter setObjectSafe:self.strDay forKey:@"day"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
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
            NSArray* tm_item;
            if ([self.items count] != 0) {
                DLog("is NSMutableArray %d\n", [self.items isKindOfClass:[NSMutableArray class]]);
                [self.items removeAllObjects];
                
            }
            
            switch (self.statisticalType) {
                case StatisticalTypeStoreSales:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe: @"custCount"] doubleValue]];
//                    self.items = [data objectForKey:@"custList"];
                    tm_item = [data objectForKeySafe:@"custList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe:i] objectForKeySafe:@"orderAmount"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                case StatisticalTypeMembershipGrowth:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%d",[[data objectForKeySafe:@"custCount"] intValue]];
                    tm_item = [data objectForKeySafe:@"custList"];
                    self.items = [tm_item mutableCopy];
                    
                    break;
                }
                case StatisticalTypePinRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe:@"awardSalerCount"] doubleValue]];
//                    self.items = [data objectForKey:@"awardSalerList"];
                    
                    tm_item = [data objectForKeySafe:@"awardSalerList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe:i] objectForKeySafe:@"awardSalerMoney"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                case StatisticalTypePartnersRewards:
                {
                    self.pricelab.text =[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe:@"awardPartnerAmount"] doubleValue]];
                    
                    
                    tm_item = [data objectForKeySafe:@"awardPartnerList"];
                    for (int i = 0; i < [tm_item count]; i ++) {
                        if ([[[tm_item objectAtIndexSafe:i] objectForKeySafe:@"awardSalerMoney"] intValue ] != 0) {
                            [self.items addObjectSafe:tm_item[i]];
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            
            int month = [dateComponent month];
            int year = [dateComponent year];
            int day = [dateComponent day];
            if ([self.strDay intValue]== day
                && [self.strMonth intValue] == month
                && [self.strYear intValue] == year) {
                self.nameLab.text = self.strtitle;
            }
            else
            {
                self.nameLab.text = [NSString stringWithFormat:@"%@年%@月%@日%@",self.strYear,self.strMonth,self.strDay,[self GetCurrentTitle]];
                
            }
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
        NSDate *now = [NSDate date];
        NSLog(@"now date is: %@", now);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        
        int year = [dateComponent year];
        int month = [dateComponent month];
        int day = [dateComponent day];

        NSString *nextDay;
        if (self.isSkip) {
            self.isSkip = NO;
            nextDay = [NSString stringWithFormat:@"%d",[self.strDay intValue]];
        }
        else
        {
            nextDay = [NSString stringWithFormat:@"%d",[self.strDay intValue] + 1];
        }
        
        NSString *nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue]];
        NSString* nextYear =[NSString stringWithFormat:@"%d",[self.strYear intValue]];
        
        NSArray* bigMonth = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
        NSArray* smallMonth = @[@"4",@"6",@"9",@"11"];
        
        if (([self.strYear intValue] > year )
            ||([self.strYear intValue]== year && [self.strMonth intValue] > month)
            || ([self.strYear intValue] == year && [self.strMonth intValue] == month && [self.strDay intValue] >= day )) {
            nextDay = [NSString stringWithFormat:@"%d",day];
            nextMonth = [NSString stringWithFormat:@"%d",month];
            nextYear = [NSString stringWithFormat:@"%d",year];
        }
        else if ([bigMonth containsObject:nextMonth]) {
            if ([nextDay intValue]== 32) {
                nextDay = @"1";
                nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] + 1];
                if ([nextMonth intValue] == 13) {
                    nextMonth = @"1";
                    nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue] + 1];
                }
            }
        }
        else if([smallMonth containsObject:nextMonth])
        {
            if ([nextDay intValue]== 31) {
                nextDay = @"1";
                nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] + 1];
                if ([nextMonth intValue] == 13) {
                    nextMonth = @"1";
                    nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue] + 1];
                }
            }

        }
        else
        {
            if (([nextYear intValue] % 4  == 0 && [nextYear intValue] % 100 != 0)  || [nextYear intValue] % 400 == 0) {

                if ([nextDay intValue]== 30) {
                    nextDay = @"1";
                    nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] + 1];
                    if ([nextMonth intValue] == 13) {
                        nextMonth = @"1";
                        nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue] + 1];
                    }
                }
            }
            else
            {

                if ([nextDay intValue]== 29) {
                    nextDay = @"1";
                    nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] + 1];
                    if ([nextMonth intValue] == 13) {
                        nextMonth = @"1";
                        nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue] + 1];
                    }
                }

            }
        }

        
        self.strDay = nextDay;
        self.strMonth = nextMonth;
        self.strYear = nextYear;

        [self httpGetStatisticAnalysis];
        [self.tableview.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        NSString *lastDay = [NSString stringWithFormat:@"%d",[self.strDay intValue]- 1];
        NSString *lastMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue]];
        NSString* lastYear =[NSString stringWithFormat:@"%d",[self.strYear intValue]];
        
        NSArray* bigMonth = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
        NSArray* smallMonth = @[@"4",@"6",@"9",@"11"];
        if ([lastDay intValue] == 0) {

            lastMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] -1];
            if ([lastMonth intValue] == 0) {
                lastYear  = [NSString stringWithFormat:@"%d",[self.strYear intValue] -1];
                lastMonth = @"12";
            }
            
            
            if ([bigMonth containsObject:lastMonth]) {
                lastDay = @"31";
            }
            else if([smallMonth containsObject:lastMonth])
            {
                lastDay = @"30";
            }
            else
            {
                if (([lastYear intValue] % 4  == 0 && [lastYear intValue] % 100 != 0)  || [lastYear intValue] % 400 == 0) {
                    lastDay = @"29";
                }
                else
                {
                    lastDay = @"28";
                }
            }
        }
        
        self.strDay = lastDay;
        self.strMonth = lastMonth;
        self.strYear = lastYear;
        
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
