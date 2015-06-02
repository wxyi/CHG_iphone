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
    return 5;
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
        cell.pricelab.text = @"900";
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
                cell.namelab.text = @"王俊";
                cell.producerlab.text = @"王俊";
                cell.pricelab.text =@"$135";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                break;
            }
            case StatisticalTypeMembershipGrowth:
            {
                GrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:self.strNibName];
                if(cell==nil){
                    cell = (GrowthCell*)[[self.StoresInfoNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                    
                }
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
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    v_footer.backgroundColor = [UIColor whiteColor];
    
    
    UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailsbtn.layer setMasksToBounds:YES];
    [detailsbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [detailsbtn.layer setBorderWidth:1.0]; //边框
    detailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 30);
    [detailsbtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailsbtn addTarget:self action:@selector(goskipdetails) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:detailsbtn];
    
    return v_footer;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    v_header.backgroundColor = [UIColor whiteColor];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_header addSubview:line];
    
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 25)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = [UIColor lightGrayColor];
    datelab.text = @"2015-05-19 10:10:10";
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 25)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = [UIColor lightGrayColor];
    orderstatus.text = @"订单编号:952712345";
    [v_header addSubview:orderstatus];
    
    
    return v_header;
}
-(void)goskipdetails
{
    
    if (self.didSkipSubItem) {
        self.didSkipSubItem(101);
    }
    
}
-(void)PageInfo
{
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
        {
            self.strtitle = @"今日销售额(元)";
            self.width = 60;
            self.strNibName = @"StoresInfoCell";
            break;
        }
        case StatisticalTypeMembershipGrowth:
        {
            self.strtitle = @"今日新增会员(人)";
            self.width = 40;
            self.strNibName = @"GrowthCell";
            break;
        }
        case StatisticalTypePinRewards:
        {
            self.strtitle = @"今日动销奖励(元)";
            self.width = 40;
            self.strNibName = @"pinCell";
            break;
        }
        case StatisticalTypePartnersRewards:
        {
            self.strtitle = @"今日合作商消费账奖励(元)";
            self.width = 60;
            self.strNibName = @"PartnersCell";
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
