//
//  LoginViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCell.h"

#import "ResetPasswordViewController.h"
#import "ForgotPasswordViewController.h"
@interface LoginViewController ()
@property UINib* LoginNib;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @""
    [self setupView];
}
-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.LoginNib = [UINib nibWithNibName:@"LoginCell" bundle:nil];
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
    LoginCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
    if(cell==nil){
        cell = (LoginCell*)[[self.LoginNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    
   
    
    cell.didSkipSubItem = ^(NSInteger tag){
        
        [weakSelf skipPage:tag];
    };
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 220)];
    v_header.backgroundColor = [UIColor whiteColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 75, 180, 70)];

    imageview.image = [UIImage imageNamed:@"logo.png"];
    [v_header addSubview:imageview];
    
    return v_header;
}

-(void)skipPage:(NSInteger)tag
{
    if (tag == 100) {
        DLog(@"登陆");
        ResetPasswordViewController *ResetPassword = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
        
        [self presentViewController:ResetPassword animated:YES completion:^{
            
        }];
    }
    else if(tag == 101)
    { 
        ForgotPasswordViewController *ForgotPasswordView = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
        
        [self presentViewController:ForgotPasswordView animated:YES completion:^{
            
        }];
        DLog(@"忘记密码");
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
