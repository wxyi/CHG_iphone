//
//  StoreManagementViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/26.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreManagementViewController.h"
#import "DropDownListView.h"
#import "StoresInfoViewController.h"
@interface StoreManagementViewController (){
    NSMutableArray *chooseArray ;
}

@end

@implementation StoreManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    DLog(@"self.navigationController.navigationBarHidden = %d",self.navigationController.navigationBarHidden);
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
    UserConfig* cfg = [[SUHelper sharedInstance] currentUserConfig];
    self.items = cfg.shopList;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.backgroundColor = UIColorFromRGB(0xdddddd);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

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
//    cell.backgroundColor = UIColorFromRGB(0xdddddd);
    cell.backgroundColor = [UIColor clearColor];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 10, 200, 35)];
    title.backgroundColor = UIColorFromRGB(0x171c61);
    title.textColor = UIColorFromRGB(0xf0f0f0);
    title.layer.cornerRadius = 4;
    [title.layer setMasksToBounds:YES];
    title.font = FONT(14);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"shopName"];
    [cell.contentView addSubview:title];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 230;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 230)];
    v_footer.backgroundColor = [UIColor clearColor];
    return v_footer;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 230)];
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-135)/2, 60, 180, 112)];
    
    imageview.image = [UIImage imageNamed:@"icon_logo_big"];
    [v_header addSubview:imageview];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 20)];
    title.text = @"门店选择";
    title.textColor = UIColorFromRGB(0x171c61);
    title.font = FONT(14);
    title.textAlignment = NSTextAlignmentCenter;
    [v_header addSubview:title];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 205, SCREEN_WIDTH-20, 1)];
    line.image = [UIImage imageNamed:@"line_x"];
    [v_header addSubview:line];
    
    return v_header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ConfigManager sharedInstance].shopId = [[self.items objectAtIndex:indexPath.row] objectForKey:@"shopId"];
    [ConfigManager sharedInstance].strdimensionalCodeUrl = [[self.items objectAtIndex:indexPath.row] objectForKey:@"dimensionalCodeUrl"] ;
    [ConfigManager sharedInstance].strStoreName = [[self.items objectAtIndex:indexPath.row] objectForKey:@"shopName"] ;
    DLog(@"shopId= %@",[ConfigManager sharedInstance].shopId);
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate setupHomePageViewController];
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
