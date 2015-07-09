//
//  AppDelegate.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/18.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AppDelegate.h"
#import "CHGNavigationController.h"
#import "REFrostedViewController.h"
#import "SidebarMenuTableViewController.h"
#import "HomePageViewController.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "WelcomePageViewController.h"
#import "LoginViewController.h"
#import "StoreManagementViewController.h"

#import "MyUncaughtExceptionHandler.h"

#import "PLCrashReporter.h"
//#import <MessageUI/MFMailComposeViewController.h>;

BMKMapManager* _mapManager;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupLoginViewController)
                                                 name:ACCESS_TOKEN_FAILURE
                                               object:nil];
//     PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
//    NSError *error;
//    // Check if we previously crashed
//    
//    if ([crashReporter hasPendingCrashReport])
//        
//        [self handleCrashReport];
//    
//    
//    // Enable the Crash Reporter
//    
//    if (![crashReporter enableCrashReporterAndReturnError: &error])
//    {
//        NSLog(@"Warning: Could not enable crash reporter: %@", error);
//    }
//    [picker release];

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"SKeSYmG89UjSAfaw9nh0fIIK" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_640.png"]];
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
//   NSDictionary* areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    DLog(@"areaDic = %@",[areaDic JSONString]);
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    // Create content and menu controllers
    //
    
//    [HttpClient inithttps];
    
    
    if (IOS_VERSION >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//        [[UINavigationBar appearance] setBackgroundColor:UIColorFromRGB(0x171c61)];
        [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x171c61)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
       
    }
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//    }
//    else{
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//    }
//    
//    [[SUHelper sharedInstance] sysInit:^(BOOL success) {
//        
//        if(success) {
//            
//            DLog(@"success");
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//                // 这里判断是否第一次
//                [[SUHelper sharedInstance] GetAddressInfo];
//                [[SUHelper sharedInstance] GetBankCodeInfo];
//                //                [[SUHelper sharedInstance] GetPromoList];
//                
//                [[SUHelper sharedInstance] GetRefreshCache:YES];
//                
//                
//            }
//            
//        }
//    }];
//    
//    
//    
//    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
//    {
//        [self setupLoginViewController];
//    }
//    else
//    {
//       
//        if ([ConfigManager sharedInstance].access_token.length != 0) {
//            
//            [self httpGetUserConfig];
////            [self setupHomePageViewController];
////            [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_FREE_LOGIN
////                                                                object:nil];
//        }
//        else
//        {
//            [self setupLoginViewController];
//        }
//    }
//    
//
////    [[SUHelper sharedInstance] GetPromoList];
//    
//    
//    self.window.backgroundColor = [UIColor whiteColor];
    WelcomePageViewController * view = [[WelcomePageViewController alloc] initWithNibName:@"WelcomePageViewController" bundle:nil];
    self.window.rootViewController = view;
    [self.window makeKeyAndVisible];
    
    
    [MyUncaughtExceptionHandler setDefaultHandler];
//    NSArray *array = [NSArray arrayWithObject:@"there is only one objective in this arary,call index one, app will crash and throw an exception!"];
//    NSLog(@"%@", [array objectAtIndex:1]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    DLog(@"---applicationDidEnterBackground----");
    //进入后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"---applicationDidBecomeActive----");
    //进入前台
    [BMKMapView didForeGround];
    
    [[SUHelper sharedInstance] GetRefreshCache:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



//
-(void)setupLoginViewController
{
    LoginViewController* loginview = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    self.window.rootViewController = loginview;
}
//
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
    self.window.rootViewController = frostedViewController;
}
-(void)setupStoreManagementViewController
{
    StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
    self.window.rootViewController = StoreManagementView;
}


- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}



//-(void)httpGetUserConfig
//{
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
//    
//    
//    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetUserConfig] parameters:parameter];
//    
//    
//    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
//        //        [MMProgressHUD dismiss];
//        if (success) {
//            DLog(@"data = %@",data);
////            [self removeLun];
//            //            [MMProgressHUD dismiss];
//            [ConfigManager sharedInstance].usercfg = [data JSONString];
//            
//            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
//            
//            
//            if ([config.Roles isEqualToString:@"SHOP_OWNER"]&&[config.shopList count] !=1 && [config.shopList count] != 0) {
//                
//                
//                StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
//                self.window.rootViewController = StoreManagementView;
//            }
//            else if([config.shopList count] == 0)
//            {
//                [MMProgressHUD dismiss];
//                [self setupLoginViewController];
//            }
//            else
//            {
//                
//                
//                if ([config.Roles isEqualToString:@"PARTNER"]) {
//                    [ConfigManager sharedInstance].shopId = @"";
//                    [ConfigManager sharedInstance].strdimensionalCodeUrl = config.strdimensionalCodeUrl;
//                }
//                else
//                {
//                    if ([config.shopList count] != 0) {
//                        [ConfigManager sharedInstance].shopId = [NSString stringWithFormat:@"%d",[[[config.shopList objectAtIndex:0] objectForKey:@"shopId"] intValue]];
//                        [ConfigManager sharedInstance].strdimensionalCodeUrl = [[config.shopList objectAtIndex:0] objectForKey:@"dimensionalCodeUrl"] ;
//                        
//                        [ConfigManager sharedInstance].strStoreName = [[config.shopList objectAtIndex:0] objectForKey:@"shopName"] ;
//                    }
//                    
//                }
//                
//                
//                
//                if ([config.shopList count] == 0 || [config.Roles isEqualToString:@"PARTNER"]){
//                    [self setupHomePageViewController];
//                }
//                else
//                {
//                    [MMProgressHUD dismiss];
//                    [self setupLoginViewController];
//                    
//                }
//            }
//            
//        }
//        else
//        {
//            //            [MMProgressHUD dismissWithError:msg];
////            [self removeLun];
//            [MMProgressHUD dismiss];
//            [self setupLoginViewController];
//        }
//    } failureBlock:^(NSString *description) {
//        DLog(@"description = n%@",description);
//        //        [MMProgressHUD dismissWithError:description];
////        [self removeLun];
//        [MMProgressHUD dismiss];
//        [self setupLoginViewController];
//    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        
//    }];
//}

//-(void)handleCrashReport
//{
//    DLog(@"handleCrashReport");
//    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
//    NSData *crashData;
//    NSError *error;
//    crashData = [crashReporter
//                 loadPendingCrashReportDataAndReturnError:
//                 &error];
//    MFMailComposeViewController *picker =
//    [[MFMailComposeViewController alloc] init];
//    [picker addAttachmentData:crashData
//                     mimeType:@"application/octet-stream"
//                     fileName:@"crashfile.crash"];
//    self.window.rootViewController = picker;
////    [self.window presentModalViewController:picker
////                            animated:YES];
//}

@end
