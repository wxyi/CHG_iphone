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

#import "HomePageViewController.h"
#import "CHGNavigationController.h"
#import "SidebarMenuTableViewController.h"
#import "REFrostedViewController.h"
#import "NSDownNetImage.h"
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
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    
    self.title = @"门店选择";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.ispush = NO;
}
-(void)setupView
{
    UserConfig* cfg = [[SUHelper sharedInstance] currentUserConfig];
    self.items = cfg.shopList;
    
//    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
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
    title.text = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"shopName"];
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
    NSString* deviceName = [ConfigManager sharedInstance].deviceName;
    CGFloat width;
    if ([deviceName isEqualToString:@"iPhone 4S"] || [deviceName isEqualToString:@"iPhone 4"])
    {
        width= 227.0;
    }
    else
    {
        width= (SCREEN_HEIGHT+ 64)* 0.4;
    }
    return width;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 230)];
    v_footer.backgroundColor = [UIColor clearColor];
    return v_footer;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString* deviceName = [ConfigManager sharedInstance].deviceName;
    CGFloat width;
    if ([deviceName isEqualToString:@"iPhone 4S"] || [deviceName isEqualToString:@"iPhone 4"])
    {
        width= 227.0;
    }
    else
    {
        width= (SCREEN_HEIGHT+ 64)* 0.4;
    }
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, width)];
    v_header.backgroundColor = [UIColor clearColor];
    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2, (width-112)/2, 130, 112)];
    
    imageview.image = [UIImage imageNamed:@"icon_logo_big"];
    [v_header addSubview:imageview];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, (width-112)/2 + CGRectGetHeight(imageview.frame) + 20, SCREEN_WIDTH, 20)];
    title.text = @"门店选择";
    title.textColor = UIColorFromRGB(0x171c61);
    title.font = FONT(14);
    title.textAlignment = NSTextAlignmentCenter;
    [v_header addSubview:title];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, (width-112)/2 + CGRectGetHeight(imageview.frame) + 40, SCREEN_WIDTH, 1)];
    line.image = [UIImage imageNamed:@"line_x"];
    [v_header addSubview:line];
    
    return v_header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.ispush) {
        self.ispush = YES;
    
        [ConfigManager sharedInstance].shopId = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"shopId"];
        [ConfigManager sharedInstance].strdimensionalCodeUrl = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"dimensionalCodeUrl"] ;
        
        [NSDownNetImage deleteFile];
        [self DownStoreQrCode];
        
        [ConfigManager sharedInstance].strStoreName = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"shopName"] ;
        DLog(@"shopId= %@",[ConfigManager sharedInstance].shopId);
        //    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [self setupHomePageViewController];
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
-(void)setupHomePageViewController
{
    CHGNavigationController *navigationController = [[CHGNavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
    
    SidebarMenuTableViewController *SidebarMenu = [[SidebarMenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:SidebarMenu];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.limitMenuViewSize = YES;
    
    [self presentViewController:frostedViewController animated:YES completion:^{
        [MMProgressHUD dismiss];
    }];
}

-(void)DownStoreQrCode
{
    [HttpClient asynchronousDownLoadFileWithProgress:[ConfigManager sharedInstance].strdimensionalCodeUrl parameters:nil successBlock:^(NSURL *filePath) {
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        UIImage * imageFromURL = [UIImage imageWithData:data];
        [NSDownNetImage saveImage:imageFromURL withFileName:@"StoreQrCode" ofType:@"jpg" inDirectory:APPDocumentsDirectory];
        
        
        NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:APPDocumentsDirectory];
        NSLog(@"%@",file);
        
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        DLog(@"下载失败error = %@",description);
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
