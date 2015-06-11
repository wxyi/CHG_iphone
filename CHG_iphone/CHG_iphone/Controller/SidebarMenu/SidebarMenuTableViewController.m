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
    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
//    self.tableView.opaque = NO;
    
    [NSObject setExtraCellLineHidden:self.tableView];
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        
        view.backgroundColor = UIColorFromRGB(0x171c61);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"神仙小武子";
        label.font = FONT(14);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
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
    else if (indexPath.row == 1) {
        DLog(@"银行卡");
        BankCardViewController* BankCardView = [[BankCardViewController alloc] initWithNibName:@"BankCardViewController" bundle:nil];
        [navigationController pushViewController:BankCardView animated:YES];
    }
    else if (indexPath.row == 2) {
        DLog(@"我的账户");
        MyAccountViewController* MyAccountView = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
//        navigationController.viewControllers = @[BasicInfo];
        [navigationController pushViewController:MyAccountView animated:YES];
    }
    else if (indexPath.row == 3) {
        DLog(@"设置");
        SettingViewController* SettingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [navigationController pushViewController:SettingView animated:YES];
    }

    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        DEMOHomeViewController *homeViewController = [[DEMOHomeViewController alloc] init];
//        navigationController.viewControllers = @[homeViewController];
//    } else {
//        DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
//        navigationController.viewControllers = @[secondViewController];
//    }
    
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
    NSArray *titles = @[@"基本信息", @"银行卡", @"我的账户", @"设置"];
    cell.textLabel.text = titles[indexPath.row];
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
