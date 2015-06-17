//
//  OrderManagementViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderManagementViewController.h"
#import "PickGoodsViewController.h"
#import "PresellGoodsViewController.h"
#import "GoodsDetailsViewController.h"
#import "DidPickGoodsViewController.h"
#import "CompletedOrderDetailsViewController.h"
@interface OrderManagementViewController ()

@end

@implementation OrderManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    btn_serch_hl@2x.png
//    btn_serch@2x.png
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(skipPage)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_serch.png"] style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(skipPage)];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
}
-(void)skipPage
{
    DLog(@"搜索");
//    OrderQueryViewController* OrderQueryView = [[OrderQueryViewController alloc] initWithNibName:@"OrderQueryViewController" bundle:nil];
//    [self.navigationController pushViewController:OrderQueryView animated:YES];
}
-(void)setupView
{
    if (self.ManagementTyep == OrderManagementTypeAll) {
        [ConfigManager sharedInstance].strCustId = @"";
    }
    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) ];
    //    self.slideSwitchView.frame = self.view.bounds;
    
    //    self.slideSwitchView.frame = self.view.bounds;
    self.slideSwitchView.backgroundColor = [QCSlideSwitchView colorFromHexRGB:@"f0f0f0"];
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"878787"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"171c61"];
    self.slideSwitchView.shadowImage = [[NSObject createImageWithColor:[QCSlideSwitchView colorFromHexRGB:@"171c61"]]
                                        stretchableImageWithLeftCapWidth:SCREEN_WIDTH/3 topCapHeight:0.0f];
    
    
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    __weak typeof(self) weakSelf = self;
    
    /**
     全部订单
     
     :returns: <#return value description#>
     */
    self.AllOrdersView = [[AllOrdersViewController alloc] initWithNibName:@"AllOrdersViewController" bundle:nil];
    self.AllOrdersView.ManagementTyep = self.ManagementTyep;
    self.AllOrdersView.BtnSkipSelect =^(NSInteger tag,NSDictionary* dictionary){
        NSString* strtag = [NSString stringWithFormat:@"%d",tag];
        NSInteger ntag = [[strtag substringToIndex:2] intValue];
         DLog(@"dictionary = %@",dictionary);
        if (ntag == 10) {
            DLog(@"详情");
            if ([dictionary[@"orderStatus"] intValue] == 0) {
                DLog(@"未完成订单")
                PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
                PickGoodsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
                PickGoodsView.ManagementTyep = weakSelf.ManagementTyep;
                [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
            }
            else
            {
                DLog(@"已完成订单");
                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
                CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
                CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
                [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
                
            }
        }

    };
    self.AllOrdersView.CellSkipSelect=^(NSDictionary* dictionary){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        GoodsDetailsView.strProductId = [NSString stringWithFormat:@"%d",[dictionary[@"productId"] intValue]];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };
    /**
     未完成订单
     
     :returns: <#return value description#>
     */
    self.OutstandingOrdersView = [[OutstandingOrdersViewController alloc] initWithNibName:@"OutstandingOrdersViewController" bundle:nil];
    
    self.OutstandingOrdersView.ManagementTyep = self.ManagementTyep;
    self.OutstandingOrdersView.BtnSkipSelect =^(NSInteger tag,NSDictionary* dictionary){
        DLog(@"dictionary = %@",dictionary);
        NSString* strtag = [NSString stringWithFormat:@"%d",tag];
        NSInteger ntag = [[strtag substringToIndex:2] intValue];
        if (ntag == 10 ) {
            if ([dictionary[@"orderStatus"] intValue] == 0) {
                DLog(@"未完成订单")
                PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
                PickGoodsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
                PickGoodsView.ManagementTyep = weakSelf.ManagementTyep;
                [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
            }
            else
            {
                DLog(@"已完成订单");
                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
                CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
                [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
                
            }

        }
        else
        {
            SaleType satype;
            if (tag == 1313) {
                DLog(@" 退货");
                satype = SaleTypeReturnGoods;
            }
            else if(tag == 1314)
            {
                DLog(@"提货");
                satype = SaleTypePickingGoods;
                
            }
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
        
    };
    self.OutstandingOrdersView.CellSkipSelect=^(NSDictionary* dictionary){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        GoodsDetailsView.strProductId = [NSString stringWithFormat:@"%d",[dictionary[@"productId"] intValue]];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };

    
    
    
    /**
     以完成订单
     
     :returns: <#return value description#>
     */
    self.CompleteOrderView = [[CompleteOrderViewController alloc] initWithNibName:@"CompleteOrderViewController" bundle:nil];
    self.CompleteOrderView.ManagementTyep = self.ManagementTyep;
    self.CompleteOrderView.BtnSkipSelect =^(NSInteger tag,NSDictionary* dictionary){
        NSString* strtag = [NSString stringWithFormat:@"%d",tag];
        NSInteger ntag = [[strtag substringToIndex:2] intValue];
        if (ntag == 10) {
            DLog(@"订单详情");
            DLog(@"已完成订单");
            CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
            CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
            CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
            [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];

        }
        else if(tag == 1312)
        {
            SaleType satype = SaleTypeReturnGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
    };
    self.CompleteOrderView.CellSkipSelect=^(NSDictionary* dictionary){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        GoodsDetailsView.strProductId = [NSString stringWithFormat:@"%d",[dictionary[@"productId"] intValue]];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };

    [self.slideSwitchView buildUI];
    [self.view addSubview:self.slideSwitchView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 3;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.AllOrdersView;
    } else if (number == 1) {
        return self.OutstandingOrdersView;
    } else if (number == 2) {
        return self.CompleteOrderView;
    } else {
        return nil;
    }
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{

    if (number == 0) {
        self.vcAll = self.AllOrdersView;
    } else if (number == 1) {
        self.vcAll = self.OutstandingOrdersView;
    } else if (number == 2) {
        self.vcAll = self.CompleteOrderView;
    }
    [self.vcAll viewDidCurrentView];
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
