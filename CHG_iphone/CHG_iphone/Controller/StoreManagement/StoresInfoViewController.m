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
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
//    if (self.items.count == 0)
    {
        [self httpGetShop];
    }
    
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
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.StoreManagementNib = [UINib nibWithNibName:@"StoreManagementCell" bundle:nil];
    self.StoreManageNib = [UINib nibWithNibName:@"StoreManageCell" bundle:nil];
    self.StoreNib = [UINib nibWithNibName:@"StoreCell" bundle:nil];
    
//    rect = self.addbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    rect.size.width = (SCREEN_WIDTH -30)/2;
//    self.addbtn.frame = rect;
    
//    rect = self.addshopperbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    rect.size.width = (SCREEN_WIDTH -30)/2;
//    self.addshopperbtn.frame = rect;
    
    
    
    [self becomeFirstResponder];
    
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    if ([config.Roles isEqualToString:@"SHOPLEADER"])
    {
        self.addbtn.userInteractionEnabled=NO;
        self.addbtn.alpha=0.4;
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.items.count == 0) {
            return 1;
        }
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
                
                
                [self showQrCode:self.shopinfo[@"dimensionalCodeUrl"]];
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
            NSDictionary* dict = [self.items objectAtIndex:indexPath.section ];
            cell.positionlab.text = @"门店老板";
            cell.nameAndIphonelab.text = [NSString stringWithFormat:@"%@ %@",dict[@"sellerName"],dict[@"sellerMobile"]];
            cell.didSkipSubItem =^(NSInteger tag){
                
                [self showQrCode:self.shopinfo[@"dimensionalCodeUrl"]];
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

        
        NSDictionary* dict = [self.items objectAtIndex:indexPath.section ];
        if ([dict[@"positionId"] intValue] == 2) {
            cell.positionlab.text = @"店长";
            
            cell.icon.image = [UIImage imageNamed:@"icon_Shopowner.png"];
        }
        else{
            cell.positionlab.text = @"导购";
            cell.icon.image = [UIImage imageNamed:@"icon_shopping_guide.png"];
        }
        cell.nameAndIphonelab.text = [NSString stringWithFormat:@"%@ %@",dict[@"sellerName"],dict[@"sellerMobile"]];
        cell.Disablebtn.tag = [[NSString stringWithFormat:@"101%ld",(long)indexPath.section] intValue];
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
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        if (success) {
            [MMProgressHUD dismiss];
            self.shopinfo = [data objectForKey:@"shop"];
            [self.items removeAllObjects];
            
            [self httpGetSellerList];
        }
        else
        {
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismiss];
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
-(void)httpGetSellerList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetSellerList] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
//        [MMProgressHUD dismiss];
//        self.shopinfo = [data objectForKey:@"shop"];
//        self.items = data;
        if (success) {
            [MMProgressHUD dismiss];
            NSArray* datas = [data objectForKey:@"datas"];
            
            NSDictionary* boss;
            NSDictionary* manager;
            for (int i = 0; i < datas.count; i ++) {
                DLog(@"%d",[[datas[i] objectForKey:@"positionId"] intValue]);
                if ([[datas[i] objectForKey:@"positionId"] intValue] == 0) {
                    boss = datas[i];
                }
                else if ([[datas[i] objectForKey:@"positionId"] intValue] == 2)
                {
                    manager = datas[i];
                }
                else
                {
                    [self.items addObject:datas[i]];
                }
                
            }
            if ([[boss allKeys] count] != 0) {
                [self.items insertObject:boss atIndex:0];
            }
            
            if ([[manager allKeys] count] != 0) {
                
                [self.items insertObject:manager atIndex:1];
                self.addbtn.userInteractionEnabled=NO;
                self.addbtn.alpha=0.4;
            }
            else
            {
                self.addbtn.userInteractionEnabled=YES;
                self.addbtn.alpha=1;
//                self.addbtn.alpha=0.4;
            }
            
            
            DLog(@"self.items = %@",self.items);
            [self.tableview reloadData];
        }
        else
        {
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
-(IBAction)addStoresInfo:(UIButton*)sender
{
    StorePersonnelType type;
    NSString* info;
    if (sender.tag == 100) {
        DLog(@"添加店长");
        info = @"添加店长";
        type = StorePersonnelTypeManager;
    }
    else if(sender.tag == 101)
    {
        DLog(@"添加导购");
        info = @"添加导购";
        type = StorePersonnelTypeShoppers;
    }
    
    self.stAlertView = [[STAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否%@" ,info] message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
        DLog(@"否");
        
        
    } otherButtonBlock:^{
        DLog(@"是");
        AddShoppersViewController* AddShoppersView = [[AddShoppersViewController alloc] initWithNibName:@"AddShoppersViewController" bundle:nil];
        AddShoppersView.PersonnerType = type;
        [self.navigationController pushViewController:AddShoppersView animated:YES];
    }];
    
    [self.stAlertView show];
   
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&& indexPath.row == 0) {
        StoresDetailsViewController* StoresDetailsView = [[StoresDetailsViewController alloc] initWithNibName:@"StoresDetailsViewController" bundle:nil];
        StoresDetailsView.storesDict = self.shopinfo;
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
    
    NSDictionary* dict = [self.items objectAtIndex:indexpath.section ];
    
    
    
    [param setObject:dict[@"sellerId"] forKey:@"sellerId"];
    
    NSInteger tag = [[NSString stringWithFormat:@"101%d",indexpath.section] intValue];
    
    
    DLog(@"url = %@",url);
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@",data);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200)
        {
            
            [MMProgressHUD dismiss];
            [self.items removeAllObjects];
            [self httpGetSellerList];
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
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
