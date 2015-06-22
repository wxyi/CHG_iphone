//
//  HomePageViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/21.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "HomePageViewController.h"
#import "CHGNavigationController.h"

#import "PromoListCell.h"
#import "AccountBriefCell.h"
#import "awardTotalAmountCell.h"
#import "RewardsCell.h"
#import "MenuCell.h"

#import "MemberCenterViewController.h"
#import "RegisteredMembersViewController.h"
#import "OrderManagementViewController.h"
#import "StoreManagementViewController.h"
#import "PresellGoodsViewController.h"
#import "StatisticAnalysisViewController.h"
#import "StopViewController.h"
#import "IdentificationViewController.h"
@interface HomePageViewController ()
@property UINib* PromoListNib;
@property UINib* AccountBriefNib;
@property UINib* awardTotalAmountNib;
@property UINib* RewardsNib;
@property UINib* MenuNib;
@property PromoListCell *listcell;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x171c61);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgnav.png"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.layer.contents = (id)[NSObject createImageWithColor:UIColorFromRGB(0x171c61)].CGImage;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_btn.png"] style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(showMenu)];
    
    [self setupView];
}

-(void)setupView
{
    
    self.menuArr = [[NSMutableArray alloc] init];
    self.menuArr = [self GetMenuArr];
    
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.PromoListNib = [UINib nibWithNibName:@"PromoListCell" bundle:nil];
    self.AccountBriefNib = [UINib nibWithNibName:@"AccountBriefCell" bundle:nil];
    self.awardTotalAmountNib = [UINib nibWithNibName:@"awardTotalAmountCell" bundle:nil];
    self.RewardsNib = [UINib nibWithNibName:@"RewardsCell" bundle:nil];
    
    self.MenuNib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    
    [self setupRefresh];
    
    self.pagearray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 1 ; i <= 5; i++) {
        [self.pagearray addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"image%d",i] ofType:@"jpg"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {

        if (self.listcell == nil) {
            CGRect rect= CGRectMake(0, -10, SCREEN_WIDTH, 128);
            self.listcell=[[PromoListCell  alloc]initWithFrame:rect homeNews:self.pagearray];
        }
        
        //测试
       
        
        
        [self.listcell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return self.listcell;
    }
    else if (indexPath.row == 1)
    {
        AccountBriefCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AccountBriefCell"];
        if(cell==nil){
            cell = (AccountBriefCell*)[[self.AccountBriefNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        
        
        NSArray* itme = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"会员总数",@"title",[NSString stringWithFormat:@"%d",[[self.AccountBriefDict objectForKey:@"custTotalCount"] intValue]],@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"本月新增会员",@"title",[NSString stringWithFormat:@"%d",[[self.AccountBriefDict objectForKey:@"custMonthCount"] intValue]],@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"本日新增会员",@"title",[NSString stringWithFormat:@"%d",[[self.AccountBriefDict objectForKey:@"custDayCount"] intValue]],@"count", nil], nil];
        
        [cell setupView:[itme mutableCopy]];
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            
              DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf didSelectAccountBriefCell:indexPath];
        };
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.row == 2)
    {
        awardTotalAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"awardTotalAmountCell"];
        if(cell==nil){
            cell = (awardTotalAmountCell*)[[self.awardTotalAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
//        cell.backgroundColor = UIColorFromRGB(0x646464);
        cell.nameLab.text = @"奖励总额(元)";
        cell.amountLab.text = [NSString stringWithFormat:@"%d",[self.AccountBriefDict[@"awardTotalAmount"] intValue]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.row == 3)
    {
        RewardsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RewardsCell"];
        if(cell==nil){
            cell = (RewardsCell*)[[self.RewardsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }

        NSArray* itme = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"动销奖励(元)",@"title",[NSString stringWithFormat:@"%d",[self.AccountBriefDict[@"awardSaleAmount"] intValue]],@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"合作商分账奖励(元)",@"title",[NSString stringWithFormat:@"%d",[self.AccountBriefDict[@"awardPartnerAmount"] intValue]],@"count", nil], nil];

        [cell setupView:[itme mutableCopy]];
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf didSelectRewardsCell:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        if(cell==nil){
            cell = (MenuCell*)[[self.MenuNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }


        
        cell.height = self.menuArr.count/3 * 105;
        [cell setupView:self.menuArr];
        
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf didSelectMenuCell:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 128;
    }
    else if(indexPath.row == 1)
        return 48;
    else if(indexPath.row == 2)
        return 100;
    else if (indexPath.row == 3)
        return 75;
    else
        return self.menuArr.count/3 * 105;
}

-(void)didSelectAccountBriefCell:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DLog(@"会员总数");
            break;
        }
        case 1:
        {
            DLog(@"本月新增数");
            break;
        }
        case 2:
        {
            DLog(@"本日新增数");
            break;
        }
        default:
            break;
    }
}
-(void)didSelectRewardsCell:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DLog(@"卖货奖励");
            break;
        }
        case 1:
        {
            DLog(@"合作商分账");
            break;
        }
        default:
            break;
    }
}
-(void)didSelectMenuCell:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DLog(@"会员中心");
            MemberCenterViewController* MemberCenterView = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
            [self.navigationController pushViewController:MemberCenterView animated:YES];
            break;
        }
        case 1:
        {
            DLog(@"会员注册");
            
            RegisteredMembersViewController* RegisteredMembersView = [[RegisteredMembersViewController alloc] initWithNibName:@"RegisteredMembersViewController" bundle:nil];
            [self.navigationController pushViewController:RegisteredMembersView animated:YES];
            break;
        }
        case 2:
        case 3:
        {
            DLog(@"订单管理");
            
            IdentificationViewController* IdentificationView= [[IdentificationViewController alloc] initWithNibName:@"IdentificationViewController" bundle:nil];
            if (indexPath.row == 2) {
                IdentificationView.m_MenuType = MenuTypePresell;
            }
            else if(indexPath.row == 3)
            {
                IdentificationView.m_MenuType = MenuTypeSellingGoods;
            }
            else
            {
                IdentificationView.m_MenuType = MenuTypeOrderManagement;
            }
            [self.navigationController pushViewController:IdentificationView animated:YES];
            
            break;
            
        }
        case 4:
        {

            OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
//            OrderManagementView.strCustId =@"" ;
            OrderManagementView.ManagementTyep = OrderManagementTypeAll;
            [self.navigationController pushViewController:OrderManagementView animated:YES];
            
            break;
        }
        case 5:
        {
            DLog(@"统计分析");
            
            StatisticAnalysisViewController* StatisticAnalysisView = [[StatisticAnalysisViewController alloc] initWithNibName:@"StatisticAnalysisViewController" bundle:nil];
            [self.navigationController pushViewController:StatisticAnalysisView animated:YES];
            break;
        }
        case 6:
        {
            DLog(@"门店管理");
            
            StopViewController* StopView = [[StopViewController alloc] initWithNibName:@"StopViewController" bundle:nil];
            [self.navigationController pushViewController:StopView animated:YES];
            break;
        }
        default:
            break;
    }
}

-(void)httpGetPromoList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    UserConfig *cfg = [[SUHelper sharedInstance] currentUserConfig];
//    [NSString stringWithFormat:@"%d"]
    [parameter setObject:@"1"forKey:@"type"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetPromoList] parameters:parameter];
    
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        if (success) {
//            [MMProgressHUD dismiss];
            self.pagearray = data;
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        [self httpGetAccountBrief];
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
    
}
-(void)httpGetAccountBrief
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetAccountBrief] parameters:parameter];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        self.AccountBriefDict = data;

        if (success) {
//            [MMProgressHUD dismiss];
            for (int i = 1; i < 4; i ++ ) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
            

            DLog(@"self.AccountBriefDict = %@",self.AccountBriefDict);
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

-(NSMutableArray*) GetMenuArr
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sysmenu" ofType:@"plist"];
    NSMutableArray *menuArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    UserConfig* cfg = [[SUHelper sharedInstance] currentUserConfig];
    
    if ([cfg.Roles isEqualToString:@"SHOP_OWNER"]) {
        [menuArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"store_management.png",@"icon",@"门店管理",@"title", nil]];
    }
    
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil];
    if (menuArr.count%3 == 1) {
        [menuArr addObject:dict];
        [menuArr addObject:dict];
    }
    else if(menuArr.count%3 == 2)
    {
        [menuArr addObject:dict];
    }
    
    return menuArr;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self httpGetPromoList];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
    });
}
@end
