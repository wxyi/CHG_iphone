//
//  OrderManagementViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderManagementViewController.h"
#import "PickGoodsViewController.h"
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
        }
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
            DLog(@"终止订单");
        }
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
