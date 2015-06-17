//
//  CompletedOrderDetailsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/11.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "CompletedOrderDetailsViewController.h"
#import "OrderAmountCell.h"
#import "OrdersGoodsCell.h"
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
#import "AllOrdersCell.h"
#import "amountCell.h"
@interface CompletedOrderDetailsViewController ()
@property UINib* OrdersGoodsNib;
@property UINib* OrderAmountNib;
@property UINib* AllOrdersNib;
@property UINib* amountNib;

@end

@implementation CompletedOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"订单详情";
    [self setupView];
    [self httpGetOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)orderProcessing:(UIButton*)sender
{
    DLog(@"退货");
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
}
-(void)setupView
{
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
    
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
    if (self.ManagementTyep == OrderManagementTypeAll) {
        CGRect rect = self.tableview.frame;
        rect.size.height = rect.size.height + 40;
        self.tableview.frame = rect;
        self.returnBtn.hidden = YES;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return [[self.items objectForKey:@"productList"] count];
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        amountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"amountCell"];
        if(cell==nil){
            cell = (amountCell*)[[self.amountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.nameLab.text = [NSString stringWithFormat:@"制单人:%@",self.items[@"orderCreator"]];
        cell.priceLab.text = [NSString stringWithFormat:@"会员:%@",self.items[@"custName"]];
//        static NSString *cellIdentifier = @"Cell";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//        title.textColor = UIColorFromRGB(0x323232);
//        title.font = FONT(15);
//        title.text = [NSString stringWithFormat:@"制单人:%@",self.items[@"orderCreator"]];
//        [cell.contentView addSubview:title];
//        
//        UILabel* membertitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//        membertitle.textColor = UIColorFromRGB(0x323232);
//        membertitle.font = FONT(15);
//        membertitle.text = [NSString stringWithFormat:@"会员:%@",self.items[@"custName"]];
//        membertitle.textAlignment = NSTextAlignmentRight;
//        [cell.contentView addSubview:membertitle];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section == 1) {
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.picktype = PickUpTypeFinish;
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
        
        cell.receivablelab.text = [NSString stringWithFormat:@"%.1f",[self.items[@"orderAmount"] doubleValue]];
        cell.Receivedlab.text =[NSString stringWithFormat:@"%.1f",[self.items[@"orderFactAmount"] doubleValue]] ;
        [cell.Receivedlab setEnabled:NO];
        cell.favorablelab.text = [NSString stringWithFormat:@"%.1f",[self.items[@"orderDiscount"] doubleValue]] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 30;
    }
    else if (indexPath.section == 1) {
        return self.m_height;
    }
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section != 1) {
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
//    datelab.text = @"商品";
//    [v_header addSubview:datelab];
//    
//    
//    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
//    orderstatus.textAlignment = NSTextAlignmentRight;
//    orderstatus.font = FONT(13);
//    orderstatus.textColor = UIColorFromRGB(0x878787);;
//    orderstatus.text = [NSString stringWithFormat:@"制单人:%@",self.items[@"orderCreator"]];
//    [v_header addSubview:orderstatus];
//    
//    return v_header;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section != 1) {
//        return nil;
//    }
//    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    //    v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    v_footer.backgroundColor = [UIColor clearColor];
//    NSString* string = [NSString stringWithFormat:@"共%d件商品",[self.items[@"productList"] count]];
//    NSRange rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%d",[self.items[@"productList"] count]]];
//    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
//    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
//    
//    NIAttributedLabel* goodscountlab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//    goodscountlab.font = FONT(15);
//    goodscountlab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
//    goodscountlab.attributedText = text;
//    [v_footer addSubview:goodscountlab];
//
//    
//    UILabel* Pickuplab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
//    Pickuplab.text = @"共提货2次";
//    Pickuplab.font = FONT(14);
//    Pickuplab.textAlignment = NSTextAlignmentRight;
//    [v_footer addSubview:Pickuplab];
//    
//    return v_footer;
//}

-(void)httpGetOrder
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    [parameter setObject:self.strOrderId forKey:@"orderId"];
    
    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrder] parameters:parameter];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@,msg = %@",data,msg);
        self.items = [data objectForKey:@"order"] ;
        self.m_height = ([[self.items objectForKey:@"productList"] count] + 1)*65 - 5;
        [self.tableview reloadData];
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
