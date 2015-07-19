//
//  SuccessRegisterViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SuccessRegisterViewController.h"
#import "SuccessRegistereCell.h"
#import "registeredMenuCell.h"
#import "PresellGoodsViewController.h"
@interface SuccessRegisterViewController ()
@property UINib* SuccessRegistereNib;
@property UINib* registeredMenuNib;
@end

@implementation SuccessRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员信息";
    
//    JTImageButton *leftbtn = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
//    [leftbtn createTitle:@"返回" withIcon:[UIImage imageNamed:@"btn_back.png"] font:[UIFont systemFontOfSize:17] iconHeight:JTImageButtonIconHeightDefault iconOffsetY:1.0];
//    leftbtn.titleColor = [UIColor whiteColor];
//    
//    leftbtn.iconColor = [UIColor whiteColor];
//    leftbtn.padding = JTImageButtonPaddingSmall;
//    leftbtn.borderColor = [UIColor clearColor];
//    leftbtn.iconSide = JTImageButtonIconSideLeft;
//    [leftbtn addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
////    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [NSObject setExtraCellLineHidden:self.tableview];
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.SuccessRegistereNib = [UINib nibWithNibName:@"SuccessRegistereCell" bundle:nil];
    self.registeredMenuNib
    = [UINib nibWithNibName:@"registeredMenuCell" bundle:nil];
    
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
        SuccessRegistereCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SuccessRegistereCell"];
        if(cell==nil){
            cell = (SuccessRegistereCell*)[[self.SuccessRegistereNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        registeredMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"registeredMenuCell"];
        if(cell==nil){
            cell = (registeredMenuCell*)[[self.registeredMenuNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        NSArray* items = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"selling_goods.png",@"icon",@"卖货",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"presell.png",@"icon",@"预售",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],
                          nil];
        [cell setupView:[items mutableCopy]];
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf didSelectMenuCell:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  110;
    }
    else
    {
        return SCREEN_WIDTH/2 * 0.66;
    }
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section ==1) {
//        return @"您还可以继续";
//    }
//    return @"";
//}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        v_header.backgroundColor = [UIColor clearColor];
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
        title.text = @"您还可以继续";
        title.font = FONT(13);
        title.textColor = [UIColor lightGrayColor];
        [v_header addSubview:title];
        return v_header;
    }
    return nil;
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
            
            PresellGoodsView.m_returnType = OrderReturnTypeHomePage;
            [self.navigationController pushViewController:PresellGoodsView animated:YES];
            break;
        }
        
            
        default:
            break;
    }
}
@end
