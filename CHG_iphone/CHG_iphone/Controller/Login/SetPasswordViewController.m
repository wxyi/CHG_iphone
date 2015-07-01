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
        cell = (SetPasswordCell*)[[self.SetPasswordNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    
    cell.didSkipSubItem = ^(NSInteger tag){
        
        [weakSelf skipPage:tag];
    };
    cell.didGetCode = ^(NSString* checkcode)
    {
        weakSelf.strCheckCode = checkcode;
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
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 75, 180, 112)];
    
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
    else if(![checkcode.text isEqualToString:self.strCheckCode])
    {
        info = @"验证码错误";
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
    
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
//    [param setObject:config.strUsername forKey:@"userName"];
    [param setObject:[[NSObject md5:passfield1.text] uppercaseString]forKey:@"newPwd"];
    [param setObject:self.strCheckCode forKey:@"checkCode"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiResetPassword] parameters:parameter];
    
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            [ConfigManager sharedInstance].access_token = [[data objectForKey:@"datas"] objectForKey:@"access_token"];
            
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
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

@end
