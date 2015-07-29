//
//  RegisteredMembersViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "RegisteredMembersViewController.h"
#import "RegisteredMembersCell.h"
#import "MemberInfoViewController.h"

#import "UIViewController+REFrostedViewController.h"


@interface RegisteredMembersViewController ()
@property UINib* RegisteredMembersNib;
@end

@implementation RegisteredMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员注册";
    // Do any additional setup after loading the view from its nib.
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    if (self.ordertype == OrderReturnTypeAMember) {
        [leftButton addTarget:(CHGNavigationController*)self.navigationController action:@selector(gobackMemberCenter) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [leftButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    
    [self setupView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)goback
{
    for (int i = 0; i < 3; i ++) {
        UITextField* textfield = (UITextField*)[self.view viewWithTag:1010+i];
        [textfield resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    //    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.RegisteredMembersNib = [UINib nibWithNibName:@"RegisteredMembersCell" bundle:nil];
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
    RegisteredMembersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RegisteredMembersCell"];
    if(cell==nil){
        cell = (RegisteredMembersCell*)[[self.RegisteredMembersNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    cell.iphoneField.text = self.strIphone;
//    cell.iphoneField.delegate = self;
    [cell.iphoneField becomeFirstResponder];// 2
    [cell.iphoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    cell.nameField.delegate = self;
    [cell.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    cell.codeField.delegate = self;
    [cell.codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    cell.didshowInfo = ^(NSString* info){
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    };
    cell.didGetCode = ^(NSString* checkcode)
    {
        weakSelf.strCheckCode = checkcode;
        
        [SGInfoAlert showInfo:checkcode
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    };
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
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
    JTImageLabel *promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    promptlabel.tag = 103333;
    
    promptlabel.textLabel.text = @"";
    promptlabel.textLabel.font = FONT(12);
    promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
    promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;

    [v_footer addSubview:promptlabel];
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = CGRectMake(6, 45, CGRectGetWidth(self.view.bounds)-12, 40);
    [nextBtn.layer setMasksToBounds:YES];
    [nextBtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [nextBtn setBackgroundColor:UIColorFromRGB(0x171c61)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:nextBtn];
    return v_footer;
}
-(void)nextBtn
{
    DLog(@"下一步");
    UITextField* iphonefield = (UITextField*)[self.view viewWithTag:1010];
    [iphonefield resignFirstResponder];
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    [namefield resignFirstResponder];
    UITextField* checkfield = (UITextField*)[self.view viewWithTag:1012];
    [checkfield resignFirstResponder];
    
    if ([NSObject stringContainsEmoji:namefield.text]) {
        DLog(@"包含表情");
        [SGInfoAlert showInfo:@"会员姓名不能包含表情"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;

    }
//    NSString* info ;
//    if (iphonefield.text.length == 0) {
//        info = @"请输入手机号码";
//    }
//    else if (![IdentifierValidator isValid:IdentifierTypePhone value:iphonefield.text ])
//    {
//        info = @"手机格式不正确";
//    }
//    else if(namefield.text.length == 0)
//    {
//        info = @"请输入姓名";
//    }
//    else if (checkfield.text.length == 0)
//    {
//        info = @"请输入验证码";
//    }
//    else if (checkfield.text.length > 6)
//    {
//        info = @"验证码不能大于6位";
//    }
//    
//    if (info.length != 0) {
//        
//        [SGInfoAlert showInfo:info
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self.view
//                     vertical:0.7];
//        return ;
//    }
    
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

- (void) textFieldDidChange:(UITextField*) textField
{
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kAlphaNum options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, [textField.text length]) withTemplate:@""];
//    DLog(@"modifiedString = %@ textField.text = %@",modifiedString,textField.text)
//    textField.text = modifiedString;
    NSString * info;
    if (textField.tag == 1010) {
        
//        DLog(@"%@",[textField.text substringToIndex:1]);
        if (textField.text.length > 1 && [[textField.text substringToIndex:1] intValue]!= 1) {
//            textField.text = @"";
            info = @"手机号格式不正确";
        }
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
//            [textField resignFirstResponder];
            info = @"手机号不能大于11位";
        }
        else
        {
            info = @"";
        }
    }
    else if(textField.tag == 1011)
    {
        if (textField.markedTextRange == nil&& textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
            info = @"会员姓名不能大于15位";
        }
//        if (textField.text.length > 15) {
//            textField.text = [textField.text substringToIndex:15];
////            [textField resignFirstResponder];
//            info = @"会员姓名不能大于15位";
//        }
        else
        {
            info = @"";
        }
    }
    else if(textField.tag == 1012)
    {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
//            [textField resignFirstResponder];
            info = @"验证码不能大于6位";
        }
        else
        {
            info = @"";
        }
    }
    
    JTImageLabel* imagelabel = (JTImageLabel*)[self.view viewWithTag:103333];
    if (info.length != 0) {
        
        imagelabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
        imagelabel.textLabel.text = info;
        [imagelabel layoutSubviews];
    }
    else
    {
        imagelabel.imageView.image = nil;
        imagelabel.textLabel.text = @"";
        [imagelabel layoutSubviews];
    }
//    if (textField.text.length > 11 || (textField.text.length>=1 &&[[textField.text substringToIndex:1] intValue] != 1)) {
//        [SGInfoAlert showInfo:@"手机号输入有误"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self.view
//                     vertical:0.4];
//    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSString* info;
    
    NSString * info ;
    if (textField.tag == 1010) {
        if (textField.text.length != 11 && textField.text.length > 0 && [[textField.text substringToIndex:1] intValue] != 1)
        {
            info = @"手机格式不正确";
        }
    }
    else if(textField.tag == 1012)
    {
        if (textField.text.length != 6) {
            info = @"验证码输入有误";
        }
    }
    
    if (info.length != 0) {
        JTImageLabel* imagelabel = (JTImageLabel*)[self.view viewWithTag:103333];
        imagelabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
        imagelabel.textLabel.text = info;
        [imagelabel layoutSubviews];
    }
    
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.tag == 1010) {
//        if (textField.text.length > 11) {
//            [textField resignFirstResponder];
//        }
//    }
//    else if(textField.tag == 1011)
//    {
//        if (textField.text.length > 32) {
//            [textField resignFirstResponder];
//        }
//    }
//    else if(textField.tag == 1012)
//    {
//        if (textField.text.length > 6) {
//            [textField resignFirstResponder];
//        }
//    }
//}

-(void)httpValidateCheckCode
{
   
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiValidateCheckCode] parameters:parameter];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    UITextField* iphonefield = (UITextField*)[self.view viewWithTag:1010];
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    UITextField* checkfield = (UITextField*)[self.view viewWithTag:1012];
    [param setObjectSafe:iphonefield.text forKey:@"mobile"];
    [param setObjectSafe:checkfield.text forKey:@"checkCode"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            MemberInfoViewController* MemberInfoView= [[MemberInfoViewController alloc] initWithNibName:@"MemberInfoViewController" bundle:nil];
            [ConfigManager sharedInstance].strcustMobile = iphonefield.text;
            [ConfigManager sharedInstance].strcustName = namefield.text;
            [ConfigManager sharedInstance].strcheckCode = checkfield.text;
            
            
            [self.navigationController pushViewController:MemberInfoView animated:YES];
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
