//
//  ResetPasswordViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordCell.h"
#import "StoreManagementViewController.h"
@interface ResetPasswordViewController ()
@property UINib* ResetPasswordNib;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
//    self.tableview.backgroundColor = [UIColor whiteColor];
    self.ResetPasswordNib = [UINib nibWithNibName:@"ResetPasswordCell" bundle:nil];
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
    ResetPasswordCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ResetPasswordCell"];
    if(cell==nil){
        cell = (ResetPasswordCell*)[[self.ResetPasswordNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
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
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 75, 180, 70)];
    
    imageview.image = [UIImage imageNamed:@"logo.png"];
    [v_header addSubview:imageview];
    
    return v_header;
}

-(void)skipPage:(NSInteger)tag
{
    if (tag == 100) {
        UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
        [passfield1 resignFirstResponder];
        UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1012];
        [passfield2 resignFirstResponder];
        DLog(@"确认修改");
        [self ConfirmTheChange];
        
    }
    
}

-(void)ConfirmTheChange
{
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    UITextField* passfield2 = (UITextField*)[self.view viewWithTag:1012];
    NSString* info ;
    if (passfield1.text.length == 0) {
        info = @"请输入密码";
    }
    else if (passfield1.text.length < 6)
    {
        info = @"密码必须大于6位";
    }
    else if(passfield2.text.length == 0)
    {
        info = @"请确认密码";
    }
    else if (![passfield1.text isEqualToString:passfield2.text])
    {
        info = @"密码输入不一致";
    }
    
    if (info.length != 0) {
    
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    else
    {
        [self httpResetPassWord];
    }
    
    
}
-(void)httpResetPassWord
{
    UITextField* passfield1 = (UITextField*)[self.view viewWithTag:1011];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"924051" forKey:@"checkCode"];
    [parameter setObject:[NSObject md5:passfield1.text] forKey:@"newpwd"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"100861" forKey:@"checkCode"];
    [param setObject:[[NSObject md5:passfield1.text] uppercaseString] forKey:@"newpwd"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiResetPassword] parameters:parameter];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,msg);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
            if ([config.Roles isEqualToString:@"SHOP_OWNER"]) {
                
                
                StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
                [self presentViewController:StoreManagementView animated:YES completion:^{
                    
                }];
            }
            else
            {

                AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                [delegate setupHomePageViewController];
            }
        }
        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
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
