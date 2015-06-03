//
//  ChangePasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ForgetViewController.h"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
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
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
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
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
//    [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    textField.placeholder = [self.items objectAtIndex:indexPath.row]; //默认显示的字
    
    textField.secureTextEntry = YES; //密码
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [cell.contentView addSubview:textField];
    
    
    if (indexPath.row == 0) {
        UIButton* forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetbtn.layer setMasksToBounds:YES];
        forgetbtn.tag = 100;
        forgetbtn.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 40);
        [forgetbtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [forgetbtn addTarget:self action:@selector(ChangePassword:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:forgetbtn];

        textField.frame = CGRectMake(90, 2, SCREEN_WIDTH -180, 40);
    }
    else
    {
        textField.frame = CGRectMake(90, 2, SCREEN_WIDTH -90, 40);
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
    [changebtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
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
