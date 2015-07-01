//
//  StoreSalesViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreSalesViewController.h"
#import "PickGoodsViewController.h"
#import "CompletedOrderDetailsViewController.h"
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
//    self.title = [self pagetitle];
    
    self.isSkip = NO;
    [self getCurrentData];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    self.StoreSalesDay.strYear = self.strYear;
    self.StoreSalesDay.strMonth = self.strMonth;
    self.StoreSalesDay.strDay = self.strDay;
    self.StoreSalesDay.statisticalType = self.statisticalType;
    self.StoreSalesDay.skipdetails=^(NSString* orderID){
        DLog(@"跳转详情");
        CompletedOrderDetailsViewController* CompletedOrderDetailsView = [[CompletedOrderDetailsViewController alloc] initWithNibName:@"CompletedOrderDetailsViewController" bundle:nil];
        CompletedOrderDetailsView.strOrderId = orderID;
        CompletedOrderDetailsView.ManagementTyep = OrderManagementTypeAll;
        [weakSelf.navigationController pushViewController:CompletedOrderDetailsView animated:YES];
    };
    

    
    

    self.StoreSalesMonth = [[StoreSalesMonthViewController alloc] initWithNibName:@"StoreSalesMonthViewController" bundle:nil];
    self.StoreSalesMonth.strYear = self.strYear;
    self.StoreSalesMonth.strMonth = self.strMonth;
    self.StoreSalesMonth.statisticalType = self.statisticalType;
    self.StoreSalesMonth.didSkipSubItem =^(NSInteger tag){

    };
    self.StoreSalesMonth.CellSkipSelect =^(NSDictionary* dictionary){
        UIButton* button = (UIButton*)[weakSelf.view viewWithTag:100];

        weakSelf.isSkip = YES;
        NSString* data = dictionary[@"day"];
        weakSelf.strYear = [data substringToIndex:4];
        weakSelf.strMonth = [data substringWithRange:NSMakeRange(4, 2)];
        weakSelf.strDay = [data substringFromIndex:6];
        [weakSelf.slideSwitchView selectNameButton:button];
    };
   
    self.StoreSalesYear = [[StoreSalesYearViewController alloc] initWithNibName:@"StoreSalesYearViewController" bundle:nil];
    self.StoreSalesYear.strYear = self.strYear;
    self.StoreSalesYear.statisticalType = self.statisticalType;
    self.StoreSalesYear.didSkipSubItem =^(NSInteger tag){

    };
    self.StoreSalesYear.CellSkipSelect =^(NSDictionary* dictionary){
        UIButton* button = (UIButton*)[weakSelf.view viewWithTag:101];
        
        weakSelf.isSkip = YES;
        NSString* data = dictionary[@"year"];
        weakSelf.strYear = [data substringToIndex:4];
        weakSelf.strMonth = [data substringWithRange:NSMakeRange(4, 2)];
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
        self.StoreSalesDay.strYear= self.strYear;
        self.StoreSalesDay.strMonth= self.strMonth;
        self.StoreSalesDay.strDay= self.strDay;
        self.StoreSalesDay.isSkip= self.isSkip;
        self.vcAll = self.StoreSalesDay;
    } else if (number == 1) {
        self.StoreSalesMonth.strYear= self.strYear;
        self.StoreSalesMonth.strMonth= self.strMonth;
        self.StoreSalesMonth.isSkip= self.isSkip;
        self.vcAll = self.StoreSalesMonth;
    } else if (number == 2) {
        self.StoreSalesYear.strYear= self.strYear;
        self.StoreSalesYear.isSkip= self.isSkip;
        self.vcAll = self.StoreSalesYear;
    }
    [self.vcAll viewDidCurrentView];
    self.isSkip = NO;
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
-(void)getCurrentData
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    
    self.strYear = [NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
    self.strMonth = [NSString stringWithFormat:@"%d",[dateComponent month]];
    self.strDay = [NSString stringWithFormat:@"%d",[dateComponent day]];
    
    
}
@end
