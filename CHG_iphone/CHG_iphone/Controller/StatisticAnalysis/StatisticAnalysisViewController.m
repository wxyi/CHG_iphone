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
    
    [self getCurrentData];
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    if ([config.Roles isEqualToString:@"SHOP_OWNER"]){
        self.items = [NSArray arrayWithObjects:@"会员消费",@"会员增长",@"动销奖励",@"消费分账奖励", nil];
    }
    else if ([config.Roles isEqualToString:@"SHOPLEADER"])
    {
        self.items = [NSArray arrayWithObjects:@"会员消费",@"会员增长", nil];
    }
    else if ([config.Roles isEqualToString:@"PARTNER"])
    {
        self.items = [NSArray arrayWithObjects:@"会员增长",@"消费分账奖励", nil];
    }
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
//    self.tableview.showsVerticalScrollIndicator = NO;
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
    title.text = [self.items objectAtIndexSafe:indexPath.row];
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
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
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
    
    if ([config.Roles isEqualToString:@"PARTNER"])
    {
        if (indexPath.row == 0) {
            type = StatisticalTypeMembershipGrowth;
        }
        else
        {
            type = StatisticalTypePartnersRewards;
        }
        
    }
    StoreSalesViewController* StoreSalesView = [[StoreSalesViewController alloc] initWithNibName:@"StoreSalesViewController" bundle:nil];
    StoreSalesView.statisticalType = type;
    StoreSalesView.isSkip = NO;
    StoreSalesView.strYear = self.strYear;
    StoreSalesView.strMonth = self.strMonth;
    StoreSalesView.strDay = self.strDay;
    StoreSalesView.title = [self.items objectAtIndexSafe:indexPath.row];
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
-(void)getCurrentData
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    
    self.strYear = [NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
    self.strMonth = [NSString stringWithFormat:@"%ld",(long)[dateComponent month]];
    self.strDay = [NSString stringWithFormat:@"%ld",(long)[dateComponent day]];
    
    
}
@end
