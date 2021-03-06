//
//  ForgotPasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordCell.h"
#import "ResetPasswordViewController.h"
@interface ForgotPasswordViewController ()
@property UINib* ForgotPasswordNib;
@end

@implementation ForgotPasswordViewController

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
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = [UIColor whiteColor];
    self.ForgotPasswordNib = [UINib nibWithNibName:@"ForgotPasswordCell" bundle:nil];
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
    ForgotPasswordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ForgotPasswordCell"];
    if(cell==nil){
        cell = (ForgotPasswordCell*)[[self.ForgotPasswordNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
//    
//    cell.userField.leftView = paddingView;
//    
//    cell.userField.leftViewMode = UITextFieldViewModeAlways;
//    
//    cell.Verificationfield.leftView = paddingView;
//    cell.Verificationfield.leftViewMode = UITextFieldViewModeAlways;
    NSString* text = self.strmobile;
    NSMutableString *nsiphone = [[NSMutableString alloc] initWithString:text];
    [nsiphone insertString:@" " atIndex:7];
    [nsiphone insertString:@" " atIndex:3];
    cell.userField.text = nsiphone;
    cell.userField.enabled = NO;
    cell.userbgView.backgroundColor = UIColorFromRGB(0xdddddd);
    cell.didSkipSubItem = ^(NSInteger tag){
        
        [weakSelf skipPage:tag];
    };
    cell.didGetCode = ^(NSString* checkcode)
    {
        weakSelf.strCheckCode = checkcode;
        
//        [SGInfoAlert showInfo:weakSelf.strCheckCode
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self.view
//                     vertical:0.7];
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
    [leftButton setFrame:CGRectMake(10, 35, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_black_back.png"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
//    [leftButton setBackgroundColor:[UIColor blackColor]];
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [v_header addSubview:leftButton];
//    JTImageButton *leftbtn = [[JTImageButton alloc] initWithFrame:CGRectMake(10, 15, 50, 44)];
//    [leftbtn createTitle:@"返回" withIcon:[UIImage imageNamed:@"btn_back.png"] font:[UIFont systemFontOfSize:17] iconHeight:JTImageButtonIconHeightDefault iconOffsetY:1.0];
//    leftbtn.titleColor = UIColorFromRGB(0x171c61);
//    
//    leftbtn.iconColor = UIColorFromRGB(0x171c61);
//    leftbtn.padding = JTImageButtonPaddingSmall;
//    leftbtn.borderColor = [UIColor clearColor];
//    leftbtn.iconSide = JTImageButtonIconSideLeft;
//    [leftbtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
//    
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
        DLog(@"点击获取");
//        [self httpGetCheckCode];
    }
    else if(tag == 101)
    {
        DLog(@"下一步");
//        SetPasswordViewController *SetPasswordView = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
//        
//        [self presentViewController:SetPasswordView animated:YES completion:^{
//            
//        }];
        [self LoginAccount];
    }
    
}
-(void)LoginAccount
{
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    NSString *iphone = [namefield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [namefield resignFirstResponder];
    UITextField* checkcodefield = (UITextField*)[self.view viewWithTag:1012];
    [checkcodefield resignFirstResponder];
    NSString* info ;
    if (iphone.length == 0) {
        info = @"请输入手机号码";
    }
    else if (![IdentifierValidator isValid:IdentifierTypePhone value:iphone ])
    {
        info = @"手机格式不正确";
    }
    else if(checkcodefield.text.length == 0)
    {
        info = @"请输入验证码";
    }
    else if (checkcodefield.text.length > 6)
    {
        info = @"验证码不能大于6位";
    }
//    else if ([checkcodefield.text intValue] != [self.strCheckCode intValue])
//    {
//        info = @"验证码不正确";
//    }

    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }

    
    
    [self httpValidateCheckCode];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)httpValidateCheckCode
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiValidateCheckCode] parameters:parameter];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    NSString *iphone = [namefield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    UITextField* checkcodefield = (UITextField*)[self.view viewWithTag:1012];
    [param setObjectSafe:iphone forKey:@"mobile"];
    [param setObjectSafe:checkcodefield.text forKey:@"checkCode"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            ResetPasswordViewController *ResetPassword = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
            ResetPassword.strmobile = iphone;
            ResetPassword.strcheckCode = checkcodefield.text;
            [self presentViewController:ResetPassword animated:YES completion:^{
                
            }];
            
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
