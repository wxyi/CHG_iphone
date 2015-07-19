//
//  CHGNavigationController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/21.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "CHGNavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "SidebarMenuTableViewController.h"

#import "OrderQuryViewController.h"
#import "SuccessRegisterViewController.h"
#import "successfulIdentifyViewController.h"
#import "MemberCenterViewController.h"
#import "OrderManagementViewController.h"

#import "HomePageViewController.h"
@interface CHGNavigationController ()
@property (strong, readwrite, nonatomic) SidebarMenuTableViewController *SidebarMenuController;
@end

@implementation CHGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showMenu
{
    DLog(@"count = %d",[self.viewControllers count]);
    [self.frostedViewController presentMenuViewController];
}

-(void)skipPage
{
    DLog(@"搜索");
    
    OrderQuryViewController* OrderQueryView = [[OrderQuryViewController alloc] initWithNibName:@"OrderQuryViewController" bundle:nil];
    [self pushViewController:OrderQueryView animated:YES];
}
- (void)goback
{
    [self popToRootViewControllerAnimated:YES];
}
- (void)gobackMemberCenter
{
    MemberCenterViewController* memberView = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
//    transition.delegate = self;
    
    [self.view.superview.layer addAnimation:transition forKey:nil];
    

    
    [self pushViewController:memberView animated:NO];
//    [self popToRootViewControllerAnimated:YES];
}
-(void)gobacktoSuccess
{
    [self popViewControllerAnimated:YES];
}
-(void)gotoOrderManagement
{
    OrderManagementViewController* OrderManagement = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
    OrderManagement.ManagementTyep = OrderManagementTypeSingle;
    OrderManagement.m_returnType = OrderReturnTypeAMember;
    OrderManagement.title = @"会员订单";
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
//    transition.delegate = self;
    
    [self.view.superview.layer addAnimation:transition forKey:nil];
    


    [self pushViewController:OrderManagement animated:NO];
}

-(void)gobacktoSuccessFulldentify
{
    successfulIdentifyViewController* successfulIdentifyView = [[successfulIdentifyViewController alloc] initWithNibName:@"successfulIdentifyViewController" bundle:nil];
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
//    transition.delegate = self;
    
    [self.view.superview.layer addAnimation:transition forKey:nil];
    

    
    [self pushViewController:successfulIdentifyView animated:NO];
}
#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    DLog(@"count = %d",[self.viewControllers count]);
    if ([self.viewControllers count] == 1) {
        [self.frostedViewController panGestureRecognized:sender];
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
-(void)RegisteSuccessful
{
    [self httpCreateCustomer ];
    
}
-(void)httpCreateCustomer
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCreateCustomer] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[ConfigManager sharedInstance].strcustMobile forKey:@"custMobile"];
    [param setObject:[ConfigManager sharedInstance].strcheckCode forKey:@"checkCode"];
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:[ConfigManager sharedInstance].strcustName forKey:@"custName"];

    [param setObject:@"" forKey:@"babyBirthday"];
    [param setObject:@"" forKey:@"babyRelation"];
    [param setObject:@"" forKey:@"babyGender"];

    
    DLog(@"param = %@",param);
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            
            [ConfigManager sharedInstance].strCustId = [NSString stringWithFormat:@"%d",[[[data objectForKey:@"datas"] objectForKey:@"custId"] intValue]];
            SuccessRegisterViewController* SuccessRegisterView = [[SuccessRegisterViewController alloc] initWithNibName:@"SuccessRegisterViewController" bundle:nil];
            
            [self pushViewController:SuccessRegisterView animated:YES];
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
        [self httpCreateCustomer];
    }];
}
-(void)unbundlingbankCard
{
    self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认解绑此银行卡" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
        DLog(@"否");
        
        [self httpDeleteBankCard];
    } otherButtonBlock:^{
        DLog(@"是");
        
        // Delete button was pressed
        
        
    }];
    
    [self.stAlertView show];
}

-(void)httpDeleteBankCard
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].strBankId forKey:@"bankId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiDeleteBankCard] parameters:parameter];
    
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
        [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (success) {
                        [MMProgressHUD dismiss];
//            [self httpGetBankCardList];
            [self popViewControllerAnimated:YES];
        }
        else
        {
            //            [MMProgressHUD dismissWithError:msg];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
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
        [self httpDeleteBankCard];
    }];
}
@end
