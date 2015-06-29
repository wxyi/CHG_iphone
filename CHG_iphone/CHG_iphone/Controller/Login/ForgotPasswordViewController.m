//
//  ForgotPasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordCell.h"
#import "ResetPasswordViewController.h"
@interface ForgotPasswordViewController ()
@property UINib* ForgotPasswordNib;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = [UIColor whiteColor];
    self.ForgotPasswordNib = [UINib nibWithNibName:@"ForgotPasswordCell" bundle:nil];
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
    ForgotPasswordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ForgotPasswordCell"];
    if(cell==nil){
        cell = (ForgotPasswordCell*)[[self.ForgotPasswordNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    cell.userField.text = self.strmobile;
    
    cell.didSkipSubItem = ^(NSInteger tag){
        
        [weakSelf skipPage:tag];
    };
    cell.didGetCode = ^(NSString* checkcode)
    {
        weakSelf.strCheckCode = checkcode;
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
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 75, 180, 112)];
    
    imageview.image = [UIImage imageNamed:@"icon_logo_big.png"];
    [v_header addSubview:imageview];
    
    return v_header;
}

-(void)skipPage:(NSInteger)tag
{
    if (tag == 100) {
        DLog(@"点击获取");
//        [self httpGetCheckCode];
    }
    else if(tag == 101)
    {
        DLog(@"下一步");
//        SetPasswordViewController *SetPasswordView = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
//        
//        [self presentViewController:SetPasswordView animated:YES completion:^{
//            
//        }];
        [self LoginAccount];
    }
    
}
-(void)LoginAccount
{
    UITextField* namefield = (UITextField*)[self.view viewWithTag:1011];
    [namefield resignFirstResponder];
    UITextField* checkcodefield = (UITextField*)[self.view viewWithTag:1012];
    [checkcodefield resignFirstResponder];
    NSString* info ;
    if (namefield.text.length == 0) {
        info = @"请输入手机号码";
    }
    else if (![IdentifierValidator isValid:IdentifierTypePhone value:namefield.text ])
    {
        info = @"手机格式不正确";
    }
    else if(checkcodefield.text.length == 0)
    {
        info = @"请输入验证码";
    }
    else if (checkcodefield.text.length > 6)
    {
        info = @"验证码不能大于6位";
    }
    else if ([checkcodefield.text intValue] != [self.strCheckCode intValue])
    {
        info = @"验证码不正确";
    }

    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }

    ResetPasswordViewController *ResetPassword = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    ResetPassword.strmobile = namefield.text;
    ResetPassword.strcheckCode = checkcodefield.text;
    [self presentViewController:ResetPassword animated:YES completion:^{
        
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
