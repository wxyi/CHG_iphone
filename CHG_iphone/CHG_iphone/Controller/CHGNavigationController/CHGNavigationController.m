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
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
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
            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
        }
        
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

@end
