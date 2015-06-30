//
//  successfulIdentifyViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "successfulIdentifyViewController.h"
#import "successfulIdentifyCell.h"
#import "MenuCell.h"
#import "IdentificationViewController.h"
#import "OrderManagementViewController.h"
#import "PresellGoodsViewController.h"
@interface successfulIdentifyViewController ()
@property UINib* successfulIdentifyNib;
@property UINib* MenuNib;
@end

@implementation successfulIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员信息";
    
    JTImageButton *leftbtn = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [leftbtn createTitle:@"返回" withIcon:[UIImage imageNamed:@"btn_back.png"] font:[UIFont systemFontOfSize:17] iconHeight:JTImageButtonIconHeightDefault iconOffsetY:1.0];
    leftbtn.titleColor = [UIColor whiteColor];
    
    leftbtn.iconColor = [UIColor whiteColor];
    leftbtn.padding = JTImageButtonPaddingSmall;
    leftbtn.borderColor = [UIColor clearColor];
    leftbtn.iconSide = JTImageButtonIconSideLeft;
    [leftbtn addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
//    self.view.backgroundColor = UIColorFromRGB(0xdddddd);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = UIColorFromRGB(0xdddddd);
    self.successfulIdentifyNib = [UINib nibWithNibName:@"successfulIdentifyCell" bundle:nil];
    self.MenuNib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        successfulIdentifyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"successfulIdentifyCell"];
        if(cell==nil){
            cell = (successfulIdentifyCell*)[[self.successfulIdentifyNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.iphoneLab.text = self.m_CustDict[@"custMobile"];
        cell.nameLab.text = self.m_CustDict[@"custName"];
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
                          [NSDictionary dictionaryWithObjectsAndKeys:@"selling_goods.png",@"icon",@"卖货",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"presell.png",@"icon",@"预售",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"btn_Member_order.png",@"icon",@"订单管理",@"title", nil],
                          nil];
        cell.height = 105;
        [cell setupView:[items mutableCopy]];
        
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf didSelectMenuCell:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return SCREEN_HEIGHT - 290;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else
    {
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  150;
    }
    else
    {
        return 106;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return @"您还可以继续";
    }
    return @"";
}
-(void)didSelectMenuCell:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
        case 1:
        {
            DLog(@"预售");
            
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            
            if (indexPath.row == 0) {
                PresellGoodsView.orderSaletype = SaleTypeSellingGoods;
            }
            else if(indexPath.row == 1)
            {
                PresellGoodsView.orderSaletype = SaleTypePresell;
            }
            [self.navigationController pushViewController:PresellGoodsView animated:YES];
            break;
        }
        case 2:
        {
            OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
            
            OrderManagementView.ManagementTyep = OrderManagementTypeSingle;
            [self.navigationController pushViewController:OrderManagementView animated:YES];
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
