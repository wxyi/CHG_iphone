//
//  SettingViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SettingViewController.h"
#import "NimbusBadge.h"
#import "AccountAndSecurityViewController.h"
#import "VersionUpdateViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设置";
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.items = [NSArray arrayWithObjects:@"账户与安全",@"检测新版本",@"关于我们", nil],
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 1) {
        NIBadgeView* badgeView2 = [[NIBadgeView alloc] initWithFrame:CGRectZero];
        badgeView2.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        badgeView2.text = [NSString stringWithFormat:@"%@",[ConfigManager sharedInstance].sysVersion];
        badgeView2.tintColor = [UIColor orangeColor];
        badgeView2.textColor = [UIColor whiteColor];
        [badgeView2 sizeToFit];
        badgeView2.frame = CGRectMake(SCREEN_WIDTH-badgeView2.frame.size.width -30, 10, badgeView2.frame.size.width, badgeView2.frame.size.height);
        [cell.contentView addSubview:badgeView2];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* loginout = [UIButton buttonWithType:UIButtonTypeCustom];
    loginout.backgroundColor = UIColorFromRGB(0xce2028);
    [loginout.layer setMasksToBounds:YES];
    [loginout.layer setCornerRadius:4]; //设置矩形四个圆角半径
//    [loginout.layer setBorderWidth:1.0]; //边框
    loginout.frame = CGRectMake(5, 40, SCREEN_WIDTH-10 , 40);
    [loginout setTitle:@"退出" forState:UIControlStateNormal];
    [loginout setTitleColor:UIColorFromRGB(0xf0f0f0) forState:UIControlStateNormal];
    [loginout addTarget:self action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:loginout];
    return v_footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AccountAndSecurityViewController* AccountAndSecurityView= [[AccountAndSecurityViewController alloc] initWithNibName:@"AccountAndSecurityViewController" bundle:nil];
        [self.navigationController pushViewController:AccountAndSecurityView animated:YES];
    }
    else if (indexPath.row == 1)
    {
        VersionUpdateViewController* VersionUpdateView = [[VersionUpdateViewController alloc] initWithNibName:@"VersionUpdateViewController" bundle:nil];
        [self.navigationController pushViewController:VersionUpdateView animated:YES];
    }
    else if(indexPath.row == 2)
    {
        AboutViewController* AboutView = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:AboutView animated:YES];
    }
}
-(void)loginout
{
    DLog(@"退出账号");
    [ConfigManager sharedInstance].access_token = @"";
    LoginViewController* loginview = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [self presentViewController:loginview animated:YES completion:^{
       
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
