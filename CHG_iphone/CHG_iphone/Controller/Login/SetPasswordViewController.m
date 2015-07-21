//
//  SetPasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "SetPasswordCell.h"
#import "StoreManagementViewController.h"
@interface SetPasswordViewController ()
@property UINib* SetPasswordNib;
@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = [UIColor whiteColor];
    self.SetPasswordNib = [UINib nibWithNibName:@"SetPasswordCell" bundle:nil];
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
    SetPasswordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SetPasswordCell"];
    if(cell==nil){
        cell = (SetPasswordCell*)[[self.SetPasswordNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    [cell.setpasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    cell.setpasswordField.delegate = self;
    [cell.confirmpasswordfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    cell.confirmpasswordfield.delegate = self;
    cell.didSkipSubItem = ^(NSInteger tag){
        
        [weakSelf skipPage:tag];
    };
    cell.didGetCode = ^(NSString* checkcode)
    {
        weakSelf.strCheckCode = checkcode;
        
        [SGInfoAlert showInfo:weakSelf.strCheckCode
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
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
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, (width-112)/2, 180, 112)];

    
    imageview.image = [UIImage imageNamed:@"icon_logo_big.png"];
    [v_header addSubview:imageview];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 35, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_black_back.png"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    //    [leftButton setBackgroundColor:[UIColor blackColor]];
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [v_header addSubview:leftButton];
    return v_header;
}
-(void)goback
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)skipPage:(NSInteger)tag
{
    if (tag == 100) {
        DLog(@"验证码");
    }
    else if(tag == 101)
    {
        DLog(@"确认设置");
        [self ConfirmTheChange];
    }
}

-(void)ConfirmTheChange
{
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1010];
    [passfield1 resignFirstResponder];
    UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1011];
    [passfield2 resignFirstResponder];
    UITextField* checkcode = (UITextField*)[self.view viewWithTag:1012];
    [checkcode resignFirstResponder];
    NSString* info ;
    if (passfield1.text.length == 0) {
        info = @"请输入密码";
    }
    else if (passfield1.text.length > 16 )
    {
        info = @"密码必须小于16位";
    }
    else if (passfield1.text.length < 6)
    {
        info = @"密码不能小于6位";
    }
    else if ([passfield1.text isEqualToString:@"000000"] && ![config.Roles isEqualToString:@"PARTNER"])
    {
        info = @"密码不能与初始密码一致";
    }
    else if([config.Roles isEqualToString:@"PARTNER"] && [passfield1.text isEqualToString:[config.strMobile substringFromIndex:5]])
    {
        info = @"密码不能与初始密码一致";
    }
    else if(passfield2.text.length == 0)
    {
        info = @"请确认密码";
    }
    else if (![passfield1.text isEqualToString:passfield2.text])
    {
        info = @"密码输入不一致";
    }
    else if(checkcode.text.length == 0)
    {
        info = @"请输入验证码";
    }
    
    
    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    else
    {
        [self httpValidateCheckCode];
    }
    
    
}
-(void)httpResetPassWord
{
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
//    [param setObject:config.strUsername forKey:@"userName"];
    [param setObjectSafe:[[NSObject md5:passfield1.text] uppercaseString]forKey:@"newPwd"];
    [param setObjectSafe:self.strCheckCode forKey:@"checkCode"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiFirstSetPassword] parameters:parameter];
    
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            
            
//            [SGInfoAlert showInfo:@"密码修改成功"
//                          bgColor:[[UIColor blackColor] CGColor]
//                           inView:self.view
//                         vertical:0.7];
            
            [ConfigManager sharedInstance].access_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"access_token"];
            [ConfigManager sharedInstance].refresh_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"refresh_token"];
//            [ConfigManager sharedInstance].usercfg = [data JSONString];
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
            
            
            if ([config.Roles isEqualToString:@"SHOP_OWNER"]&&[config.shopList count] > 1) {
                
                
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
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpResetPassWord];
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
- (void) textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 16) {
        [SGInfoAlert showInfo:@"密码不能大于16位"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        [textField resignFirstResponder];
    }
}
-(void)httpValidateCheckCode
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiValidateCheckCode] parameters:parameter];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    UITextField* iphonefield = (UITextField*)[self.view viewWithTag:1010];
//    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    UITextField* checkfield = (UITextField*)[self.view viewWithTag:1012];
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    [param setObjectSafe:config.strMobile forKey:@"mobile"];
    [param setObjectSafe:checkfield.text forKey:@"checkCode"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            [self httpResetPassWord];
        }
        else
        {
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpValidateCheckCode];
    }];
}
@end
