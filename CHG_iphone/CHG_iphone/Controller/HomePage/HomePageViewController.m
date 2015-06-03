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
#import "SellingGoodsViewController.h"
#import "StoreManagementViewController.h"
#import "PresellGoodsViewController.h"
#import "StatisticAnalysisViewController.h"
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
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x171c61);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_btn.png"] style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(showMenu)];
    
    [self setupView];
}

-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.PromoListNib = [UINib nibWithNibName:@"PromoListCell" bundle:nil];
    self.AccountBriefNib = [UINib nibWithNibName:@"AccountBriefCell" bundle:nil];
    self.awardTotalAmountNib = [UINib nibWithNibName:@"awardTotalAmountCell" bundle:nil];
    self.RewardsNib = [UINib nibWithNibName:@"RewardsCell" bundle:nil];
    
    self.MenuNib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    
    
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
            CGRect rect= CGRectMake(0, -10, SCREEN_WIDTH, 120);
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
                         [NSDictionary dictionaryWithObjectsAndKeys:@"会员总数",@"title",@"36 ",@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"本月新增会员",@"title",@"36 ",@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"本日新增会员",@"title",@"36 ",@"count", nil], nil];
        [cell setupView:itme];
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
        cell.nameLab.text = @"奖励总额";
        cell.amountLab.text = @"5795.53";
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
                         [NSDictionary dictionaryWithObjectsAndKeys:@"动销奖励(元)",@"title",@"4128.60",@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"合作商分账奖励(元)",@"title",@"36",@"count", nil], nil];
        cell.RewardsView.backgroundColor = UIColorFromRGB(0x878787);
        [cell setupView:itme];
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

        NSArray* items = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:@"member_center.png",@"icon",@"会员中心",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"member_registration.png",@"icon",@"会员注册",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"presell.png",@"icon",@"预售",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"selling_goods.png",@"icon",@"卖货",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"order_management.png",@"icon",@"订单管理",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"statistical_analysis.png",@"icon",@"统计分析",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"store_management.png",@"icon",@"门店管理",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],nil];
        [cell setupView:items];
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
        return 120;
    }
    else if(indexPath.row == 1)
        return 50;
    else if(indexPath.row == 2)
        return 100;
    else if (indexPath.row == 3)
        return 75;
    else
        return SCREEN_WIDTH;
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
        {
            DLog(@"预售");
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            [self.navigationController pushViewController:PresellGoodsView animated:YES];
            break;
        }
        case 3:
        {
            DLog(@"卖货");
            
            SellingGoodsViewController* SellingGoodsView = [[SellingGoodsViewController alloc] initWithNibName:@"SellingGoodsViewController" bundle:nil];
            [self.navigationController pushViewController:SellingGoodsView animated:YES];
            break;
        }
        case 4:
        {
            DLog(@"订单管理");
            
            OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
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
            
            StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
            [self.navigationController pushViewController:StoreManagementView animated:YES];
            break;
        }
        default:
            break;
    }
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
