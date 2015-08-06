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
#import "NSDownNetImage.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设置";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.items = [NSArray arrayWithObjects:@"账户与安全",/*@"版本更新",*/@"关于我们", nil];
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    
    [self httpVersionUpdate];
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
    title.text = [self.items objectAtIndexSafe:indexPath.row];
    [cell.contentView addSubview:title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    if (indexPath.row == 1) {
//        
//        
//        NSString* appVersion = [self.dict objectForKeySafe: @"appVersion"];
//        if (![[ConfigManager sharedInstance].sysVersion isEqualToString:appVersion] && appVersion.length != 0) {
//            UILabel* textlab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 90, 40)];
//            textlab.text = @"有新版本可用";
//            textlab.font = FONT(15);
//            textlab.textColor = UIColorFromRGB(0x878787);
//            [cell.contentView addSubview:textlab];
//            NIBadgeView* badgeView2 = [[NIBadgeView alloc] initWithFrame:CGRectZero];
//            //        badgeView2.backgroundColor = UIColorFromRGB(0xf0f0f0);
//            badgeView2.backgroundColor = [UIColor clearColor];
//            //        badgeView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"checkversion_bg.png"] ];
//            badgeView2.text = @"new";
//            badgeView2.tintColor = [UIColor clearColor];
//            
//            badgeView2.textColor = [UIColor whiteColor];
//            [badgeView2 sizeToFit];
//            badgeView2.frame = CGRectMake(SCREEN_WIDTH-120-badgeView2.frame.size.width , 7, badgeView2.frame.size.width, badgeView2.frame.size.height);
//            
//            
//            
//            
//            UIImageView * bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120-badgeView2.frame.size.width , 7, badgeView2.frame.size.width, badgeView2.frame.size.height)];
//            bgImage.image = [UIImage imageNamed:@"checkversion_bg.png"];
//            [cell.contentView addSubview:bgImage];
//            [cell.contentView addSubview:badgeView2];
//        }
//        
//    }
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
//    else if (indexPath.row == 1)
//    {
//        NSString* url = [self.dict objectForKeySafe:@"url"];
//        NSString *str = [url substringToIndex:url.length -2];
//        
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,@"1019667891"]]];
////        if (![[ConfigManager sharedInstance].sysVersion isEqualToString:appVersion])
////        {
////            VersionUpdateViewController* VersionUpdateView = [[VersionUpdateViewController alloc] initWithNibName:@"VersionUpdateViewController" bundle:nil];
////            VersionUpdateView.items = self.dict;
////            [self.navigationController pushViewController:VersionUpdateView animated:YES];
////        }
//        
//        
//    }
    else
    {
        AboutViewController* AboutView = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:AboutView animated:YES];
    }
}
-(void)loginout
{
    DLog(@"退出账号");
    self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定退出登陆?" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
        DLog(@"否");
        
        [NSDownNetImage deleteFile];
        [ConfigManager sharedInstance].access_token = @"";
        [ConfigManager sharedInstance].refresh_token = @"";
        LoginViewController* loginview = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self presentViewController:loginview animated:YES completion:^{
            
        }];
    } otherButtonBlock:^{
        DLog(@"是");
        
    }];

    [self.stAlertView show];
}

-(void)httpVersionUpdate
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCheckVersion] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafe:@"IOS" forKey:@"appType"];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@" data = %@",data );
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"] intValue]==200){
//            if (![[ConfigManager sharedInstance].sysVersion isEqualToString:[[data objectForKeySafe:@"datas"] objectForKeySafe: @"appVersion"]]) {
//                
//            }
            self.dict =[data objectForKeySafe:@"datas"];
            [self.tableview reloadData];
            
        }
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpVersionUpdate];
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
