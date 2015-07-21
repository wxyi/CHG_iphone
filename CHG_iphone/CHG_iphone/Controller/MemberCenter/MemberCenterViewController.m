//
//  MemberCenterViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MemberCenterViewController.h"

#import "MemberRewardsCell.h"
#import "awardTotalAmountCell.h"
#import "MemberMenuCell.h"
#import "IdentificationViewController.h"
@interface MemberCenterViewController ()
@property UINib* awardTotalAmountNib;
@property UINib* MemberRewardsNib;
@property UINib* MemberMenuNib;
@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
//    self.tableview.scrollEnabled = NO;
    self.tableview.backgroundColor = UIColorFromRGB(0xdddddd);
    [NSObject setExtraCellLineHidden:self.tableview];
    self.awardTotalAmountNib = [UINib nibWithNibName:@"awardTotalAmountCell" bundle:nil];
    self.MemberRewardsNib = [UINib nibWithNibName:@"MemberRewardsCell" bundle:nil];
    self.MemberMenuNib = [UINib nibWithNibName:@"MemberMenuCell" bundle:nil];

//    self.items = [[NSMutableArray alloc] init];
    [self setupRefresh];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        MemberRewardsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MemberRewardsCell"];
        if(cell==nil){
            cell = (MemberRewardsCell*)[[self.MemberRewardsNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        NSMutableArray* item = [[NSMutableArray alloc] init];
        [item addObjectSafe:[NSDictionary dictionaryWithObjectsAndKeys:@"本月新增会员",@"title",[NSString stringWithFormat:@"%d",[[self.items objectForKeySafe:@"newCustMonth"] intValue]],@"count", nil]];
         [item addObjectSafe:[NSDictionary dictionaryWithObjectsAndKeys:@"本月新增会员消费(元)",@"title",[NSString stringWithFormat:@"%.2f",[[self.items objectForKeySafe:@"newCustMonthMoney"] doubleValue]],@"count", nil]];
         
        
        
        [cell setupView:item];
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            
            
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.row == 1)
    {
        awardTotalAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"awardTotalAmountCell"];
        if(cell==nil){
            cell = (awardTotalAmountCell*)[[self.awardTotalAmountNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        cell.contentView.backgroundColor = UIColorFromRGB(0xF5A541);
        cell.nameLab.text = @"本月会员总消费(元)";
        cell.nameLab.textColor = UIColorFromRGB(0xf0f0f0);
        cell.amountLab.text =[NSString stringWithFormat:@"%.2f",[[self.items objectForKeySafe:@"custMonthMoneyAll"] doubleValue]];
        cell.amountLab.font = FONT(40);
        cell.amountLab.textColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MemberMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MemberMenuCell"];
        if(cell==nil){
            cell = (MemberMenuCell*)[[self.MemberMenuNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        
        NSArray* items = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"member_management.png",@"icon",@"会员管理",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],nil];
        cell.height = 72;
        [cell setupView:[items mutableCopy]];
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf skipPage:0];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 85;
    }
    else if (indexPath.row == 1) {
        return 96;
    }
    else
    {
        return 71;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
-(void)skipPage:(NSInteger)tag
{
    DLog(@"会员识别");
    IdentificationViewController* IdentificationView= [[IdentificationViewController alloc] initWithNibName:@"IdentificationViewController" bundle:nil];
    IdentificationView.m_MenuType = MenuTypeMemberCenter;
    
    [self.navigationController pushViewController:IdentificationView animated:YES];
}
-(void)httpGetCustCenter
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetCustCenter] parameters:parameter];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:parameter successBlock:^(BOOL success, id data, NSString *msg) {
        if (success) {
            self.items = data;
            [self.tableview reloadData];
//            [self.tableview.header endRefreshing];
        }
        else
        {
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
//            [self.tableview.header endRefreshing];
        }
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetCustCenter];
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
    [header beginRefreshing];
    
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
        [self httpGetCustCenter];

        
        [self.tableview.header endRefreshing];
    });
}
@end
