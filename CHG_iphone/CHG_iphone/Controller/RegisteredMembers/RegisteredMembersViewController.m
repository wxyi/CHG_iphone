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
        cell = (RegisteredMembersCell*)[[self.RegisteredMembersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    cell.iphoneField.text = self.strIphone;
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
    NSString* info ;
    if (iphonefield.text.length == 0) {
        info = @"请输入手机号码";
    }
    else if (![IdentifierValidator isValid:IdentifierTypePhone value:iphonefield.text ])
    {
        info = @"手机格式不正确";
    }
    else if(namefield.text.length == 0)
    {
        info = @"请输入姓名";
    }
    else if (checkfield.text.length == 0)
    {
        info = @"请输入验证码";
    }
    else if (checkfield.text.length > 6)
    {
        info = @"验证码不能大于6位";
    }
    else if(![checkfield.text isEqualToString:self.strCheckCode])
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
    
    
    
    MemberInfoViewController* MemberInfoView= [[MemberInfoViewController alloc] initWithNibName:@"MemberInfoViewController" bundle:nil];
    [ConfigManager sharedInstance].strcustMobile = iphonefield.text;
    [ConfigManager sharedInstance].strcustName = namefield.text;
    [ConfigManager sharedInstance].strcheckCode = checkfield.text;
    
    
    [self.navigationController pushViewController:MemberInfoView animated:YES];
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
