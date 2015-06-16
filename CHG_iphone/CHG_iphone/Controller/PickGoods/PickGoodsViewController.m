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
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
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
    self.DidNotPickGoodsView.didSkipSubItem =^(NSInteger tag){
        if (tag == 101)
        {
            SaleType satype = SaleTypePickingGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
        
    };
    self.DidNotPickGoodsView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
    };
    self.DidPickGoodsView = [[DidPickGoodsViewController alloc] initWithNibName:@"DidPickGoodsViewController" bundle:nil];
    self.DidPickGoodsView.strOrderId = self.strOrderId;
    self.DidPickGoodsView.ManagementTyep = self.ManagementTyep;
    self.DidPickGoodsView.didSkipSubItem =^(NSInteger tag){
//        if (tag == 101)
        {
            SaleType satype = SaleTypeReturnGoods;
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = satype;
            [weakSelf.navigationController pushViewController:PresellGoodsView animated:YES];
        }
    };
    self.DidPickGoodsView.didSelectedSubItemAction=^(NSIndexPath* indexPath){
        GoodsDetailsViewController* GoodsDetailsView =[[GoodsDetailsViewController alloc] initWithNibName:@"GoodsDetailsViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:GoodsDetailsView animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
