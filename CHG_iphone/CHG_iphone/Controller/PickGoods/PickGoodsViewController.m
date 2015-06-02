//
//  PickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PickGoodsViewController.h"

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
    self.slideSwitchView.tabItemNormalColor = [QCSlideSwitchView colorFromHexRGB:@"000000"];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"ee85ec"];
    self.slideSwitchView.shadowImage = [[NSObject createImageWithColor:[UIColor blueColor]]
                                        stretchableImageWithLeftCapWidth:SCREEN_WIDTH/3 topCapHeight:0.0f];
    
    
    self.slideSwitchView.slideSwitchViewDelegate = self;
    
    self.DidNotPickGoodsView = [[DidNotPickGoodsViewController alloc] initWithNibName:@"DidNotPickGoodsViewController" bundle:nil];
    
    
    self.DidPickGoodsView = [[DidPickGoodsViewController alloc] initWithNibName:@"OutstandingOrdersViewController" bundle:nil];
    
 
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
