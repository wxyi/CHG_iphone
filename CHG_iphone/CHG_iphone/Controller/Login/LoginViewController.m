//
//  LoginViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCell.h"

#import "ResetPasswordViewController.h"
#import "ForgotPasswordViewController.h"
#import "StoreManagementViewController.h"
#import "SetPasswordViewController.h"
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
    return 220;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 220)];
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 75, 180, 70)];

    imageview.image = [UIImage imageNamed:@"logo.png"];
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
        ForgotPasswordViewController *ForgotPasswordView = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
        
        [self presentViewController:ForgotPasswordView animated:YES completion:^{
            
        }];
        DLog(@"忘记密码");
    }
    
}
-(void)LoginAccount
{
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    UITextField* passfield = (UITextField*)[self.view viewWithTag:1012];
    NSString* info ;
    if (namefield.text.length == 0) {
        info = @"请输入手机号码";
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
    
    if (info.length != 0) {
    
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
     
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"password" forKey:@"grant_type"];
    
    UITextField* textfield = (UITextField*)[self.view viewWithTag:1011];
    [parameter setObject:textfield.text forKey:@"username"];
    
    textfield = (UITextField*)[self.view viewWithTag:1012];
    [parameter setObject:[[NSObject md5:textfield.text] uppercaseString] forKey:@"password"];
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
            
            [self httpGetUserConfig];
        }
    } failureBlock:^(NSString *description) {
        DLog(@"description = %@",description);
//        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
-(void)httpGetUserConfig
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetUserConfig] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        [MMProgressHUD dismiss];
        if (success) {
            DLog(@"data = %@",data);
            [ConfigManager sharedInstance].usercfg = [data JSONString];
            
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
            [ConfigManager sharedInstance].shopId = [NSString stringWithFormat:@"%d",[[[config.shopList objectAtIndex:0] objectForKey:@"shopId"] intValue]];
            
            
            if ([[data objectForKey:@"loginFirst"] intValue] == 0)
            {
                SetPasswordViewController* ResetPasswordView = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
                [self presentViewController:ResetPasswordView animated:YES completion:^{
                    
                }];
            }
            else
            {
                
                if ([config.Roles isEqualToString:@"SHOP_OWNER"]) {
                    
                    
                    StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
                    [self presentViewController:StoreManagementView animated:YES completion:^{
                        
                    }];
                }
                else
                {
                    
                    
                    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                    [delegate setupHomePageViewController];
                }
            }
            
        }
        else
        {
            DLog(@"fail");
        }
    } failureBlock:^(NSString *description) {
        DLog(@"description = n%@",description);
        [MMProgressHUD dismissWithError:description];
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

@end
