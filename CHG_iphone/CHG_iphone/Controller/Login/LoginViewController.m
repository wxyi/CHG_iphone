//
//  LoginViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCell.h"
#import "NSDownNetImage.h"
#import "ResetPasswordViewController.h"
#import "ForgotPasswordViewController.h"
#import "StoreManagementViewController.h"
#import "SetPasswordViewController.h"

#import "HomePageViewController.h"
#import "CHGNavigationController.h"
#import "SidebarMenuTableViewController.h"
#import "REFrostedViewController.h"

#import "ProvinceInfo.h"
#import "AreaInfo.h"
#import "CityInfo.h"

@interface LoginViewController ()
@property UINib* LoginNib;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @""
    [self setupView];
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    DLog(@"frame = %@  width = %f height = %f",NSStringFromCGRect(self.tableview.frame),SCREEN_WIDTH,SCREEN_HEIGHT);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = [UIColor whiteColor];
    self.LoginNib = [UINib nibWithNibName:@"LoginCell" bundle:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    LoginCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
    if(cell==nil){
        cell = (LoginCell*)[[self.LoginNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
   
   [cell.passwordTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    cell.didSkipSubItem = ^(NSInteger tag){
        
        [weakSelf skipPage:tag];
    };
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (SCREEN_HEIGHT+ 64)* 0.4;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, (SCREEN_HEIGHT+ 64)* 0.4)];
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 75, 180, 112)];

    imageview.image = [UIImage imageNamed:@"icon_logo_big.png"];
    [v_header addSubview:imageview];
    
    return v_header;
}

-(void)skipPage:(NSInteger)tag
{
    UITextField* field1 = (UITextField*)[self.view viewWithTag:1011];
    [field1 resignFirstResponder];
    UITextField* field2 = (UITextField*)[self.view viewWithTag:1012];
    [field2 resignFirstResponder];
    
    if (tag == 100) {
        DLog(@"登陆");
        
        [self LoginAccount];
    }
    else if(tag == 101)
    {
        DLog(@"忘记密码");
        UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
        NSString* info;
        if (namefield.text.length == 0) {
            info = @"请输入账号";
        }
        if (info.length != 0) {
            
            [SGInfoAlert showInfo:info
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            return ;
        }
        [self httpGetMobileByUserName];
        
        
    }
    
}
-(void)LoginAccount
{
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    [namefield resignFirstResponder];
    UITextField* passfield = (UITextField*)[self.view viewWithTag:1012];
    [passfield resignFirstResponder];
    NSString* info ;
    if (namefield.text.length == 0) {
        info = @"请输入账号";
    }
    
//    else if (![IdentifierValidator isValid:IdentifierTypePhone value:namefield.text ])
//    {
//        info = @"手机格式不正确";
//    }
    else if(passfield.text.length == 0)
    {
        info = @"请输入密码";
    }
    else if (passfield.text.length < 6)
    {
        info = @"密码不能小于6位";
    }
    else if (passfield.text.length > 16)
    {
        info = @"密码不能大于16位";
    }
    
    if (info.length != 0) {
    
//        [MMProgressHUD dismissWithError:@"错误"];
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:.5];
        return ;
    }
     
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"password" forKey:@"grant_type"];
    
    
    [parameter setObject:namefield.text forKey:@"username"];
    
    
    [parameter setObject:[[NSObject md5:passfield.text] uppercaseString] forKey:@"password"];
    [parameter setObject:[ConfigManager sharedInstance].identifier forKey:@"client_code"];
    [parameter setObject:@"app" forKey:@"client_id"];
    [parameter setObject:@"appSecret" forKey:@"client_secret"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOauthToken] parameters:parameter];
    
//    url = @"https://27.115.74.138:8443/chg/oauth/token?grant_type=password&username=admin&password=21232F297A57A5A743894A0E4A801FC3&client_id=app&client_secret=appSecret";
    DLog(@"url = %@",url);
    [self httpLoadData:url];
    
    return ;
    
}

-(void)httpLoadData:(NSString*)strurl
{
//    strurl = @"https://www.baidu.com";
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:strurl parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);

//        if ([ConfigManager sharedInstance].access_token.length == 0)
//            self.isfrist = NO;
//        else
//            self.isfrist = YES;
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200)
        {

            [ConfigManager sharedInstance].access_token = [[data objectForKey:@"datas"] objectForKey:@"access_token"];
            
            DLog(@"access_token = %@",[ConfigManager sharedInstance].access_token);
//            if (![ConfigManager sharedInstance].strAddressCode)
//            {
//                [self httpAddressCode];
//                [self httpBankCode];
//            }
            
//            [self httpBankCode];
            [self httpGetUserConfig];
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
        DLog(@"description = %@",description);
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
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

//            [MMProgressHUD dismiss];
            [ConfigManager sharedInstance].usercfg = [data JSONString];
            
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
            
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
            
            if ([[data objectForKey:@"loginFirst"] intValue] != 0)
            {
                SetPasswordViewController* ResetPasswordView = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
                [self presentViewController:ResetPasswordView animated:YES completion:^{
                    [MMProgressHUD dismiss];
                }];
            }
            else
            {
                
                
                if ([config.Roles isEqualToString:@"SHOP_OWNER"]&&[config.shopList count] > 1) {
                    
                    
                    StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
                    [self presentViewController:StoreManagementView animated:YES completion:^{
                        [MMProgressHUD dismiss];
                    }];
                }
                else
                {

                    if ([config.shopList count] != 0 || ([config.shopList count] == 0 &&[config.Roles isEqualToString:@"PARTNER"])){
                        
                        [self DownStoreQrCode];
                        [self setupHomePageViewController];
                    }
                    else
                    {
                        [MMProgressHUD dismiss];
                        [SGInfoAlert showInfo:@"没有门店信息"
                                      bgColor:[[UIColor blackColor] CGColor]
                                       inView:self.view
                                     vertical:0.7];
                    }

                }
            }
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [MMProgressHUD dismiss];
            DLog(@"msg = %@",[data objectForKey:@"msg"]);
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        DLog(@"description = n%@",description);
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
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
    
    [self presentViewController:frostedViewController animated:YES completion:^{
        [MMProgressHUD dismiss];
    }];
}

-(void)httpGetMobileByUserName
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    UITextField* textfield = (UITextField*)[self.view viewWithTag:1011];
    
    [parameter setObject:textfield.text forKey:@"userName"];
    NSString *url = [NSObject URLWithBaseString:[APIAddress ApiGetMobileByUserName] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];

    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        if (success) {
            
            NSString* mobile = [data objectForKey:@"mobile"];
            if (mobile.length) {
                [MMProgressHUD dismiss];
                [ConfigManager sharedInstance].strUserName = textfield.text;
                ForgotPasswordViewController *ForgotPasswordView = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
                ForgotPasswordView.strmobile = mobile;
                [self presentViewController:ForgotPasswordView animated:YES completion:^{
                    
                }];
            }
            else
            {
//                [MMProgressHUD dismissWithError:@"手机号为空"];
                [MMProgressHUD dismiss];
                [SGInfoAlert showInfo:@"手机号为空"
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            }
            
            
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
        
    }];
}

- (void) textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
        [SGInfoAlert showInfo:@"密码不能大于16位"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.6];
        [textField resignFirstResponder];
    }
}
-(void)DownStoreQrCode
{
    [HttpClient asynchronousDownLoadFileWithProgress:[ConfigManager sharedInstance].strdimensionalCodeUrl parameters:nil successBlock:^(NSURL *filePath) {
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        UIImage * imageFromURL = [UIImage imageWithData:data];
        [NSDownNetImage saveImage:imageFromURL withFileName:@"StoreQrCode" ofType:@"jpg" inDirectory:APPDocumentsDirectory];
        
        
        NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:APPDocumentsDirectory];
        NSLog(@"%@",file);
        
    } failureBlock:^(NSString *description) {
        
        DLog(@"下载失败error = %@",description);
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
