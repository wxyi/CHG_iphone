//
//  SidebarMenuTableViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/21.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SidebarMenuTableViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "BasicInfoViewController.h"
#import "BankCardViewController.h"
#import "MyAccountViewController.h"
#import "SettingViewController.h"
#import "KGModal.h"
@interface SidebarMenuTableViewController ()

@end

@implementation SidebarMenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.backgroundColor = UIColorFromRGB(0xdddddd);
    
   // self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.tableView.opaque = NO;
    self.config = [[SUHelper sharedInstance] currentUserConfig];
    [NSObject setExtraCellLineHidden:self.tableView];
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        
        view.backgroundColor = UIColorFromRGB(0x171c61);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 100, 60)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"icon_chg_logo.png"];
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        
//        UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
//        if (![self.config.Roles isEqualToString:@"PARTNER"])
        {
            UIButton *Scanbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 95, 72, 72)];
            Scanbtn.backgroundColor = [UIColor clearColor];
            Scanbtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            NSString *newstr =[NSString stringWithFormat:@"%@/%@",APPDocumentsDirectory,@"StoreQrCode.jpg"] ;
            NSLog(@"完整路径是:%@",newstr);
            
            [Scanbtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:newstr]] forState:UIControlStateNormal];
            Scanbtn.layer.rasterizationScale = [UIScreen mainScreen].scale;
            Scanbtn.layer.shouldRasterize = YES;
            Scanbtn.clipsToBounds = YES;
            [Scanbtn addTarget:self action:@selector(showQrCode)
              forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:Scanbtn];
        }
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
//        UserConfig *cfg = [[SUHelper sharedInstance] currentUserConfig];
//        label.text = cfg.strUsername;
//        label.font = FONT(14);
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor whiteColor];
//        [label sizeToFit];
//        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
        
        
        view;
    });
}
-(void)showQrCode
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UIImageView* image = [[UIImageView alloc] initWithFrame:contentView.frame];
    NSString *newstr =[NSString stringWithFormat:@"%@/%@",APPDocumentsDirectory,@"StoreQrCode.jpg"] ;
    NSLog(@"完整路径是:%@",newstr);
    image.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:newstr]];
    [contentView addSubview:image];
    KGModal *modal = [KGModal sharedInstance];
    modal.showCloseButton = NO;
    [modal showWithContentView:contentView andAnimated:YES];
}
#pragma mark -
#pragma mark UITableView Delegate







- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    if (indexPath.row == 0) {
        DLog(@"基本信息");
        BasicInfoViewController* BasicInfo = [[BasicInfoViewController alloc] initWithNibName:@"BasicInfoViewController" bundle:nil];
        [navigationController pushViewController:BasicInfo animated:YES];
    }
    else if (indexPath.row == 1 &&![self.config.Roles isEqualToString:@"SHOPSELLER"]&&![self.config.Roles isEqualToString:@"SHOPLEADER"]) {
        DLog(@"银行卡");
        BankCardViewController* BankCardView = [[BankCardViewController alloc] initWithNibName:@"BankCardViewController" bundle:nil];
        [navigationController pushViewController:BankCardView animated:YES];
    }
    else if (indexPath.row == 2&& ![self.config.Roles isEqualToString:@"SHOPSELLER"]&&![self.config.Roles isEqualToString:@"SHOPLEADER"]) {
        DLog(@"我的账户");
        MyAccountViewController* MyAccountView = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
//        navigationController.viewControllers = @[BasicInfo];
        [navigationController pushViewController:MyAccountView animated:YES];
    }
    else {
        DLog(@"设置");
        SettingViewController* SettingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [navigationController pushViewController:SettingView animated:YES];
    }

    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if ([self.config.Roles isEqualToString:@"SHOPSELLER"]||[self.config.Roles isEqualToString:@"SHOPLEADER"]){
        return 2;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
    NSArray *titles;
    if ([self.config.Roles isEqualToString:@"SHOPSELLER"]||[self.config.Roles isEqualToString:@"SHOPLEADER"]){
        titles = @[@"我的信息", @"设置"];
    }
    else
    {
        titles = @[@"我的信息", @"银行卡", @"我的账户", @"设置"];
    }
    cell.textLabel.text = [titles objectAtIndexSafe: indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x646464);
    cell.textLabel.font = FONT(16);
    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}

@end
