//
//  PickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PickGoodsViewController.h"
#import "PresellGoodsViewController.h"
#import "GoodsDetailsViewController.h"
#import "CompletedOrderDetailsViewController.h"
#import "OrderManagementViewController.h"

@interface PickGoodsViewController ()

@end

@implementation PickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    if (self.skiptype == SkipfromOrderManage) {
        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [leftButton addTarget:self action:@selector(gotoOrderManagement) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoOrderManagement
{
    OrderManagementViewController* OrderManagement = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
    OrderManagement.ManagementTyep = OrderManagementTypeSingle;
    OrderManagement.m_returnType = self.m_returnType;
    OrderManagement.title = @"会员订单";
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
    //    transition.delegate = self;
    
    [self.view.superview.layer addAnimation:transition forKey:nil];
    
    
    
    [self.navigationController pushViewController:OrderManagement animated:NO];
}
-(void)setupView
{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    self.DidNotPickGoodsView = [[DidNotPickGoodsViewController alloc] initWithNibName:@"DidNotPickGoodsViewController" bundle:nil];
    self.DidNotPickGoodsView.strOrderId = self.strOrderId;
    self.DidNotPickGoodsView.ManagementTyep = self.ManagementTyep;
    self.DidNotPickGoodsView.BtnSkipSelect =^(NSInteger tag,NSDictionary* dictionary){
        
        if (tag == 100)
        {
            DLog(@"终止定单")
            CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
            CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
            CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
            CompletedOrderDetailsView.m_returnType = weakSelf.m_returnType;
            CompletedOrderDetailsView.Comordertype = TerminationOrder;
            [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
//            weakSelf.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
//                DLog(@"否");
//                
//                
//            } otherButtonBlock:^{
//                DLog(@"是");
////                [weakSelf httpCancelOrder :dictionary];
//                CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
//                CompletedOrderDetailsView.strOrderId = [NSString stringWithFormat:@"%d",[dictionary[@"orderId"] intValue]];
//                CompletedOrderDetailsView.ManagementTyep = weakSelf.ManagementTyep;
//                CompletedOrderDetailsView.Comordertype = TerminationOrder;
//                [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
//            }];
            
            [weakSelf.stAlertView show];
        }
        else
        {
            SaleType satype = SaleTypePickingGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            PresellGoodsView.skiptype = SkipfromOrderManage;
            PresellGoodsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
        
    };
    self.DidNotPickGoodsView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
//        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
//        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };
    self.DidPickGoodsView = [[DidPickGoodsViewController alloc] initWithNibName:@"DidPickGoodsViewController" bundle:nil];
    self.DidPickGoodsView.strOrderId = self.strOrderId;
    self.DidPickGoodsView.ManagementTyep = self.ManagementTyep;
    self.DidPickGoodsView.BtnSkipSelect =^(NSInteger tag,NSDictionary* dictionary){
        {
            SaleType satype = SaleTypeReturnGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            PresellGoodsView.skiptype = SkipfromOrderManage;
            PresellGoodsView.m_returnType = weakSelf.m_returnType;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
    };
    self.DidPickGoodsView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
//        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
//        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };
    [self.slideSwitchView buildUI];
    [self.view addSubview:self.slideSwitchView];
}
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return 2;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.DidNotPickGoodsView;
    } else if (number == 1) {
        return self.DidPickGoodsView;
    } else {
        return nil;
    }
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
    if (number == 0) {
        self.vcAll = self.DidNotPickGoodsView;
    } else if (number == 1) {
        self.vcAll = self.DidPickGoodsView;
    }
    [self.vcAll viewDidCurrentView];
}
-(void)httpCancelOrder:(NSDictionary*)dict
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCancelOrder] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:dict[@"orderId"] forKey:@"orderId"];
    [param setObject:dict[@"orderFactAmount"] forKey:@"factAmount"];
    
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",[data objectForKey:@"datas"],[data objectForKey:@"msg"]);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"] intValue]==200){
            [MMProgressHUD dismiss];
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpCancelOrder:dict];
    }];
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
