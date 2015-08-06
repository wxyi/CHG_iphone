//
//  ResetPasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordCell.h"
#import "StoreManagementViewController.h"

#import "HomePageViewController.h"
#import "CHGNavigationController.h"
#import "SidebarMenuTableViewController.h"
#import "REFrostedViewController.h"
@interface ResetPasswordViewController ()<UITextFieldDelegate>
@property UINib* ResetPasswordNib;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
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
    self.ResetPasswordNib = [UINib nibWithNibName:@"ResetPasswordCell" bundle:nil];
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
    ResetPasswordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ResetPasswordCell"];
    if(cell==nil){
        cell = (ResetPasswordCell*)[[self.ResetPasswordNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    
    [cell.resetpasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    cell.resetpasswordField.delegate = self;
    [cell.confirmpasswordfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    cell.confirmpasswordfield.delegate = self;
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
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(10, 35, 60, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_blue.png"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    //    [leftButton setBackgroundColor:[UIColor blackColor]];
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [v_header addSubview:leftButton];
    
//    [v_header addSubview:leftbtn];
    
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
        UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
        [passfield1 resignFirstResponder];
        UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1012];
        [passfield2 resignFirstResponder];
        DLog(@"确认修改");
        [self ConfirmTheChange];
        
    }
    
}

-(void)ConfirmTheChange
{
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    [passfield1 resignFirstResponder];
    UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1012];
    [passfield2 resignFirstResponder];
    NSString* info ;
    if (passfield1.text.length == 0) {
        info = @"请输入密码";
    }
    else if (passfield1.text.length > 16)
    {
        info = @"密码必须小于16位";
    }
    else if (passfield1.text.length < 6)
    {
        info = @"密码不能小于6位";
    }
    else if(passfield2.text.length == 0)
    {
        info = @"请确认密码";
    }
    else if (passfield2.text.length > 16)
    {
        info = @"密码必须小于16位";
    }
    else if (passfield2.text.length < 6)
    {
        info = @"密码不能小于6位";
    }
    else if (![passfield1.text isEqualToString:passfield2.text])
    {
        info = @"密码输入不一致";
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
        [self httpResetPassWord];
    }
    
    
}
-(void)httpResetPassWord
{
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].strUserName forKey:@"userName"];
    [parameter setObjectSafe:self.strcheckCode forKey:@"checkCode"];
    [parameter setObjectSafe:[[NSObject md5:passfield1.text] uppercaseString] forKey:@"newPwd"];
    
   
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiForgetPassword] parameters:nil];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:parameter successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            DLog(@"msg = %@",[data objectForKeySafe:@"msg"]);
            
//            [SGInfoAlert showInfo:@"密码修改成功"
//                          bgColor:[[UIColor blackColor] CGColor]
//                           inView:self.view
//                         vertical:0.7];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_FAILURE
                                                                object:nil];
//            [MMProgressHUD dismiss];
//            [ConfigManager sharedInstance].access_token = [[data objectForKey:@"datas"] objectForKey:@"access_token"];
//            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
//            if ([config.Roles isEqualToString:@"SHOP_OWNER"]) {
//                
//                
//                StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
//                [self presentViewController:StoreManagementView animated:YES completion:^{
//                    
//                }];
//            }
//            else
//            {
//                [self setupHomePageViewController];
//            }
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
//        [MMProgressHUD dismissWithError:description];
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
                     vertical:0.6];
        [textField resignFirstResponder];
    }
}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField.text.length < 6) {
//        [SGInfoAlert showInfo:@"密码不能小于6位"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self.view
//                     vertical:0.6];
//        [textField resignFirstResponder];
//    }
//}
@end
