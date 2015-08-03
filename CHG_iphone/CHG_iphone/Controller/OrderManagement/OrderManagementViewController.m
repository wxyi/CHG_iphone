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
#import "successfulIdentifyViewController.h"
#import "OrderQuryViewController.h"
#import "SuccessRegisterViewController.h"
@interface OrderManagementViewController ()

@end

@implementation OrderManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"订单管理";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    btn_serch_hl@2x.png
//    btn_serch@2x.png
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(skipPage)];
//    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.backgroundColor = UIColorFromRGB(0x171c61);
//    [left.layer setMasksToBounds:YES];
//    [left.layer setCornerRadius:4]; //设置矩形四个圆角半径
//    //    [loginout.layer setBorderWidth:1.0]; //边框
//    left.frame = CGRectMake(0, 0, 50, 44);
//    [left setTitle:@"返回" forState:UIControlStateNormal];
//    [left setImage:[UIImage imageNamed:@"btn_back.png"]  forState:UIControlStateNormal];
//    [left setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
//    [left setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//    [left setTitleColor:UIColorFromRGB(0xf0f0f0) forState:UIControlStateNormal];
//    [left addTarget:self action:@selector(skipPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
//    JTImageButton *leftbtn = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 7, 50, 30)];
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
    
    if (self.m_returnType == OrderReturnTypeAMember) {
        
        [leftButton addTarget:self action:@selector(gobacktoSuccessFulldentify) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (self.m_returnType == OrderReturnTypePopPage)
    {
        [leftButton addTarget:self action:@selector(gobackRegistePage) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.ManagementTyep != OrderManagementTypeAll) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_serch.png"] style:UIBarButtonItemStylePlain target:self action:@selector(skipPage)];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
}
-(void)skipPage
{
    DLog(@"搜索");
    OrderQuryViewController* OrderQueryView = [[OrderQuryViewController alloc] initWithNibName:@"OrderQuryViewController" bundle:nil];
    OrderQueryView.ManagementTyep = self.ManagementTyep;
    OrderQueryView.m_returnType = OrderReturnTypeQueryOrder;
    [self.navigationController pushViewController:OrderQueryView animated:YES];
}
-(void)gobacktoSuccessFulldentify
{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[successfulIdentifyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(void)gobackRegistePage
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SuccessRegisterViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
//-(void)gobacktoSuccess
//{
//    successfulIdentifyViewController* successView = [[successfulIdentifyViewController alloc] initWithNibName:@"successfulIdentifyViewController" bundle:nil];
//    [self.navigationController popToViewController:successView animated:YES];
//}
-(void)setupView
{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
            if ([[dictionary objectForKeySafe:@"orderStatus"] intValue] == 0) {
                DLog(@"未完成订单")
                PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
                PickGoodsView.strOrderId = [NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"orderId"] intValue]];
                PickGoodsView.ManagementTyep = weakSelf.ManagementTyep;
                PickGoodsView.m_returnType = weakSelf.m_returnType;
                PickGoodsView.skiptype = SkipfromOrderManage;
                [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
            }
            else
            {
                DLog(@"已完成订单");
                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
                CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"orderId"] intValue]];
                CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
                CompletedOrderDetailsView.Comordertype = detailsOrder;
                CompletedOrderDetailsView.skiptype = SkipfromOrderManage;
                CompletedOrderDetailsView.m_returnType = weakSelf.m_returnType;
                [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
                
            }
        }
        else if (ntag == 11) {
            DLog(@"终止定单")
            CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
            CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"orderId"] intValue]];
            CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
            CompletedOrderDetailsView.Comordertype = TerminationOrder;
            CompletedOrderDetailsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
            
            
        }

    };
    self.AllOrdersView.CellSkipSelect=^(NSDictionary* dictionary){
//        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
//        GoodsDetailsView.strProductId = [NSString stringWithFormat:@"%d",[dictionary[@"productId"] intValue]];
//        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
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
            if ([[dictionary objectForKeySafe:@"orderStatus"] intValue] == 0) {
                DLog(@"未完成订单")
                PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
                PickGoodsView.strOrderId = [NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"orderId"] intValue]];
                PickGoodsView.ManagementTyep = weakSelf.ManagementTyep;
                PickGoodsView.m_returnType = weakSelf.m_returnType;
                [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
            }
            else
            {
                DLog(@"已完成订单");
                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
                CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
                CompletedOrderDetailsView.Comordertype = detailsOrder;
                CompletedOrderDetailsView.m_returnType = weakSelf.m_returnType;
                [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
                
            }

        }
        else if (ntag == 11) {
            DLog(@"终止定单")
            CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
            CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"orderId"] intValue]];
            CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
            CompletedOrderDetailsView.Comordertype = TerminationOrder;
            CompletedOrderDetailsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
//            weakSelf.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
//                DLog(@"否");
//                
//                
//            } otherButtonBlock:^{
//                DLog(@"是");
//                //            [self httpCancelOrder :dict];
//                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
//                CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
//                CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
//                CompletedOrderDetailsView.Comordertype = TerminationOrder;
//                [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
//            }];
//            
//            [weakSelf.stAlertView show];
            
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
            PresellGoodsView.skiptype = SkipFromPopPage;
            PresellGoodsView.orderSaletype = satype;
            PresellGoodsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
        
    };
    self.OutstandingOrdersView.CellSkipSelect=^(NSDictionary* dictionary){
//        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
//        GoodsDetailsView.strProductId = [NSString stringWithFormat:@"%d",[dictionary[@"productId"] intValue]];
//        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
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
            CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[[dictionary objectForKeySafe:@"orderId"] intValue]];
            CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
            CompletedOrderDetailsView.Comordertype = detailsOrder;
            CompletedOrderDetailsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];

        }
        else if(tag == 1312)
        {
            SaleType satype = SaleTypeReturnGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            PresellGoodsView.skiptype = SkipFromPopPage;
            PresellGoodsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
    };
    self.CompleteOrderView.CellSkipSelect=^(NSDictionary* dictionary){
//        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
//        GoodsDetailsView.strProductId = [NSString stringWithFormat:@"%d",[dictionary[@"productId"] intValue]];
//        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
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
