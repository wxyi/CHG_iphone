//
//  MyAccountViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MyAccountViewController.h"
#import "RewardsCell.h"
#import "SettlementCell.h"
#import "GrowthCell.h"
#import "StoreSalesViewController.h"
@interface MyAccountViewController ()
@property UINib* RewardsNib;
@property UINib* SettlementNib;
@property UINib* GrowthNib;
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];

    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_return.png"] style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    
    
    
    self.config = [[SUHelper sharedInstance] currentUserConfig];
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    [self getCurrentData];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.RewardsNib = [UINib nibWithNibName:@"RewardsCell" bundle:nil];
    self.SettlementNib = [UINib nibWithNibName:@"SettlementCell" bundle:nil];
    self.GrowthNib = [UINib nibWithNibName:@"GrowthCell" bundle:nil];
    
    [self httpGetMyAccount];
    [self setupRefresh];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.config.Roles isEqualToString:@"PARTNER"]) {
        return 3;
    }
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        RewardsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RewardsCell"];
        if(cell==nil){
            cell = (RewardsCell*)[[self.RewardsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        
        
        NSArray* itme = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"可用奖励(元)",@"title",[NSString stringWithFormat:@"%.2f",[self.dictionary[@"awardUsing"] doubleValue]],@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"累计奖励收益(元)",@"title",[NSString stringWithFormat:@"%.2f",[self.dictionary[@"awardTotal"] doubleValue]],@"count", nil], nil];
        cell.RewardsView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        cell.isMy = YES;
        [cell setupView:[itme mutableCopy]];
        
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
//            [weakSelf didSelectRewardsCell:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        SettlementCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SettlementCell"];
        if(cell==nil){
            cell = (SettlementCell*)[[self.SettlementNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
//        cell.datelab.text = @"2015-06-15";
//        cell.statelab.text = @"支出";
//        cell.namelab.text = @"晨冠以结算";
//        cell.pricelab.text = @"￥200";
//        cell.BankCardlab.text = @"工商银行";
//        cell.CardNumlab.text = @"6210*******79263";
        
        
        cell.datelab.text = [NSString stringWithFormat:@"%@-%@-%@",self.strYear,self.strMonth,self.strDay];
        cell.statelab.text = @"支出";
        cell.namelab.text = @"晨冠已结算";
        cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[self.dictionary[@"awardArrive"] doubleValue]];
        cell.BankCardlab.text = self.dictionary[@"awardArriveBank"];
        cell.CardNumlab.text = self.dictionary[@"awardAccount"];

        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        GrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrowthCell"];
        if(cell==nil){
            cell = (GrowthCell*)[[self.GrowthNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        if (indexPath.section == 2 && ![self.config.Roles isEqualToString:@"PARTNER"]) {
            cell.datelab.text = [NSString stringWithFormat:@"%@-%@-%@",self.strYear,self.strMonth,self.strDay];
            cell.statelab.text = @"收入";
            cell.namelab.text = @"动销奖励";
            cell.iphonelab.text = [NSString stringWithFormat:@"￥%.2f",[self.dictionary[@"awardSaleAmount"] doubleValue]];
            cell.skipbtn.tag = 101;
        }
        else
        {
            cell.datelab.text = [NSString stringWithFormat:@"%@-%@-%@",self.strYear,self.strMonth,self.strDay];
            cell.statelab.text = @"收入";
            cell.namelab.text = @"消费分账奖励";
            cell.iphonelab.text = [NSString stringWithFormat:@"￥%.2f",[self.dictionary[@"awardPartnerAmount"] doubleValue]];
            cell.skipbtn.tag = 102;
        }
        
        cell.iphonelab.textColor = UIColorFromRGB(0xf5a541);
        cell.didSkipSubItem = ^(NSInteger tag){
            
            [weakSelf goskipdetails:tag];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if(section == 1)
    {
        return 30;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 75;
    }
    else if(indexPath.section == 1)
    {
        return 90;
    }
    else
        return 105;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        v_header.backgroundColor = UIColorFromRGB(0xdddddd);;
        UILabel* detaillab = [[UILabel alloc] initWithFrame:v_header.frame];
        detaillab.textAlignment = NSTextAlignmentCenter;
        detaillab.textColor = [UIColor grayColor];
        detaillab.text = @"账户明细";
        detaillab.font = FONT(14);
        [v_header addSubview:detaillab];
        return v_header;
    }
    return nil;
}
-(void)goskipdetails:(NSInteger)tag
{
    
    DLog(@"详情");
    StatisticalType statType;
    NSString* title;
    if (tag == 101) {
        statType = StatisticalTypePinRewards;
        title = @"动销奖励";
    }
    else
    {
        statType = StatisticalTypePartnersRewards;
        title = @"消费分账奖励";
    }
    
    StoreSalesViewController* StoreSalesView = [[StoreSalesViewController alloc] initWithNibName:@"StoreSalesViewController" bundle:nil];
    StoreSalesView.statisticalType = statType;
    StoreSalesView.title = title;
    [self.navigationController pushViewController:StoreSalesView animated:YES];
    
}

-(void)httpGetMyAccount
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
  
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:[NSString stringWithFormat:@"%@-%@-%@",self.strYear,self.strMonth,self.strDay] forKey:@"queryDate"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetMyAccount] parameters:parameter];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
//        [MMProgressHUD dismiss];
        if (success) {
            [MMProgressHUD dismiss];
//            for (int i = 1; i < 4; i ++ ) {
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
//            

            self.dictionary = data;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
            [self.tableview.footer endRefreshing];
        }
        else
        {
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
        [self.tableview.header endRefreshing];
        [self.tableview.footer endRefreshing];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

-(void)getCurrentData
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    
    self.strYear = [NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
    self.strMonth = [NSString stringWithFormat:@"%d",[dateComponent month]];
    self.strDay = [NSString stringWithFormat:@"%d",[dateComponent day]];
    
    
}


- (void)setupRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
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
        
        NSString *lastMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue]- 1];
        
        NSString* lastYear =[NSString stringWithFormat:@"%d",[self.strYear intValue]];
        if ([lastMonth intValue] == 0) {
            lastMonth = @"12";
            lastYear = [NSString stringWithFormat:@"%d",[self.strYear intValue]- 1];
        }
        self.strYear = lastYear;
        self.strMonth = lastMonth;
        [self httpGetMyAccount];
//        [self httpGetStatisticAnalysis];
        //        [self.tableview.header endRefreshing];
        
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
        [self httpGetMyAccount];
//        [self httpGetStatisticAnalysis];
        // 拿到当前的上拉刷新控件，结束刷新状态
        //        [self.tableview.footer endRefreshing];
    });
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
