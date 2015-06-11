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
#import "GrowthCell.h"
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
    
    
    [self PageInfo];
    self.title = @"日";
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.StatisticAnalysisTopNib = [UINib nibWithNibName:@"StatisticAnalysisTopCell" bundle:nil];
    self.StoresInfoNib = [UINib nibWithNibName:self.strNibName bundle:nil];
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
    DLog(@"self.items.count = %d",self.items.count);
    return self.items.count + 1;
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
        cell.pricelab.text = [NSString stringWithFormat:@"%d",self.custCount];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {

        switch (self.statisticalType) {
            case StatisticalTypeStoreSales:
            {
                StoresInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
                if(cell==nil){
                    cell = (StoresInfoCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                    
                }
                NSDictionary* dictionary = [self.items objectAtIndex:indexPath.section - 1];
                DLog(@"%@",dictionary);
                cell.datelab.text = dictionary[@"orderDate"];
                cell.statelab.text = [NSString stringWithFormat:@"订单编号:%d",[dictionary[@"orderCode"] intValue]];
                cell.namelab.text = [NSString stringWithFormat:@"%d",[dictionary[@"custName"] intValue]];
                cell.producerlab.text = [NSString stringWithFormat:@"订单制作:%d",[dictionary[@"orderCreater"] intValue]];
                cell.pricelab.text = [NSString stringWithFormat:@"￥%d",[dictionary[@"orderAmount"] intValue]];
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
                cell.datelab.text = @"2015年05月19日 10:10:10";
                cell.statelab.text = @"门店APP";
                
                cell.namelab.text = @"王俊";
                cell.iphonelab.text = @"13382050875";
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
                cell.datelab.text = @"2015年05月19日 10:10:10";;
                cell.statelab.text = @"订单编号:952712345";
                cell.pricelab.text = @"$100";
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
                cell.datelab.text = @"2015年05月19日 10:10:10";
                cell.statelab.text = @"订单编号:952712345";
                cell.namelab.text = @"王俊";
                cell.pricelab.text = @"$100";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                break;
            }
            default:
                break;
        }

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return self.width;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
    
}

-(void)goskipdetails
{
    
    if (self.didSkipSubItem) {
        self.didSkipSubItem(101);
    }
    
}
-(void)PageInfo
{
    NSString* strUrl;
   
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"2015" forKey:@"year"];
    [parameter setObject:@"5" forKey:@"month"];
    [parameter setObject:@"18" forKey:@"day"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"今日销售额(元)";
            self.width = 120;
            self.strNibName = @"StoresInfoCell";
            
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetShopSellStatOfDay] parameters:parameter];
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strtitle = @"今日新增会员(人)";
            self.width = 75;
            self.strNibName = @"MembegrowthCell";
            
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetMyNewCustCountStatOfDay] parameters:parameter];
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strtitle = @"今日动销奖励(元)";
            self.width = 100;
            self.strNibName = @"pinCell";
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardSalerStatOfDay] parameters:parameter];
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strtitle = @"今日合作商消费账奖励(元)";
            self.width = 120;
            self.strNibName = @"PartnersCell";
            strUrl = [NSObject URLWithBaseString:[APIAddress ApiGetAwardPartnerStatOfDay] parameters:parameter];
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
        self.custCount = [data[@"custCount"] intValue];
        self.items = [data objectForKey:@"custList"];
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
