//
//  StopViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StopViewController.h"
#import "StoreManagementViewController.h"
#import "StoresInfoViewController.h"
@interface StopViewController ()

@end

@implementation StopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店管理";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    if ([config.Roles isEqualToString:@"SHOP_OWNER"]&& config.shopList.count > 1)
    {
        self.items = [NSArray arrayWithObjects:@"门店切换",@"店员管理", nil];
    }
    else if ([config.Roles isEqualToString:@"SHOPLEADER"]||(
             [config.Roles isEqualToString:@"SHOP_OWNER"]&& config.shopList.count == 1))
    {
        self.items = [NSArray arrayWithObjects:@"店员管理", nil];
    }
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.tableview.scrollEnabled = NO;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    if ([config.Roles isEqualToString:@"SHOP_OWNER"]&& config.shopList.count > 1)
    {
        if (indexPath.row == 0) {
            DLog(@"门店切换");
            StoreManagementViewController* StoreManagementView = [[StoreManagementViewController alloc] initWithNibName:@"StoreManagementViewController" bundle:nil];
            [self.navigationController pushViewController:StoreManagementView animated:YES];
        }
        else if(indexPath.row == 1)
        {
            DLog(@"店员管理");
            StoresInfoViewController* StoresInfoView = [[StoresInfoViewController alloc] initWithNibName:@"StoresInfoViewController" bundle:nil];
            [self.navigationController pushViewController:StoresInfoView animated:YES];
        }
    }
    else
    {
        DLog(@"店员管理");
        StoresInfoViewController* StoresInfoView = [[StoresInfoViewController alloc] initWithNibName:@"StoresInfoViewController" bundle:nil];
        [self.navigationController pushViewController:StoresInfoView animated:YES];
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
