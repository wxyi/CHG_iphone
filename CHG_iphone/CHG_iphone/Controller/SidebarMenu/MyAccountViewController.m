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
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    [self httpGetMyAccount];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.RewardsNib = [UINib nibWithNibName:@"RewardsCell" bundle:nil];
    self.SettlementNib = [UINib nibWithNibName:@"SettlementCell" bundle:nil];
    self.GrowthNib = [UINib nibWithNibName:@"GrowthCell" bundle:nil];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
                         [NSDictionary dictionaryWithObjectsAndKeys:@"可用奖励(元)",@"title",[NSString stringWithFormat:@"%d",[self.dictionary[@"awardUsing"] intValue]],@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"累计奖励收益(元)",@"title",[NSString stringWithFormat:@"%d",[self.dictionary[@"awardTotal"] intValue]],@"count", nil], nil];
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
        
        
        cell.datelab.text = self.dictionary[@"awardArriveDate"];
        cell.statelab.text = @"支出";
        cell.namelab.text = @"晨冠以结算";
        cell.pricelab.text = [NSString stringWithFormat:@"%.0f",[self.dictionary[@"awardArrive"] doubleValue]];
        cell.BankCardlab.text = self.dictionary[@"awardArriveBank"];
        cell.CardNumlab.text = [NSString stringWithFormat:@"%d",[self.dictionary[@"awardAccount"] intValue]];

        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        GrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrowthCell"];
        if(cell==nil){
            cell = (GrowthCell*)[[self.GrowthNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        if (indexPath.section == 2) {
            cell.datelab.text = self.dictionary[@"awardSaleAmountDate"];;
            cell.statelab.text = @"收入";
            cell.namelab.text = @"动销奖励";
            cell.iphonelab.text = [NSString stringWithFormat:@"%.0f",[self.dictionary[@"awardSaleAmount"] doubleValue]];
            cell.skipbtn.tag = 101;
        }
        else
        {
            cell.datelab.text = self.dictionary[@"awardPartnerAmountDate"];;
            cell.statelab.text = @"收入";
            cell.namelab.text = @"销费分账奖励";
            cell.iphonelab.text = [NSString stringWithFormat:@"%.0f",[self.dictionary[@"awardPartnerAmount"] doubleValue]];
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
    if (tag == 101) {
        statType = StatisticalTypePinRewards;
    }
    else
    {
        statType = StatisticalTypePartnersRewards;
    }
    
    StoreSalesViewController* StoreSalesView = [[StoreSalesViewController alloc] initWithNibName:@"StoreSalesViewController" bundle:nil];
    StoreSalesView.statisticalType = statType;
    [self.navigationController pushViewController:StoreSalesView animated:YES];
    
}

-(void)httpGetMyAccount
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
  
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetMyAccount] parameters:parameter];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
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
        }
        else
        {
            [MMProgressHUD dismissWithError:msg];
//            [SGInfoAlert showInfo:msg
//                          bgColor:[[UIColor darkGrayColor] CGColor]
//                           inView:self.view
//                         vertical:0.7];
        }
        
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
