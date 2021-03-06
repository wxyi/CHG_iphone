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

@interface LoginViewController ()<UIGestureRecognizerDelegate>
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
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = [UIColor whiteColor];
    self.LoginNib = [UINib nibWithNibName:@"LoginCell" bundle:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopUpView:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    tapGestureRecognizer.delegate = self;
    [self.tableview addGestureRecognizer:tapGestureRecognizer];
}
-(void)hidePopUpView:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.tableview];
    NSIndexPath* IndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    CGRect rectInTableView = [self.tableview rectForRowAtIndexPath:IndexPath];
    
    
    CGRect rect = [self.tableview convertRect:rectInTableView toView:[self.tableview superview]];
    NSLog(@"handleSingleTap!pointx:%f,y:%f rectInTableView y :%f, rect y:%f",point.x,point.y,rectInTableView.origin.y, rect.origin.y);
    
    
    LoginCell *cell = (LoginCell*)[self.tableview cellForRowAtIndexPath:IndexPath];
    if (cell.isOpened &&
        (point.y < rect.origin.y + 40 || point.y > rect.origin.y + 40 + cell.arr_Account.count * 40) &&
        (point.x < cell.bgView.frame.origin.x || point.x > cell.bgView.frame.origin.x + cell.bgView.frame.size.height) ) {
        [cell.openButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    
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
        cell = (LoginCell*)[[self.LoginNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
   
    if ([ConfigManager sharedInstance].strLoginAccount.length != 0) {
        cell.userTextfield.text = [ConfigManager sharedInstance].strLoginAccount;
    }
    
    [cell CreateDropDown];
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
    NSString* deviceName = [ConfigManager sharedInstance].deviceName;
    CGFloat width;
    if ([deviceName isEqualToString:@"iPhone 4S"] || [deviceName isEqualToString:@"iPhone 4"])
    {
        width= 227.0;
    }
    else
    {
        width= (SCREEN_HEIGHT+ 64)* 0.4;
    }
    return width;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString* deviceName = [ConfigManager sharedInstance].deviceName;
    CGFloat width;
    if ([deviceName isEqualToString:@"iPhone 4S"] || [deviceName isEqualToString:@"iPhone 4"])
    {
        width= 227.0;
    }
    else
    {
        width= (SCREEN_HEIGHT+ 64)* 0.4;
    }
    
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, width)];
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2, (width-112)/2, 130, 112)];

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
    [parameter setObjectSafe:@"password" forKey:@"grant_type"];
    
    
    [parameter setObjectSafe:namefield.text forKey:@"username"];
    
    
    [parameter setObjectSafe:[[NSObject md5:passfield.text] uppercaseString] forKey:@"password"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].identifier forKey:@"client_code"];
    [parameter setObjectSafe:@"app" forKey:@"client_id"];
    [parameter setObjectSafe:@"appSecret" forKey:@"client_secret"];
    
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
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
            [ConfigManager sharedInstance].strLoginAccount = namefield.text;
            [ConfigManager sharedInstance].access_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"access_token"];
            [ConfigManager sharedInstance].refresh_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"refresh_token"];
            DLog(@"access_token = %@",[ConfigManager sharedInstance].access_token);
            DLog(@"refresh_token = %@",[ConfigManager sharedInstance].refresh_token);
            
            LoginCell *cell = (LoginCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if ([ConfigManager sharedInstance].Arr_Account.length == 0) {
                
                [ConfigManager sharedInstance].Arr_Account = cell.userTextfield.text;
            }
            else
            {
                NSArray* Accountlist = [[ConfigManager sharedInstance].Arr_Account componentsSeparatedByString:NSLocalizedString(@",", nil)];
                NSMutableArray* muAccountList = [Accountlist mutableCopy];
                [muAccountList addObject:cell.userTextfield.text];
                NSSet *set = [NSSet setWithArray:muAccountList];
                [ConfigManager sharedInstance].Arr_Account =  [[set allObjects] componentsJoinedByString:@","];
            }
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
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
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
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpLoadData:strurl];
    }];
}
-(void)httpGetUserConfig
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
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
                [ConfigManager sharedInstance].strdimensionalCodeUrl = [data objectForKeySafe:@"dimensionalCodeUrl"];
            }
            else
            {
                if ([config.shopList count] != 0) {
                    [ConfigManager sharedInstance].shopId = [NSString stringWithFormat:@"%d",[[[config.shopList objectAtIndexSafe:0] objectForKeySafe:@"shopId"] intValue]];
                    [ConfigManager sharedInstance].strdimensionalCodeUrl = [[config.shopList objectAtIndexSafe:0] objectForKeySafe:@"dimensionalCodeUrl"] ;
                    
                    [ConfigManager sharedInstance].strStoreName = [[config.shopList objectAtIndexSafe:0] objectForKeySafe:@"shopName"] ;
                }
                
            }
            
            if ([[data objectForKeySafe:@"loginFirst"] intValue] != 0)
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
            DLog(@"msg = %@",[data objectForKeySafe:@"msg"]);
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
    
    [parameter setObjectSafe:textfield.text forKey:@"userName"];
    NSString *url = [NSObject URLWithBaseString:[APIAddress ApiGetMobileByUserName] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];

    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        if (success) {
            
            NSString* mobile = [data objectForKeySafe:@"mobile"];
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
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetMobileByUserName];
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
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        DLog(@"下载失败error = %@",description);
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
