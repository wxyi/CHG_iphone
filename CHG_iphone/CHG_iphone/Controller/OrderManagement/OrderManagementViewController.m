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
@interface OrderManagementViewController ()

@end

@implementation OrderManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单管理";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
}

-(void)setupView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) ];
    //    self.slideSwitchView.frame = self.view.bounds;
    
    //    self.slideSwitchView.frame = self.view.bounds;
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"000000"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"ee85ec"];
    self.slideSwitchView.shadowImage = [[NSObject createImageWithColor:[UIColor blueColor]]
                                        stretchableImageWithLeftCapWidth:SCREEN_WIDTH/3 topCapHeight:0.0f];
    
    
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    __weak typeof(self) weakSelf = self;
    
    /**
     全部订单
     
     :returns: <#return value description#>
     */
    self.AllOrdersView = [[AllOrdersViewController alloc] initWithNibName:@"AllOrdersViewController" bundle:nil];
    
    self.AllOrdersView.didSkipSubItem =^(NSInteger tag){
        
        DLog(@"跳转详情");
        PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
    };
    self.AllOrdersView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };
    /**
     未完成订单
     
     :returns: <#return value description#>
     */
    self.OutstandingOrdersView = [[OutstandingOrdersViewController alloc] initWithNibName:@"OutstandingOrdersViewController" bundle:nil];
    
    
    self.OutstandingOrdersView.didSkipSubItem =^(NSInteger tag){
        DLog(@"row = %ld",(long)tag);
        if (tag == 101) {
            DLog(@"订单详情");
            PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
        }
        else if(tag == 102)
        {
            DLog(@"终止订单");
            weakSelf.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
                
                
            } otherButtonBlock:^{
                DLog(@"是");
                
            }];
            
            [weakSelf.stAlertView show];
        }
        else
        {
            SaleType satype;
            if (tag == 103) {
                DLog(@" 退货");
                satype = SaleTypeReturnGoods;
            }
            else if(tag == 104)
            {
                DLog(@"提货");
                satype = SaleTypePickingGoods;
                
            }
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
        
    };
    self.OutstandingOrdersView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };
    
    
    
    /**
     以完成订单
     
     :returns: <#return value description#>
     */
    self.CompleteOrderView = [[CompleteOrderViewController alloc] initWithNibName:@"CompleteOrderViewController" bundle:nil];
    self.CompleteOrderView.didSkipSubItem =^(NSInteger tag){
        if (tag == 101) {
            DLog(@"订单详情");
            PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
            [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
        }
        else if(tag == 102)
        {
            SaleType satype = SaleTypeReturnGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
    };
    self.CompleteOrderView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
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
