//
//  ViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/18.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ViewController.h"
#import "LKWelcomeView.h"
#import "CHGNavigationController.h"
#import "REFrostedViewController.h"
#import "SidebarMenuTableViewController.h"
#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "StoreManagementViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupLoginViewController)
                                                 name:ACCESS_TOKEN_FAILURE
                                               object:nil];
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
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
                // 这里判断是否第一次
                [[SUHelper sharedInstance] GetAddressInfo];
                [[SUHelper sharedInstance] GetBankCodeInfo];
                [[SUHelper sharedInstance] GetRefreshCache:YES];
                
                
                NSMutableArray* dataArray = [NSMutableArray array];
                for (int i=1; i<=4; i++) {
                    //加载图片的完整路劲
                    [dataArray addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"1136-640 %d",i] ofType:@"jpg"]];
                }
                //怎么判断是第一次进入 可以有 判断文件 判断字段 等等方法
                LKWelcomeView* welcome = [[LKWelcomeView alloc]initWithFrame:self.view.bounds andPathArray:dataArray];
                
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
    }];
    
}


-(void)setupLoginViewController
{
    LoginViewController* loginview = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
//    self.window.rootViewController = loginview;
    [self presentViewController:loginview animated:YES completion:^{
        
    }];
}

-(void)setupHomePageViewController
{
    CHGNavigationController *navigationController = [[CHGNavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
    
    SidebarMenuTableViewController *SidebarMenu = [[SidebarMenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:SidebarMenu];
    
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.limitMenuViewSize = YES;
    // Make it a root controller
    //
//    self.window.rootViewController = frostedViewController;
    [self presentViewController:frostedViewController animated:YES completion:^{
        
    }];
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
                
                
                StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
                [self presentViewController:StoreManagementView animated:YES completion:^{
                    
                }];
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
                    [ConfigManager sharedInstance].strdimensionalCodeUrl = config.strdimensionalCodeUrl;
                }
                else
                {
                    if ([config.shopList count] != 0) {
                        [ConfigManager sharedInstance].shopId = [NSString stringWithFormat:@"%d",[[[config.shopList objectAtIndex:0] objectForKey:@"shopId"] intValue]];
                        [ConfigManager sharedInstance].strdimensionalCodeUrl = [[config.shopList objectAtIndex:0] objectForKey:@"dimensionalCodeUrl"] ;
                        
                        [ConfigManager sharedInstance].strStoreName = [[config.shopList objectAtIndex:0] objectForKey:@"shopName"] ;
                    }
                    
                }
                
                
                
                if ([config.shopList count] == 0 || [config.Roles isEqualToString:@"PARTNER"]){
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
        
    }];
}
@end
