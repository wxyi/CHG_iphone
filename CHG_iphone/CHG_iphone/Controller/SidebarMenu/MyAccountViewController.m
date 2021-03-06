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
//#import "MyAccountCell.h"
//#import "MyAccountPartnersCell.h"
#import "RewardsCollectionCell.h"
@interface MyAccountViewController ()
@property UINib* RewardsNib;
@property UINib* SettlementNib;
@property UINib* GrowthNib;

@property UINib* MyAccountNib;
@property UINib* MyAccountPartnersNib;
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];

    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_return.png"] style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    self.isfirst = YES;
    [self setupView];
    [self setupcollectionView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    
    
    self.items = [[NSMutableArray alloc] init];
    self.config = [[SUHelper sharedInstance] currentUserConfig];
//    self.config.Roles = @"PARTNER";
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    [self getCurrentData];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.RewardsNib = [UINib nibWithNibName:@"RewardsCell" bundle:nil];
    self.SettlementNib = [UINib nibWithNibName:@"SettlementCell" bundle:nil];
    self.GrowthNib = [UINib nibWithNibName:@"GrowthCell" bundle:nil];
//
//    self.MyAccountNib = [UINib nibWithNibName:@"MyAccountCell" bundle:nil];
//    self.MyAccountPartnersNib = [UINib nibWithNibName:@"MyAccountPartnersCell" bundle:nil];
    [self httpGetMyAccount];
    [self setupRefresh];

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
    __weak typeof(self) weakSelf = self;
    
    NSDictionary* dict = [self.items objectAtIndexSafe:indexPath.section];
    if([dict[@"state"] intValue ] == 0)
    {
        SettlementCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SettlementCell"];
        if(cell==nil){
            cell = (SettlementCell*)[[self.SettlementNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        //        cell.CardNumlab.text = @"6210*******79263";
        
        
        cell.datelab.text = [dict objectForKeySafe: @"amountDate"];
        cell.statelab.text = @"支出";
        cell.namelab.text = @"晨冠已结算";
        
        
        cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[[dict objectForKeySafe:@"awardcount"] doubleValue]];
        cell.BankCardlab.text = [dict objectForKeySafe:@"awardArriveBank"];
        cell.CardNumlab.text = [dict objectForKeySafe:@"awardAccount"];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        GrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrowthCell"];
        if(cell==nil){
            cell = (GrowthCell*)[[self.GrowthNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        
        if ([[dict objectForKeySafe:@"state"] intValue ] == 1 ) {
            cell.datelab.text = dict[@"amountDate"];;
            cell.statelab.text = @"收入";
            cell.namelab.text = @"动销奖励";
            
            
            cell.iphonelab.text = [NSString stringWithFormat:@"￥%.2f",[[dict objectForKeySafe:@"awardcount"] doubleValue]];;
            
            cell.skipbtn.tag = 101;
        }
        else
        {
            cell.datelab.text = [dict objectForKeySafe:@"amountDate"];;
            cell.statelab.text = @"收入";
            cell.namelab.text = @"消费分账奖励";
            
            
            cell.iphonelab.text = [NSString stringWithFormat:@"￥%.2f",[[dict objectForKeySafe:@"awardcount"] doubleValue]];
            
            cell.skipbtn.tag = 102;
        }
        
        cell.iphonelab.textColor = UIColorFromRGB(0xf5a541);
        cell.didSkipSubItem = ^(NSInteger tag){
            
            [weakSelf goskipdetails:tag data:[dict objectForKeySafe:@"amountDate"]];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
//    if ([self.config.Roles isEqualToString:@"PARTNER"]) {
//        MyAccountPartnersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyAccountPartnersCell"];
//        if(cell==nil){
//            cell = (MyAccountPartnersCell*)[[self.MyAccountPartnersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        cell.dictionary = self.items[indexPath.section];
//        [cell setUpCell];
//        
//        cell.accountSkip = ^(NSInteger index, NSString* strData) {
//            
//            [weakSelf goskipdetails:index data:strData];
//        };
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//        
//    }
//    else
//    {
//        MyAccountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyAccountCell"];
//        if(cell==nil){
//            cell = (MyAccountCell*)[[self.MyAccountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        cell.dictionary = self.items[indexPath.section];
//        [cell setUpCell];
//        cell.accountSkip = ^(NSInteger index, NSString* strData) {
//            
//            [weakSelf goskipdetails:index data:strData];
//        };
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [self.items objectAtIndexSafe: indexPath.section];
    if ([[dict objectForKeySafe:@"state"] intValue] == 0) {
        return 90;
    }
    else {
        return 105;
    }
//    if ([self.config.Roles isEqualToString:@"PARTNER"])
//    {
//        return 202;
//    }
//    else
//    {
//        return 308;
//    }
}

-(void)goskipdetails:(NSInteger)tag data:(NSString*)strData
{
    
    DLog(@"详情");
    NSArray *array = [strData componentsSeparatedByString:@"-"];
    DLog(@"array = %@",array);
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
    StoreSalesView.isSkip = YES;
    StoreSalesView.strYear = [array objectAtIndexSafe:0];
    StoreSalesView.strMonth = [array objectAtIndexSafe:1];
    StoreSalesView.strDay = [array objectAtIndexSafe:2];
    [self.navigationController pushViewController:StoreSalesView animated:YES];
    
}

-(void)httpGetMyAccount
{
    
    if (self.strDay.length == 1) {
        self.strDay = [NSString stringWithFormat:@"0%@",self.strDay];
    }
    if (self.strMonth.length == 1) {
        self.strMonth = [NSString stringWithFormat:@"0%@",self.strMonth];
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
  
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObjectSafe:[NSString stringWithFormat:@"%@-%@-%@",self.strYear,self.strMonth,@"1"] forKey:@"startDate"];
    [parameter setObjectSafe:[NSString stringWithFormat:@"%@-%@-%@",self.strYear,self.strMonth,self.strDay] forKey:@"endDate"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetMyAccount] parameters:parameter];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithTitle:@"" status:@""];
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

//            NSMutableArray* tm_array = [[NSMutableArray alloc] init ];
//            tm_array = [data objectForKey:@"assetDetail"];
//            
//            for (int i = 0 ; i < tm_array.count; i ++) {
//                <#statements#>
//            }
//            self.items = [data objectForKey:@"assetDetail"];
            
            [self createMyAccountData:[data objectForKeySafe:@"assetDetail"]];
            self.collonitems = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"账户余额(元)",@"title",[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe: @"awardUsing"] doubleValue]],@"count", nil],
                                                       [NSDictionary dictionaryWithObjectsAndKeys:@"累计账户收益(元)",@"title",[NSString stringWithFormat:@"%.2f",[[data objectForKeySafe:@"awardTotal"] doubleValue]],@"count", nil], nil];

            
            [self.collection reloadData];
//            [self.tableview.header endRefreshing];
//            [self.tableview.footer endRefreshing];
        }
        else
        {
//            [self.tableview.header endRefreshing];
//            [self.tableview.footer endRefreshing];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
//        [self.tableview.header endRefreshing];
//        [self.tableview.footer endRefreshing];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetMyAccount];
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
//    self.tableview.header = header;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    
//    if (self.isfirst) {
//        self.isfirst = NO;
//        return;
//    }
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
//        NSDate *now = [NSDate date];
//        NSLog(@"now date is: %@", now);
        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
//        
//        
//        int year = [dateComponent year];
//        int month = [dateComponent month];
        
        NSDate *now = [NSDate date];
        NSLog(@"now date is: %@", now);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        
        int year = [dateComponent year];
        int month = [dateComponent month];
        int day = [dateComponent day];
        
        NSString *nextMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] + 1];
        NSString* nextYear = [NSString stringWithFormat:@"%d",[self.strYear intValue]];
        
        NSArray* bigMonth = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
        NSArray* smallMonth = @[@"4",@"6",@"9",@"11"];
        
        if ([nextMonth intValue] < month && [nextYear intValue] <= year ) {
            if ([nextMonth intValue] == 13) {
                nextYear  = [NSString stringWithFormat:@"%d",[self.strYear intValue] + 1 ];
                nextMonth = @"1";
            }
            
            
            if ([bigMonth containsObject:nextMonth]) {
                self.strDay = @"31";
            }
            else if([smallMonth containsObject:nextMonth])
            {
                self.strDay = @"30";
            }
            else
            {
                if (([nextYear intValue] % 4  == 0 && [nextYear intValue] % 100 != 0)  || [nextYear intValue] % 400 == 0) {
                    self.strDay = @"29";
                }
                else
                {
                    self.strDay = @"28";
                }
            }
        }
        else
        {
            nextMonth = [NSString stringWithFormat:@"%d",month];
            nextYear = [NSString stringWithFormat:@"%d",year];
            self.strDay = [NSString stringWithFormat:@"%d",day];
        }
        
        self.strYear = nextYear;
        self.strMonth = nextMonth;
        
        [self httpGetMyAccount];
        
//        [self httpGetStatisticAnalysis];
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
        NSString *lastMonth = [NSString stringWithFormat:@"%d",[self.strMonth intValue] - 1];
        NSString* lastYear = [NSString stringWithFormat:@"%d",[self.strYear intValue]];
        
        NSArray* bigMonth = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
        NSArray* smallMonth = @[@"4",@"6",@"9",@"11"];
        
        if ([lastMonth intValue] == 0) {
            lastYear  = [NSString stringWithFormat:@"%d",[self.strYear intValue] -1];
            lastMonth = @"12";
        }
        
        
        if ([bigMonth containsObject:lastMonth]) {
            self.strDay = @"31";
        }
        else if([smallMonth containsObject:lastMonth])
        {
            self.strDay = @"30";
        }
        else
        {
            if (([lastYear intValue] % 4  == 0 && [lastYear intValue] % 100 != 0)  || [lastYear intValue] % 400 == 0) {
                self.strDay = @"29";
            }
            else
            {
                self.strDay = @"28";
            }
        }
        
        self.strYear = lastYear;
        self.strMonth = lastMonth;
        
        
        [self httpGetMyAccount];
        
        
//        [self httpGetStatisticAnalysis];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableview.footer endRefreshing];
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
-(void)setupcollectionView
{
    
    self.collonitems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"奖励余额(元)",@"title",@"",@"count", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"累计奖励收益(元)",@"title",@"",@"count", nil], nil];
    [self modifyCollectionView:NO];
    [self.collection registerNib:[UINib nibWithNibName:@"RewardsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.collection.delegate = self;
    self.collection.dataSource=self;
    self.collection.scrollEnabled = NO;
}
-(void) modifyCollectionView:(BOOL) isH{
    //    CGFloat width = SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_HEIGHT:SCREEN_WIDTH;
    //    if(isH ){
    //        width=SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_WIDTH:SCREEN_HEIGHT;
    //    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH-1)/2, isPad?80.f:80.f)];
    [flowLayout setMinimumLineSpacing:0.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [self.collection setCollectionViewLayout:flowLayout];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collonitems.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RewardsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.RewardsAmountLab.text = [[self.collonitems objectAtIndexSafe:indexPath.row] objectForKeySafe:@"count"];
    cell.RewardsAmountLab.textColor = UIColorFromRGB(0xF5A541);
    
    cell.RewardsNameLab.text = [[self.collonitems objectAtIndexSafe:indexPath.row] objectForKeySafe:@"title"];
    
    return cell;
}

-(void)createMyAccountData:(NSArray*)items;
{
    NSMutableArray* tm_array = [[NSMutableArray alloc] init];
//    [tm_array removeAllObjects];
    if ([items count] == 0) {
//        [tm_array removeAllObjects];
        return;
    }
    if ([self.config.Roles isEqualToString:@"PARTNER"]) {
//        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        for (int i = 0; i < items.count; i ++) {
            NSDictionary* dict = items[i];
            if ([[dict objectForKeySafe:@"awardArrive"] intValue] != 0)
            {
                
                NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
                [dictionary setObjectSafe:[dict objectForKeySafe: @"awardArrive"] forKey:@"awardcount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardArriveBank"] forKey:@"awardArriveBank"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardAccount"] forKey:@"awardAccount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"amountDate"] forKey:@"amountDate"];
                [dictionary setObjectSafe:@"0" forKey:@"state"];
                [tm_array addObjectSafe:dictionary];
            }
            if([[dict objectForKeySafe:@"awardPartnerAmount"] intValue] != 0)
            {
                NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardPartnerAmount"] forKey:@"awardcount"];
                [dictionary setObjectSafe:@"" forKey:@"awardArriveBank"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardAccount"] forKey:@"awardAccount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"amountDate"] forKey:@"amountDate"];
                [dictionary setObjectSafe:@"2" forKey:@"state"];
                [tm_array addObjectSafe:dictionary];
            }
        }
    }
    else
    {
        
        for (int i = 0; i < items.count; i ++) {
            NSDictionary* dict = items[i];
            if ([[dict objectForKeySafe:@"awardArrive"] intValue] != 0)
            {
                NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
//                [dictionary removeAllObjects];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardArrive"] forKey:@"awardcount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardArriveBank"] forKey:@"awardArriveBank"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardAccount"] forKey:@"awardAccount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"amountDate"] forKey:@"amountDate"];
                [dictionary setObjectSafe:@"0" forKey:@"state"];
                [tm_array addObjectSafe:dictionary];
            }
            if([[dict objectForKeySafe:@"awardPartnerAmount"] intValue] != 0)
            {
                NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardPartnerAmount"] forKey:@"awardcount"];
                [dictionary setObjectSafe:@"" forKey:@"awardArriveBank"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardAccount"] forKey:@"awardAccount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"amountDate"] forKey:@"amountDate"];
                [dictionary setObjectSafe:@"2" forKey:@"state"];
                [tm_array addObjectSafe:dictionary];
            }
            if ([[dict objectForKeySafe:@"awardSaleAmount"] intValue] != 0)
            {
                NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardSaleAmount"] forKey:@"awardcount"];
                [dictionary setObjectSafe:@"" forKey:@"awardArriveBank"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"awardAccount"] forKey:@"awardAccount"];
                [dictionary setObjectSafe:[dict objectForKeySafe:@"amountDate"] forKey:@"amountDate"];
                [dictionary setObjectSafe:@"1" forKey:@"state"];
                [tm_array addObjectSafe:dictionary];
            }
        }
    }
    
    [tm_array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        
        
        NSString* state1 = [obj1 objectForKeySafe:@"state"];
        NSString* state2 = [obj2 objectForKeySafe:@"state"];
        if ([state1 integerValue] > [state2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([state1 integerValue] < [state2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
   
    
    DLog(@"tm_array = %@",tm_array);
    if (tm_array.count != 0) {
//        self.items = [tm_array copy];
        //self.items = [NSObject sortDictionayrForDate:[tm_array copy] dateKey:@"amountDate"];
        NSArray* tmarr = [NSObject sortDictionayrForDate:[tm_array copy] dateKey:@"amountDate"];
        for (int i = 0; i < tmarr.count; i ++) {
            [self.items addObject:tmarr[i]];
        }
//        [self sortDate:[tm_array copy] sortId:@"amountDate"];
        [self reLoadView];
    }
    else
    {
        [SGInfoAlert showInfo:@"本月无数据,上拉刷新请求上一个月的数据"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    }

}

- (void)reLoadView {
    
    if (self.items != nil && [self.items count] > 0) {
        [self.tableview reloadData];
        [self.tableview setContentOffset:CGPointMake(0,0 ) animated:NO];
    }
}



@end
