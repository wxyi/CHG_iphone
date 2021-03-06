//
//  ChangePasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ForgetViewController.h"
#import "HomePageViewController.h"
@interface ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.items = [NSArray arrayWithObjects:@"原密码",@"新密码",@"重复密码" ,nil];
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
//    title.textColor = UIColorFromRGB(0x323232);
//    title.font = FONT(15);
//    title.text = [self.items objectAtIndexSafe:indexPath.row];
//    [cell.contentView addSubview:title];

    NoCopyTextField* textField = [[NoCopyTextField alloc] initWithFrame:CGRectZero];
//    [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    textField.placeholder = [self.items objectAtIndexSafe:indexPath.row]; //默认显示的字
    textField.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
    textField.secureTextEntry = YES; //密码
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.contentView addSubview:textField];
    
    
    if (indexPath.row == 0) {
        UIButton* forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetbtn.layer setMasksToBounds:YES];
        forgetbtn.tag = 100;
        forgetbtn.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 40);
        [forgetbtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetbtn.titleLabel.font = FONT(15);
        [forgetbtn setTitleColor:UIColorFromRGB(0x171C61) forState:UIControlStateNormal];
        [forgetbtn addTarget:self action:@selector(ChangePassword:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:forgetbtn];

        textField.frame = CGRectMake(10, 2, SCREEN_WIDTH -80, 40);
    }
    else
    {
        textField.frame = CGRectMake(10, 2, SCREEN_WIDTH -20, 40);
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* changebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changebtn.tag = 101;
    changebtn.backgroundColor = UIColorFromRGB(0x171c61);
    [changebtn.layer setMasksToBounds:YES];
    [changebtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    //    [loginout.layer setBorderWidth:1.0]; //边框
    changebtn.frame = CGRectMake(5, 40, SCREEN_WIDTH-10 , 40);
    [changebtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [changebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changebtn addTarget:self action:@selector(ChangePassword:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:changebtn];
    return v_footer;
}
-(void)ChangePassword:(UIButton*)sender
{
    if (sender.tag == 100) {
        DLog(@"忘记密码");
        ForgetViewController* ForgetView= [[ForgetViewController alloc] initWithNibName:@"ForgetViewController" bundle:nil];
        [self.navigationController pushViewController:ForgetView animated:YES];
    }
    else if(sender.tag == 101)
    {
        DLog(@"确认修改");
        [self ConfirmTheChange];
    }
    
}
-(void)ConfirmTheChange
{
    UITextField* passfield0 = (UITextField*)[self.view viewWithTag:1010];
    [passfield0 resignFirstResponder];
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    [passfield1 resignFirstResponder];
    UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1012];
    [passfield2 resignFirstResponder];
    NSString* info ;
    if (passfield0.text.length == 0) {
        info = @"请输入密码";
    }
    else if (passfield0.text.length > 16)
    {
        info = @"密码必须小于16位";
    }
    else if (passfield0.text.length < 6)
    {
        info = @"密码不能小于6位";
    }
    else if(passfield1.text.length == 0)
    {
        info = @"请确认密码";
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
    else if (passfield2.text.length < 6)
    {
        info = @"密码不能小于6位";
    }
    else if (passfield2.text.length > 16)
    {
        info = @"密码必须小于16位";
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
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1010];
    UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1011];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];

    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafe:[[NSObject md5:passfield1.text] uppercaseString] forKey:@"pwd"];
    [param setObjectSafe:[[NSObject md5:passfield2.text] uppercaseString] forKey:@"newpwd"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiUpdatePassword] parameters:parameter];
    
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            [MMProgressHUD dismiss];
            
            
            
            [ConfigManager sharedInstance].access_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"access_token"];
            [ConfigManager sharedInstance].refresh_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"refresh_token"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//            [delegate setupHomePageViewController];
            
            [SGInfoAlert showInfo:@"密码修改成功"
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
//            HomePageViewController *HomePageView = [self.navigationController.viewControllers objectAtIndexSafe:0];;
//            HomePageView.stAlert = @"修改密码成功";
//            [self.navigationController popToViewController:HomePageView animated:YES];
            
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
//        [SGInfoAlert showInfo:@"密码不能大于16位"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self.view
//                     vertical:0.5];
        [textField resignFirstResponder];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length < 6) {
//        [SGInfoAlert showInfo:@"密码不能小于6位"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self.view
//                     vertical:0.5];
        [textField resignFirstResponder];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    if ([NSObject stringContainsEmoji:string]) {
        return NO;
    }
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 16) {
        return NO;
    }
    
    return YES;
}
@end
