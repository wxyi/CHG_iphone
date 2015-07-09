//
//  ResetViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/17.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ResetViewController.h"

@interface ResetViewController ()<UITextFieldDelegate>

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
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
    self.items = [NSArray arrayWithObjects:@"新密码",@"重复密码" ,nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
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
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    title.textColor = UIColorFromRGB(0x323232);
    title.font = FONT(15);
    title.text = [self.items objectAtIndex:indexPath.row];
    [cell.contentView addSubview:title];
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
    //    [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    textField.frame = CGRectMake(90, 2, SCREEN_WIDTH - 90, 40);
    textField.placeholder = [self.items objectAtIndex:indexPath.row]; //默认显示的字
    textField.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
    textField.secureTextEntry = YES; //密码
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.contentView addSubview:textField];
    
    
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
//   [self ConfirmTheChange];
    UITextField* textfield1 = (UITextField*)[self.view viewWithTag:1010];
    [textfield1 resignFirstResponder];
    UITextField* textfield2 = (UITextField*)[self.view viewWithTag:1011];
    [textfield2 resignFirstResponder];
    NSString* info;
    if (textfield1.text.length == 0 || textfield2.text.length == 0) {
        info= @"请输入密码";
    }
    else if (![textfield1.text isEqualToString:textfield2.text]) {
        info = @"密码输入不一致";
    }
    if (info.length != 0) {
     
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return;
    }
    [self httpResetPassword];
}
-(void)httpResetPassword
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    UITextField* textfield1 = (UITextField*)[self.view viewWithTag:1010];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[[NSObject md5:textfield1.text] uppercaseString] forKey:@"newPwd"];
    [param setObject:self.strCheckCode forKey:@"checkCode"];
    
    NSString *url = [NSObject URLWithBaseString:[APIAddress ApiResetPassword] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            
//            [SGInfoAlert showInfo:@"密码修改成功"
//                          bgColor:[[UIColor blackColor] CGColor]
//                           inView:self.view
//                         vertical:0.7];
//            sleep(1000);
            [ConfigManager sharedInstance].access_token = [[data objectForKey:@"datas"] objectForKey:@"access_token"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length < 6) {
        [SGInfoAlert showInfo:@"密码不能小于6位"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.6];
        [textField resignFirstResponder];
    }
}
@end
