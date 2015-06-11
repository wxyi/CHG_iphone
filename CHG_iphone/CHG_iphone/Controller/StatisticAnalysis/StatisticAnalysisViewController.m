//
//  StatisticAnalysisViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StatisticAnalysisViewController.h"
#import "StoreSalesViewController.h"
@interface StatisticAnalysisViewController ()

@end

@implementation StatisticAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"统计分析";
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    self.items = [NSArray arrayWithObjects:@"门店销售",@"会员增长",@"动销奖励",@"合作商消费分账奖励", nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    title.textColor = UIColorFromRGB(0x323232);
    title.font = FONT(15);
    title.text = [self.items objectAtIndex:indexPath.row];
    [cell.contentView addSubview:title];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticalType type ;
    
    switch (indexPath.row) {
        case 0:
            type = StatisticalTypeStoreSales;
            break;
        case 1:
            type = StatisticalTypeMembershipGrowth;
            break;
        case 2:
            type = StatisticalTypePinRewards;
            break;
        case 3:
            type = StatisticalTypePartnersRewards;
            break;
        default:
            break;
    }
    
    StoreSalesViewController* StoreSalesView = [[StoreSalesViewController alloc] initWithNibName:@"StoreSalesViewController" bundle:nil];
    StoreSalesView.statisticalType = type;
    [self.navigationController pushViewController:StoreSalesView animated:YES];

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
