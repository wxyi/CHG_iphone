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
    if (indexPath.row == 0 || indexPath.row == 1) {
        RegisteredMembersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RegisteredMembersCell.h"];
        if(cell==nil){
            cell = (RegisteredMembersCell*)[[self.RegisteredMembersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        if (indexPath.row == 0) {
            cell.namelab.text = @"手机号码:";
        }
        else
        {
            cell.namelab.text = @"会员姓名:";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nextBtn.frame = CGRectMake(6, 45, CGRectGetWidth(self.view.bounds)-12, 40);
        [nextBtn setBackgroundColor:[UIColor redColor]];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nextBtn];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 45;
    }
    return 85;
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
