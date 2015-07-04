//
//  ForgetViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ForgetViewController.h"
#import "JKCountDownButton.h"
#import "ResetViewController.h"
@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
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
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
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
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
    //    [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    textField.textColor = UIColorFromRGB(0x646464);
    textField.placeholder = @"动态验证码"; //默认显示的字
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.tag = 101;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [cell.contentView addSubview:textField];

    UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 2, 1, 40)];
    line.image = [UIImage imageNamed:@"line_y.png"];
    [cell.contentView addSubview:line];
    
    JKCountDownButton* countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    countDownCode.backgroundColor = [UIColor clearColor];
    countDownCode.titleLabel.font = FONT(13);
    countDownCode.titleLabel.textColor = UIColorFromRGB(0x646464);
    countDownCode.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 40);
    [countDownCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    
    [countDownCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    countDownCode.backgroundColor = [UIColor whiteColor];

    
    [cell.contentView addSubview:countDownCode];
    [countDownCode addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
        
        NSString* AlertInfo = [NSString stringWithFormat:@"已向手机号*******%@成功发送验证码,请注意查收!",[config.strMobile substringFromIndex:7]];
        
        self.stAlertView = [[STAlertView alloc] initWithTitle:AlertInfo message:@"" cancelButtonTitle:nil otherButtonTitle:@"确认" cancelButtonBlock:^{
            DLog(@"否");
            
            [self httpGetCheckCode];
            
        } otherButtonBlock:^{
            
        }];
        [self.stAlertView show];
        DLog(@"是");
        
        
        
        sender.enabled = NO;
        sender.alpha=0.4;
        sender.titleLabel.tintColor = [UIColor grayColor];
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            sender.titleLabel.tintColor = UIColorFromRGB(0x171C61);
            return @"点击重新获取";
            
        }];
        
    }];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 45)];
    title.textColor = UIColorFromRGB(0x323232);
    title.font = FONT(15);
    UserConfig* cfg = [[SUHelper sharedInstance] currentUserConfig];
    title.text = [NSString stringWithFormat:@"手机号码 %@",cfg.strMobile];
    [v_header addSubview:title];
    return v_header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* confirmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbtn.tag = 101;
    confirmbtn.backgroundColor = UIColorFromRGB(0x171c61);
    [confirmbtn.layer setMasksToBounds:YES];
    [confirmbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    //    [loginout.layer setBorderWidth:1.0]; //边框
    confirmbtn.frame = CGRectMake(5, 40, SCREEN_WIDTH-10 , 40);
    [confirmbtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmbtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:confirmbtn];
    return v_footer;
}
-(void)confirm:(UIButton*)sender
{
    DLog(@"确认");
    UITextField* textfield = (UITextField*)[self.view viewWithTag:101];
    [textfield resignFirstResponder];
    NSString* info;
    if (textfield.text.length == 0) {
        info = @"请输入验证码";
    }
    else if(![textfield.text isEqualToString:self.strCheckCode])
    {
        info = @"验证码不正确,请重新输入";
    }
    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    ResetViewController* ResetView = [[ResetViewController alloc] initWithNibName:@"ResetViewController" bundle:nil];
    ResetView.strCheckCode = self.strCheckCode;
    [self.navigationController pushViewController:ResetView animated:YES];
}


-(void)httpGetCheckCode
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    [parameter setObject:config.strMobile forKey:@"mobile"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetCheckCode] parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
            self.strCheckCode = [data objectForKey:@"checkCode"];
            
            
            [SGInfoAlert showInfo:self.strCheckCode
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        else
        {
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

@end
