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
@interface MyAccountViewController ()
@property UINib* RewardsNib;
@property UINib* SettlementNib;
@property UINib* GrowthNib;
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
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
                         [NSDictionary dictionaryWithObjectsAndKeys:@"动销奖励(元)",@"title",@"4128.60",@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"合作商分账奖励(元)",@"title",@"36",@"count", nil], nil];
        
        [cell setupView:itme];
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
        
        cell.namelab.text = @"晨冠以结算";
        cell.pricelab.text = @"￥200";
        cell.BankCardlab.text = @"工商银行";
        cell.CardNumlab.text = @"6210*******79263";
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        GrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrowthCell"];
        if(cell==nil){
            cell = (GrowthCell*)[[self.GrowthNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.namelab.text = @"动销奖励";
        cell.iphonelab.text = @"￥200";
        cell.iphonelab.textColor = [UIColor orangeColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 35;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    else if(section == 1)
    {
        return 1;
    }
    else
        return 36;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 75;
    }
    else if(indexPath.section == 1)
    {
        return 60;
    }
    else
        return 40;
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
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = [UIColor lightGrayColor];
    datelab.text = @"2015-05-19 10:10:10";
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = [UIColor lightGrayColor];
    orderstatus.text = @"支出";
    [v_header addSubview:orderstatus];
    
    return v_header;

}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        v_footer.backgroundColor = [UIColor lightGrayColor];
        UILabel* detaillab = [[UILabel alloc] initWithFrame:v_footer.frame];
        detaillab.textAlignment = NSTextAlignmentCenter;
        detaillab.textColor = [UIColor grayColor];
        detaillab.text = @"账户明细";
        detaillab.font = FONT(14);
        [v_footer addSubview:detaillab];
        return v_footer;
    }
    else if(section == 2||section == 3)
    {
        UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        v_footer.backgroundColor = [UIColor whiteColor];
        UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailsbtn.layer setMasksToBounds:YES];
        [detailsbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [detailsbtn.layer setBorderWidth:1.0]; //边框
        detailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 3, 80, 29);
        [detailsbtn setTitle:@"详情" forState:UIControlStateNormal];
        [detailsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [detailsbtn addTarget:self action:@selector(goskipdetails) forControlEvents:UIControlEventTouchUpInside];
        [v_footer addSubview:detailsbtn];
        return v_footer;
    }
    return nil;
}
-(void)goskipdetails
{
    
    DLog(@"详情");
    
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
