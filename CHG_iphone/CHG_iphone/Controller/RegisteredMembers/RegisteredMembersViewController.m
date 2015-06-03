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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisteredMembersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RegisteredMembersCell.h"];
    if(cell==nil){
        cell = (RegisteredMembersCell*)[[self.RegisteredMembersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    
    cell.Verification.hidden = YES;
    if (indexPath.row == 0) {
        cell.namelab.text = @"手机号码:";
    }
    else if(indexPath.row == 1)
    {
        cell.namelab.text = @"会员姓名:";
    }
    else
    {
        cell.namelab.text = @"验证码:";
        cell.textField.frame = CGRectMake(90, 0, SCREEN_WIDTH - 210, 45);
        cell.Verification.hidden = NO;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
    [nextBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
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
    MemberInfoViewController* MemberInfoView= [[MemberInfoViewController alloc] initWithNibName:@"MemberInfoViewController" bundle:nil];
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
