//
//  AllOrdersViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AllOrdersViewController.h"
//#import "AllOrdersCell.h"
#import "GoodsDetailsViewController.h"
#import "OrdersGoodsCell.h"
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
@interface AllOrdersViewController ()
//@property UINib* AllOrdersNib;
@property UINib* OrdersGoodsNib;
@end

@implementation AllOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部订单";

    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    // Do any additional setup after loading the view from its nib.
//    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    [self httpGetAllOrderList];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.items objectAtIndex:section] objectForKey:@"productList"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
    if(cell==nil){
        cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }

    NSArray* array = [[self.items objectAtIndex:indexPath.section] objectForKey:@"productList"];
    NSDictionary* dict = [array objectAtIndex:indexPath.row];
    
    [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
    cell.titlelab.text = dict[@"productName"];
    cell.pricelab.text = dict[@"productPrice"];;
    cell.countlab.text = [NSString stringWithFormat:@"x %d",[[dict objectForKey:@"quantity"] intValue] ];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
//    AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
//    if(cell==nil){
//        cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//        
//    }
//    cell.height = 360;
//    [cell setupView:nil];
//    cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
//        if (self.didSelectedSubItemAction) {
//            self.didSelectedSubItemAction(indexPath);
//        }
//    };
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    //    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_header.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_header addSubview:line];
    
    NSDictionary* dict = [self.items objectAtIndex:section] ;
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = UIColorFromRGB(0x878787);;
    datelab.text = dict[@"orderDate"];
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = UIColorFromRGB(0x878787);
    NSString* statue;
    if ([dict[@"orderStatus"] intValue] == 1)
        statue = @"已完成";
    else if ([dict[@"orderStatus"] intValue] == 0)
        statue = @"未完成";
    NSString* orderType;
    if ([dict[@"orderType"] isEqualToString:@"ShopSale"]) {
        orderType = @"卖货订单";
    }
    else if([dict[@"orderType"] isEqualToString:@"ShopEngage"])
    {
        orderType = @"预订订单";
    }
    orderstatus.text = [NSString stringWithFormat:@"%@ %@",statue,orderType];
    [v_header addSubview:orderstatus];
    
    return v_header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 65;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    v_footer.backgroundColor = [UIColor clearColor];
    NSDictionary* dict = [self.items objectAtIndex:section] ;
    NSString* string = [NSString stringWithFormat:@"共%d件商品",[dict[@"productList"] count]];
    NSRange rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%d",[dict[@"productList"] count]]];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
    
    NIAttributedLabel* goodscountlab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.font = FONT(15);
    goodscountlab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    goodscountlab.attributedText = text;
    [v_footer addSubview:goodscountlab];
    
    
    string = [NSString stringWithFormat:@"实付%.2f元",[dict[@"orderFactAmount"] doubleValue]];
    rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%.2f",[dict[@"orderFactAmount"] doubleValue]]];
    text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
    
    
    
    
    //设置一个行高上限
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [string sizeWithFont:FONT(15) constrainedToSize:size];
    
    
    NIAttributedLabel* pricelab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelsize.width+5, 0, labelsize.width, 30)];
    
    pricelab.font = FONT(15);
    pricelab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    pricelab.textAlignment = NSTextAlignmentRight;
    pricelab.attributedText = text;
    [v_footer addSubview:pricelab];
    
    
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailsbtn.tag = [[NSString stringWithFormat:@"10%d",section] intValue];
    [detailsbtn.layer setMasksToBounds:YES];
    [detailsbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [detailsbtn.layer setBorderWidth:1.0]; //边框
    [detailsbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
    detailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 32, 80, 30);
    [detailsbtn setTitle:@"详情" forState:UIControlStateNormal];
    detailsbtn.titleLabel.font = FONT(13);
    [detailsbtn setTitleColor:UIColorFromRGB(0x171c61) forState:UIControlStateNormal];
    [detailsbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:detailsbtn];
    

    if ([dict[@"orderStatus"] intValue] == 0 && self.ManagementTyep != OrderManagementTypeAll)
    {
        UIButton* Terminationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Terminationbtn.tag = [[NSString stringWithFormat:@"11%d",section] intValue];
        [Terminationbtn.layer setMasksToBounds:YES];
        [Terminationbtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [Terminationbtn.layer setBorderWidth:1.0]; //边框
        [Terminationbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
        Terminationbtn.frame = CGRectMake(SCREEN_WIDTH-90*2, 32, 80, 30);
        [Terminationbtn setTitle:@"终止订单" forState:UIControlStateNormal];
        Terminationbtn.titleLabel.font = FONT(14);
        [Terminationbtn setTitleColor:UIColorFromRGB(0x171c61)  forState:UIControlStateNormal];
        [Terminationbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
        [v_footer addSubview:Terminationbtn];
    }
    

    return v_footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict  = [self.items objectAtIndex:indexPath.section];
    if (self.CellSkipSelect) {
        self.CellSkipSelect([[dict objectForKey:@"productList"] objectAtIndex:indexPath.row]);
    }
}
-(void)goskipdetails:(UIButton*)sender
{
    
    NSString* tag = [NSString stringWithFormat:@"%d",sender.tag];
    NSInteger section = [[tag substringFromIndex:2] intValue];
    NSInteger ntag = [[tag substringToIndex:2] intValue];
    NSDictionary* dict = [self.items objectAtIndex:section];
    
    if (ntag == 11) {
        DLog(@"终止定单")
        self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
            DLog(@"否");
            
            
        } otherButtonBlock:^{
            DLog(@"是");
            [self httpCancelOrder :dict];
        }];
        
        [self.stAlertView show];
    
    }
    else
    {
        if (self.BtnSkipSelect) {
            self.BtnSkipSelect(sender.tag,dict);
        }
    }
    
    
}

-(void)httpGetAllOrderList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    if (self.ManagementTyep == OrderManagementTypeAll) {
        [parameter setObject:@""  forKey:@"custId"];
    }
    else
    {
        [parameter setObject:[ConfigManager sharedInstance].strCustId  forKey:@"custId"];
    }
    
    [parameter setObject:@"2" forKey:@"orderStatus"];
    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrderList] parameters:parameter];
    
    DLog(@"url = %@",url);
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        self.items = [data objectForKey:@"datas"];
        [self.tableview reloadData];
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

-(void)httpCancelOrder:(NSDictionary*)dict
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCancelOrder] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:dict[@"orderId"] forKey:@"orderId"];
    [param setObject:dict[@"orderFactAmount"] forKey:@"factAmount"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",[data objectForKey:@"datas"],[data objectForKey:@"msg"]);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"] intValue]==200){
            
            [self httpGetAllOrderList];
        }
        else
        {
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
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
