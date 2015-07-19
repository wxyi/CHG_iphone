//
//  WelcomePageViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/7/8.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "WelcomePageViewController.h"
#import "LKWelcomeView.h"
#import "CHGNavigationController.h"
#import "REFrostedViewController.h"
#import "SidebarMenuTableViewController.h"
#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "StoreManagementViewController.h"
@interface WelcomePageViewController ()

@end

@implementation WelcomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.BgImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT +64);
    NSString* imageName;
    if ([[ConfigManager sharedInstance].deviceName isEqualToString:@"iPhone 4"]
        ||[[ConfigManager sharedInstance].deviceName isEqualToString:@"iPhone 4S"]) {
        imageName = @"page_320.png";
    }
    else if ([[ConfigManager sharedInstance].deviceName isEqualToString:@"iPhone 5"]
             ||[[ConfigManager sharedInstance].deviceName isEqualToString:@"iPhone 5S"]
             ||[[ConfigManager sharedInstance].deviceName isEqualToString:@"iPhone 5C"]) {
        imageName = @"page_640.png";
    }
    else if ([[ConfigManager sharedInstance].deviceName isEqualToString:@"iPhone 6"] ) {
        imageName = @"page_750.png";
    }
    else
    {
        imageName = @"page_1242.png";
    }
    
    self.BgImage.image = [UIImage imageNamed:imageName];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    [[SUHelper sharedInstance] sysInit:^(BOOL success) {
        
        if(success) {
            
            DLog(@"success");
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//                // 这里判断是否第一次
//                [[SUHelper sharedInstance] GetAddressInfo];
//                [[SUHelper sharedInstance] GetBankCodeInfo];
//                [[SUHelper sharedInstance] GetRefreshCache:YES];
//                
//            }
            
        }
    }];
    
    
    NSInteger count =  [[[SQLiteManager sharedInstance] getBankCodeDatas] count];
    if (count == 0) {
        [[SUHelper sharedInstance] GetBankCodeInfo];
    }
//    NSInteger countcity =  [[[SQLiteManager sharedInstance] getCityCodeData] count];
//    NSInteger countarea =  [[[SQLiteManager sharedInstance] getAreaCodeData] count];
//    NSInteger countProvince =  [[[SQLiteManager sharedInstance] getProvinceCodeData] count];
//    if (countcity == 0 ||countarea == 0 ||countProvince == 0) {
//        [[SUHelper sharedInstance] GetAddressInfo];
//    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        // 这里判断是否第一次
        
        NSMutableArray* dataArray = [NSMutableArray array];
        for (int i=1; i<=4; i++) {
            //加载图片的完整路劲
            [dataArray addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"splash%d",i] ofType:@"png"]];
        }
        //怎么判断是第一次进入 可以有 判断文件 判断字段 等等方法
        LKWelcomeView* welcome = [[LKWelcomeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT +64) andPathArray:dataArray];
        
        [self.view addSubview:welcome];
        welcome.endEvent = ^(){
            //当要进入主程序
            [self setupLoginViewController];
            
        };
        
        
    }
    else
    {
        if ([ConfigManager sharedInstance].access_token.length != 0) {
            
            [self httpGetUserConfig];
            
        }
        else
        {
            [self setupLoginViewController];
        }
    }

}


-(void)setupLoginViewController
{
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate setupLoginViewController];
}

-(void)setupHomePageViewController
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate setupHomePageViewController];
}

-(void)httpGetUserConfig
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetUserConfig] parameters:parameter];
    
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        //        [MMProgressHUD dismiss];
        if (success) {
            DLog(@"data = %@",data);
            //            [self removeLun];
            //            [MMProgressHUD dismiss];
            [ConfigManager sharedInstance].usercfg = [data JSONString];
            
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
            
            
            if ([config.Roles isEqualToString:@"SHOP_OWNER"]&&[config.shopList count] !=1 && [config.shopList count] != 0) {
                
                
                AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                [delegate setupStoreManagementViewController];
                //                self.window.rootViewController = StoreManagementView;
            }
            else if([config.shopList count] == 0)
            {
                [MMProgressHUD dismiss];
                [self setupLoginViewController];
            }
            else
            {
                
                
                if ([config.Roles isEqualToString:@"PARTNER"]) {
                    [ConfigManager sharedInstance].shopId = @"";
                    [ConfigManager sharedInstance].strdimensionalCodeUrl = [data objectForKey:@"dimensionalCodeUrl"];
                }
                else
                {
                    if ([config.shopList count] != 0) {
                        [ConfigManager sharedInstance].shopId = [NSString stringWithFormat:@"%d",[[[config.shopList objectAtIndex:0] objectForKey:@"shopId"] intValue]];
                        [ConfigManager sharedInstance].strdimensionalCodeUrl = [[config.shopList objectAtIndex:0] objectForKey:@"dimensionalCodeUrl"] ;
                        
                        [ConfigManager sharedInstance].strStoreName = [[config.shopList objectAtIndex:0] objectForKey:@"shopName"] ;
                    }
                    
                }
                
                
                
                if (([config.shopList count] == 0 && [config.Roles isEqualToString:@"PARTNER"])||[config.shopList count] == 1){
                    [self setupHomePageViewController];
                }
                else
                {
                    [MMProgressHUD dismiss];
                    [self setupLoginViewController];
                    
                }
            }
            
        }
        else
        {
            //            [MMProgressHUD dismissWithError:msg];
            //            [self removeLun];
            [MMProgressHUD dismiss];
            [self setupLoginViewController];
        }
    } failureBlock:^(NSString *description) {
        DLog(@"description = n%@",description);
        //        [MMProgressHUD dismissWithError:description];
        //        [self removeLun];
        [MMProgressHUD dismiss];
        [self setupLoginViewController];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetUserConfig];
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
