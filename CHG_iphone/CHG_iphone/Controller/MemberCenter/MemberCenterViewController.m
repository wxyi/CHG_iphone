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
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)setupView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
    self.tableview.backgroundColor = UIColorFromRGB(0xdddddd);
    [NSObject setExtraCellLineHidden:self.tableview];
    self.awardTotalAmountNib = [UINib nibWithNibName:@"awardTotalAmountCell" bundle:nil];
    self.MemberRewardsNib = [UINib nibWithNibName:@"MemberRewardsCell" bundle:nil];
    self.MemberMenuNib = [UINib nibWithNibName:@"MemberMenuCell" bundle:nil];

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
            cell = (MemberRewardsCell*)[[self.MemberRewardsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        NSArray* itme = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"本月新增会员",@"title",@"18",@"count", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"本月新增会员消费(元)",@"title",@"1354.80",@"count", nil], nil];
        
        [cell setupView:itme];
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
            cell = (awardTotalAmountCell*)[[self.awardTotalAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.contentView.backgroundColor = UIColorFromRGB(0x171c61);
        cell.nameLab.text = @"本月会员总消费(元)";
        cell.nameLab.textColor = UIColorFromRGB(0xf0f0f0);
        cell.amountLab.text = @"5795.53";
        cell.amountLab.font = FONT(40);
        cell.amountLab.textColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MemberMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MemberMenuCell"];
        if(cell==nil){
            cell = (MemberMenuCell*)[[self.MemberMenuNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        NSArray* items = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"member_management.png",@"icon",@"会员管理",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],nil];
        cell.height = 106;
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
        return 72;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
