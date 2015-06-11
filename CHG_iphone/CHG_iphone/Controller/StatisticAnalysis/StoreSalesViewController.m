//
//  StoreSalesViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreSalesViewController.h"
#import "PickGoodsViewController.h"
@interface StoreSalesViewController ()

@end

@implementation StoreSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)setupView
{
    self.title = [self pagetitle];
    self.slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) ];
    self.slideSwitchView.backgroundColor = UIColorFromRGB(0x171c61);
    //    self.slideSwitchView.frame = self.view.bounds;
    self.slideSwitchView.isNative = NO;
    //    self.slideSwitchView.frame = self.view.bounds;
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"f0f0f0"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"171c61"];
    self.slideSwitchView.tabItemNormalBackgroundImage = [NSObject createImageWithColor:[QCSlideSwitchView colorFromHexRGB:@"171c61"]];
    self.slideSwitchView.tabItemSelectedBackgroundImage = [NSObject createImageWithColor:[QCSlideSwitchView colorFromHexRGB:@"f0f0f0"]];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"head.png"]
                                        stretchableImageWithLeftCapWidth:SCREEN_WIDTH/3 topCapHeight:0.0f];
    
    
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    __weak typeof(self) weakSelf = self;
 
    self.StoreSalesDay = [[StoreSalesDayViewController alloc] initWithNibName:@"StoreSalesDayViewController" bundle:nil];
    self.StoreSalesDay.statisticalType = self.statisticalType;
    self.StoreSalesDay.didSkipSubItem =^(NSInteger tag){
        
        DLog(@"跳转详情");
        PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:PickGoodsView animated:YES];
    };
    
    

    self.StoreSalesMonth = [[StoreSalesMonthViewController alloc] initWithNibName:@"StoreSalesMonthViewController" bundle:nil];
    
    self.StoreSalesMonth.statisticalType = self.statisticalType;
    self.StoreSalesMonth.didSkipSubItem =^(NSInteger tag){

    };
    self.StoreSalesMonth.didSelectedSubItemAction =^(NSIndexPath* indexPath){
        UIButton* button = (UIButton*)[weakSelf.view viewWithTag:100];

        [weakSelf.slideSwitchView selectNameButton:button];
    };
   
    self.StoreSalesYear = [[StoreSalesYearViewController alloc] initWithNibName:@"StoreSalesYearViewController" bundle:nil];
    self.StoreSalesYear.statisticalType = self.statisticalType;
    self.StoreSalesYear.didSkipSubItem =^(NSInteger tag){

    };
    self.StoreSalesYear.didSelectedSubItemAction =^(NSIndexPath* indexPath){
        UIButton* button = (UIButton*)[weakSelf.view viewWithTag:101];
        
        [weakSelf.slideSwitchView selectNameButton:button];
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
        return self.StoreSalesDay;
    } else if (number == 1) {
        return self.StoreSalesMonth;
    } else if (number == 2) {
        return self.StoreSalesYear;
    } else {
        return nil;
    }
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
    if (number == 0) {
        self.vcAll = self.StoreSalesDay;
    } else if (number == 1) {
        self.vcAll = self.StoreSalesMonth;
    } else if (number == 2) {
        self.vcAll = self.StoreSalesYear;
    }
    [self.vcAll viewDidCurrentView];
}

-(NSString*)pagetitle
{
    NSString* strTitle;
    switch (self.statisticalType) {
        case StatisticalTypeStoreSales:
            strTitle = @"门店销售";
            break;
        case StatisticalTypeMembershipGrowth:
            strTitle = @"会员增长";
            break;
        case StatisticalTypePinRewards:
            strTitle = @"动销奖励";
            break;
        case StatisticalTypePartnersRewards:
            strTitle = @"合作商分账奖励";
            break;
        default:
            break;
    }
    return strTitle;
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
