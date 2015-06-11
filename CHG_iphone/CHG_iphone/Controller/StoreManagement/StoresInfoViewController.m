//
//  StoresInfoViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoresInfoViewController.h"
#import "StoreManagementCell.h"
#import "StoresDetailsViewController.h"
#import "AddShoppersViewController.h"
#import "StoreManageCell.h"
#import "StoreCell.h"
#import "KGModal.h"
#import "QRCodeGenerator.h"
@interface StoresInfoViewController ()
@property UINib* StoreManagementNib;
@property UINib* StoreManageNib;
@property UINib* StoreNib;
@end

@implementation StoresInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"门店信息";
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.items = [[NSMutableArray alloc] init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.StoreManagementNib = [UINib nibWithNibName:@"StoreManagementCell" bundle:nil];
    self.StoreManageNib = [UINib nibWithNibName:@"StoreManageCell" bundle:nil];
    self.StoreNib = [UINib nibWithNibName:@"StoreCell" bundle:nil];
    
    [self httpGetShop];
    
    [self becomeFirstResponder];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            StoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StoreCell"];
            if(cell== nil){
                cell = (StoreCell*)[[self.StoreNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            cell.storeNameLab.text = self.shopinfo[@"shopName"];
            cell.storeAddresslab.text = self.shopinfo[@"shopAddress"];
            cell.didSkipSubItem =^(NSInteger tag){
                
                
                [self showQrCode:self.shopinfo[@"qrcUrl"]];
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
            
            
        }
        else
        {
            StoreManagementCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StoreManagementCell"];
            if(cell== nil){
                cell = (StoreManagementCell*)[[self.StoreManagementNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            cell.positionlab.text = @"门店老板";
            cell.nameAndIphonelab.text = [NSString stringWithFormat:@"%@ %@",self.shopinfo[@"owerName"],self.shopinfo[@"owerMobile"]];
            cell.didSkipSubItem =^(NSInteger tag){
                
                [self showQrCode:@"神仙小武子"];
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        
    }
    else
    {
        StoreManageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StoreManageCell"];
        if(cell== nil){
            cell = (StoreManageCell*)[[self.StoreManageNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }

        
        NSDictionary* dict = [self.items objectAtIndex:indexPath.section - 1];
        if ([[dict allKeys] containsObject:@"managerId"]) {
            cell.positionlab.text = @"店长";
            cell.nameAndIphonelab.text = [NSString stringWithFormat:@"%@ %@",dict[@"managerName"],dict[@"managerMobile"]];
            cell.icon.image = [UIImage imageNamed:@"icon_Shopowner.png"];
        }
        else{
            cell.positionlab.text = @"导购";
            cell.nameAndIphonelab.text = [NSString stringWithFormat:@"%@ %@",dict[@"sellerName"],dict[@"sellerMobile"]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.icon.image = [UIImage imageNamed:@"icon_shopping_guide.png"];
        }
        cell.Disablebtn.tag = [[NSString stringWithFormat:@"101%d",indexPath.section] intValue];
        cell.IndexPath = indexPath;
        cell.didselectDisable = ^(NSIndexPath* indexPath){
        
            [self httpSetSellerStatus:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }
        return 80;
    }
    return 115;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 5;
    }
    return 1;
}


-(void)httpGetShop
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetShop] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        self.shopinfo = [data objectForKey:@"shop"];
        [self.items removeAllObjects];
        if ([self.shopinfo [@"managerId"] intValue] != 0) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:self.shopinfo [@"managerId"] forKey:@"managerId"];
            [dict setObject:self.shopinfo [@"managerName"] forKey:@"managerName"];
            [dict setObject:self.shopinfo [@"managerMobile"] forKey:@"managerMobile"];
            [dict setObject:self.shopinfo [@"qrcUrl"] forKey:@"qrcUrl"];
            [self.items addObject:dict];
        }
        [self httpGetSellerList];
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismiss];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
-(void)httpGetSellerList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetSellerList] parameters:parameter];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        [MMProgressHUD dismiss];
//        self.shopinfo = [data objectForKey:@"shop"];
//        self.items = data;
        NSArray* datas = [data objectForKey:@"datas"];
        
        for (int i = 0; i< datas.count; i++) {
            [self.items addObject:[datas objectAtIndex:i]];
        }
        [self.tableview reloadData];
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
-(IBAction)addStoresInfo:(UIButton*)sender
{
    StorePersonnelType type;
    if (sender.tag == 100) {
        DLog(@"添加店长");
        type = StorePersonnelTypeManager;
    }
    else if(sender.tag == 101)
    {
        DLog(@"添加导购");
        type = StorePersonnelTypeShoppers;
    }
    
    AddShoppersViewController* AddShoppersView = [[AddShoppersViewController alloc] initWithNibName:@"AddShoppersViewController" bundle:nil];
    AddShoppersView.PersonnerType = type;
    [self.navigationController pushViewController:AddShoppersView animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&& indexPath.row == 0) {
        StoresDetailsViewController* StoresDetailsView = [[StoresDetailsViewController alloc] initWithNibName:@"StoresDetailsViewController" bundle:nil];
        [self.navigationController pushViewController:StoresDetailsView animated:YES];
    }
    
}
-(void)showQrCode:(NSString*)strqr
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UIImageView* image = [[UIImageView alloc] initWithFrame:contentView.frame];
    image.image = [QRCodeGenerator qrImageForString:strqr imageSize:contentView.bounds.size.width];
    [contentView addSubview:image];
    KGModal *modal = [KGModal sharedInstance];
    modal.showCloseButton = NO;
    [modal showWithContentView:contentView andAnimated:YES];
}

-(void)httpSetSellerStatus:(NSIndexPath*)indexpath
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];

    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiSetSellerStatus] parameters:parameter];
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    
    NSDictionary* dict = [self.items objectAtIndex:indexpath.section -1];
    NSString* sellerId;
    
    if ([[dict allKeys] containsObject:@"managerId"])  {
        sellerId = dict[@"managerId"];
    }
    else
    {
        sellerId = dict[@"sellerId"];
    }
    [param setObject:sellerId forKey:@"sellerId"];
    
    NSInteger tag = [[NSString stringWithFormat:@"101%d",indexpath.section] intValue];
    UIButton* btn = (UIButton*)[self.view viewWithTag:tag];
    NSString* status ;
    if (btn.selected) {
        status = @"0";
    }
    else
    {
        status = @"1";
    }
    [param setObject:status forKey:@"status"];
    
    DLog(@"url = %@",url);
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200)
        {
            NSInteger tag = [[NSString stringWithFormat:@"101%d",indexpath.section] intValue];
            UIButton* btn = (UIButton*)[self.view viewWithTag:tag];
            [btn setEnabled:NO];
            [btn setAlpha:0.4];
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
