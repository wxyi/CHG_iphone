//
//  MemberInfoViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "MembersRelationCell.h"
#import "MembersBirthdayCell.h"
#import "MembersSexCell.h"
#import "SuccessRegisterViewController.h"
@interface MemberInfoViewController ()
@property UINib* MembersRelationNib;
@property UINib* MembersBirthdayNib;
@property UINib* MembersSexNib;
@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
//    [NSObject setExtraCellLineHidden:self.tableview];
    self.MembersRelationNib = [UINib nibWithNibName:@"MembersRelationCell" bundle:nil];
    self.MembersBirthdayNib = [UINib nibWithNibName:@"MembersBirthdayCell" bundle:nil];
    self.MembersSexNib = [UINib nibWithNibName:@"MembersSexCell" bundle:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        MembersRelationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersRelationCell"];
        if(cell==nil){
            cell = (MembersRelationCell*)[[self.MembersRelationNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        MembersBirthdayCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersBirthdayCell"];
        if(cell==nil){
            cell = (MembersBirthdayCell*)[[self.MembersBirthdayNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MembersSexCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersSexCell"];
        if(cell==nil){
            cell = (MembersSexCell*)[[self.MembersSexNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 85;
    }
    else
    {
        return 165;
    }
}

-(IBAction)SubmitCompleted:(id)sender
{
    DLog(@"提交完成");
    SuccessRegisterViewController* SuccessRegisterView = [[SuccessRegisterViewController alloc] initWithNibName:@"SuccessRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:SuccessRegisterView animated:YES];
}
@end
