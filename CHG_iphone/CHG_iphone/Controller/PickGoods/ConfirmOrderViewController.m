//
//  ConfirmOrderViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmOrderCell.h"
#import "PickGoodsViewController.h"
#import "PresellGoodsViewController.h"
#import "CompletedOrderDetailsViewController.h"
#import "OrderManagementViewController.h"
#import "SuccessRegisterViewController.h"
@interface ConfirmOrderViewController ()
@property UINib* ConfirmOrderNib;
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"订单完成";
    
    if(self.Confirmsaletype == SaleTypeSellingGoods || self.Confirmsaletype == SaleTypePresell)
    {
        self.strfinish = @"订单完成";
    }
    else if(self.Confirmsaletype == SaleTypePickingGoods)
    {
        self.strfinish = @"提货完成";
    }
    else if (self.Confirmsaletype == SaleTypeReturnGoods)
    {
        self.strfinish = @"退货完成";
    }
    else if (self.Confirmsaletype == SaleTypeStopOrder)
    {
        self.strfinish = @"终止订单完成";
    }
    self.title = self.strfinish;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    if (self.returnType == OrderReturnTypeAMember) {
        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccessFulldentify) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (self.returnType == OrderReturnTypePopPage)
    {
        [leftButton addTarget:self action:@selector(gobackRegistePage) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gobackRegistePage
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SuccessRegisterViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.ConfirmOrderNib = [UINib nibWithNibName:@"ConfirmOrderCell" bundle:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfirmOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell"];
    if(cell==nil){
        cell = (ConfirmOrderCell*)[[self.ConfirmOrderNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    
    
    cell.finishLab.text = self.strfinish;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 105;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    titlelab.text = @"您还可以继续操作";
    titlelab.textColor = [UIColor lightGrayColor];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [v_footer addSubview:titlelab];
    
    if (self.Confirmsaletype == SaleTypeSellingGoods
        ||self.Confirmsaletype == SaleTypePickingGoods
        ||self.Confirmsaletype == SaleTypeReturnGoods
        ||self.Confirmsaletype == SaleTypeStopOrder) {
        UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        detailsbtn.tag = 100;
        detailsbtn.frame = CGRectMake(6, 65, CGRectGetWidth(self.view.bounds)-12, 40);
        [detailsbtn.layer setMasksToBounds:YES];
        [detailsbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
        [detailsbtn setBackgroundColor:UIColorFromRGB(0x171c61)];
        
        if (self.Confirmsaletype == SaleTypePickingGoods
            ||self.Confirmsaletype == SaleTypeReturnGoods
            ||self.Confirmsaletype == SaleTypeStopOrder) {
            [detailsbtn setTitle:@"会员订单" forState:UIControlStateNormal];
        }
        else
        {
            [detailsbtn setTitle:@"订单详情" forState:UIControlStateNormal];
        }
        
        [detailsbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detailsbtn addTarget:self action:@selector(detailsbtn:) forControlEvents:UIControlEventTouchUpInside];
        [v_footer addSubview:detailsbtn];

    }
    else if (self.Confirmsaletype == SaleTypePresell)
    {
        UIButton* Pickupbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Pickupbtn.frame = CGRectMake(5, 65, (SCREEN_WIDTH-20)/2, 40);
        Pickupbtn.tag = 101;
        [Pickupbtn.layer setMasksToBounds:YES];
        [Pickupbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
        [Pickupbtn setBackgroundColor:UIColorFromRGB(0x171c61)];
        [Pickupbtn setTitle:@"提货" forState:UIControlStateNormal];
        [Pickupbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [Pickupbtn addTarget:self action:@selector(detailsbtn:) forControlEvents:UIControlEventTouchUpInside];
        [v_footer addSubview:Pickupbtn];
        
        UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        detailsbtn.tag = 100;
        detailsbtn.frame = CGRectMake(SCREEN_WIDTH/2 + 5, 65, (SCREEN_WIDTH-20)/2, 40);
        [detailsbtn.layer setMasksToBounds:YES];
        [detailsbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
        [detailsbtn setBackgroundColor:UIColorFromRGB(0x171c61)];
        [detailsbtn setTitle:@"订单详情" forState:UIControlStateNormal];
        [detailsbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detailsbtn addTarget:self action:@selector(detailsbtn:) forControlEvents:UIControlEventTouchUpInside];
        [v_footer addSubview:detailsbtn];
    }
    
    return v_footer;
}

-(void)detailsbtn:(UIButton*)sender
{
    if (sender.tag == 100) {
        DLog(@"订单详情");
        if (self.Confirmsaletype == SaleTypePresell) {
            DLog(@"未完成订单")
            PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
            PickGoodsView.strOrderId = self.strOrderId;
            PickGoodsView.ManagementTyep = OrderManagementTypeSingle;
            PickGoodsView.skiptype = SkipFromOrderFinish;
            PickGoodsView.m_returnType = self.returnType;
            [self.navigationController pushViewController:PickGoodsView animated:YES];
        }
        else
        {
            if (self.Confirmsaletype == SaleTypePickingGoods
                ||self.Confirmsaletype == SaleTypeReturnGoods
                ||self.Confirmsaletype == SaleTypeStopOrder) {
                OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
                OrderManagementView.title = @"会员订单";
                OrderManagementView.m_returnType = self.returnType;
                OrderManagementView.ManagementTyep = OrderManagementTypeSingle;
                [self.navigationController pushViewController:OrderManagementView animated:YES];
            }
            else
            {
                DLog(@"已完成订单");
                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
                CompletedOrderDetailsView.strOrderId = self.strOrderId;
                CompletedOrderDetailsView.ManagementTyep = OrderManagementTypeSingle;
                CompletedOrderDetailsView.skiptype = SkipFromOrderFinish;
                CompletedOrderDetailsView.Comordertype = detailsOrder;
                CompletedOrderDetailsView.m_returnType = self.returnType;
                [self.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
            }
            
            
        }
    

    }
    else if(sender.tag == 101)
    {
        DLog(@"提货");

        PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
        PresellGoodsView.m_returnType = self.returnType;
        PresellGoodsView.orderSaletype = SaleTypePickingGoods;
        PresellGoodsView.skiptype = SkipFromOrderFinish;
        [self.navigationController pushViewController:PresellGoodsView animated:YES];
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
