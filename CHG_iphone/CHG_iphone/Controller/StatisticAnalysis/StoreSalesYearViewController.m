//
//  StoreSalesYearViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreSalesYearViewController.h"
#import "StatisticAnalysisTopCell.h"
#import "StatisticsCell.h"
@interface StoreSalesYearViewController ()
@property UINib* StatisticAnalysisTopNib;
@property UINib* StatisticsNib;
@end

@implementation StoreSalesYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"年";
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count]+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StatisticAnalysisTopCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StatisticAnalysisTopCell"];
        if(cell==nil){
            cell = (StatisticAnalysisTopCell*)[[self.StatisticAnalysisTopNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.nameLab.text = self.strtitle;
        cell.pricelab.text =  [NSString stringWithFormat:@"%d",self.custCount];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        StatisticsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StatisticsCell"];
        if(cell==nil){
            cell = (StatisticsCell*)[[self.StatisticsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        NSDictionary* dictionary = [self.items objectAtIndex:indexPath.section - 1];
        [cell setStatistics:dictionary[@"day"] number:[dictionary[@"sellAmount"] intValue]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedSubItemAction) {
        self.didSelectedSubItemAction(indexPath);
    }
    
}
-(void)PageInfo
{
    NSString* strUrl;
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"2015" forKey:@"year"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"本年销售额(元)";
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetShopSellStatOfYear] parameters:parameter];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strtitle = @"本年新增会员(人)";
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetMyNewCustCountStatOfYear] parameters:parameter];
            
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strtitle = @"本年动销奖励(元)";
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardSalerStatOfYear] parameters:parameter];
            
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strtitle = @"本年合作商消费账奖励(元)";
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardPartnerStatOfMonth] parameters:parameter];
            
            break;
        }
        default:
            break;
    }
    [self httpGetStatisticAnalysis:strUrl];
}
-(void)httpGetStatisticAnalysis:(NSString*)strurl
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:strurl parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        [MMProgressHUD dismiss];
        DLog(@"data = %@",data);
        self.custCount = [data[@"sellCount"] intValue];
        self.items = [data objectForKey:@"sellList"];
        [self.tableview reloadData];
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD dismissWithError:description];
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

@end
