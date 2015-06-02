//
//  ForgetViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
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
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
    //    [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    textField.placeholder = @"动态验证码"; //默认显示的字
    
    textField.secureTextEntry = YES; //密码
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [cell.contentView addSubview:textField];
    
    UIButton* forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetbtn.layer setMasksToBounds:YES];
    forgetbtn.tag = 100;
    forgetbtn.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 40);
    [forgetbtn setTitle:@"再次发送" forState:UIControlStateNormal];
    [forgetbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetbtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:forgetbtn];

    
    
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
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"手机号码 %@",@"13382050875"];
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* confirmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmbtn.tag = 101;
    confirmbtn.backgroundColor = [UIColor brownColor];
    [confirmbtn.layer setMasksToBounds:YES];
    [confirmbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
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
    if (sender.tag == 100) {
        DLog(@"在次发送")
    }
    else if (sender.tag == 101)
    {
        DLog(@"确认");
    }
    
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
