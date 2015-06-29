//
//  DidNotPickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "DidNotPickGoodsViewController.h"
#import "AllOrdersCell.h"
#import "OrderAmountCell.h"
#import "OrdersGoodsCell.h"

@interface DidNotPickGoodsViewController ()
@property UINib* AllOrdersNib;
@property UINib* OrderAmountNib;
@property UINib* OrdersGoodsNib;
@end

@implementation DidNotPickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未提货";
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    
    if ([self.items allKeys] == 0) {
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithTitle:@"" status:@""];
        [self httpGetOrder];
    }
    
}

-(void)setupView
{

//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 80;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
//    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
    self.Pickupbtn.frame = CGRectMake(0, SCREEN_WIDTH -80, SCREEN_WIDTH/2, 40);
    self.Terminationbtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_WIDTH -80, SCREEN_WIDTH/2, 40);
    if (self.ManagementTyep == OrderManagementTypeAll) {
//        CGRect rect = self.tableview.frame;
//        rect.size.height = rect.size.height + 40;
//        self.tableview.frame = rect;
        self.Pickupbtn.hidden = YES;
        self.Terminationbtn.hidden = YES;
        self.line.hidden = YES;
    }
//    rect = self.Pickupbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 80;
//    rect.size.width = SCREEN_WIDTH/2;
//    self.Pickupbtn.frame = rect;
//    
//    rect = self.Terminationbtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 80;
//    rect.size.width = SCREEN_WIDTH/2;
//    self.Terminationbtn.frame = rect;
    
    [self setupRefresh];
}
-(IBAction)orderProcessing:(UIButton*)sender
{
    
    if (self.BtnSkipSelect) {
        self.BtnSkipSelect(sender.tag,self.items);
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
//        if(cell==nil){
//            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        NSDictionary* dict =  [[self.items objectForKey:@"productList"] objectAtIndex:indexPath.row] ;
//        
//        [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
//        cell.titlelab.text = dict[@"productName"];
//        cell.pricelab.text = dict[@"productPrice"];;
//        cell.countlab.text = [dict objectForKey:@"count"];
//
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.picktype = PickUpTypeDidNot;
       
        cell.height = self.m_height;
        [cell setupAllOrderView:self.items];
        cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
            if (self.didSelectedSubItemAction) {
                self.didSelectedSubItemAction(indexPath);
            }
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
        if(cell==nil){
            cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
       
        cell.receivablelab.text =[NSString stringWithFormat:@"%.2f", [self.items[@"orderAmount"] doubleValue]];
        cell.Receivedlab.text = [NSString stringWithFormat:@"%.2f", [self.items[@"orderFactAmount"] doubleValue]];
        [cell.Receivedlab setEnabled:NO];
        cell.favorablelab.text = [NSString stringWithFormat:@"%.2f", [self.items[@"orderDiscount"] doubleValue]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.m_height;
    }
    else if(indexPath.section == 1)
    {
        return 90;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section != 0) {
//        return nil;
//    }
//    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
//    //    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    v_header.backgroundColor = [UIColor clearColor];
//    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//    line.backgroundColor = UIColorFromRGB(0xdddddd);
//    [v_header addSubview:line];
//    
//    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
//    datelab.textAlignment = NSTextAlignmentLeft;
//    datelab.font = FONT(13);
//    datelab.textColor = UIColorFromRGB(0x878787);;
//    datelab.text = @"未提商品";
//    [v_header addSubview:datelab];
//    
//    
//    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
//    orderstatus.textAlignment = NSTextAlignmentRight;
//    orderstatus.font = FONT(13);
//    orderstatus.textColor = UIColorFromRGB(0x878787);;
//    orderstatus.text = @"制单人:武新义(导购)";
//    [v_header addSubview:orderstatus];
//    
//    return v_header;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
////        v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        v_footer.backgroundColor = [UIColor clearColor];
//        UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//        goodscountlab.text = @" 共3件商品";
//        goodscountlab.font = FONT(13);
////        goodscountlab.textColor = UIColorFromRGB(<#rgbValue#>)
//        goodscountlab.textAlignment = NSTextAlignmentLeft;
//        [v_footer addSubview:goodscountlab];
//        
//        return v_footer;
//    }
//    return nil;
//    
//}
-(void)httpGetOrder
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];

    [parameter setObject:self.strOrderId forKey:@"orderId"];

    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrder] parameters:parameter];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@,msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
            self.items = [data objectForKey:@"order"];
            self.m_height = ([[self.items objectForKey:@"productList"] count] + 1)*65 - 5;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
        }
        else
        {
            [self.tableview.header endRefreshing];
//            [MMProgressHUD dismissWithError:msg];
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
                     vertical:0.5];
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
- (void)setupRefresh
{
//    __weak __typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
//    [header beginRefreshing];
    
    // 设置header
    self.tableview.header = header;
    
   
}
#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        
        
        [self httpGetOrder];
        
//        [self.tableview.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据


@end
