//
//  OrderCounterViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderCounterViewController.h"
#import "OrdersGoodsCell.h"
#import "OrderGiftCell.h"
#import "OrderAmountCell.h"
#import "PresellGoodsViewController.h"
#import "ConfirmOrderViewController.h"
#import "PresellCell.h"
#import "PickAndReturnCell.h"
#import "ConfirmOrderViewController.h"
@interface OrderCounterViewController ()<SWTableViewCellDelegate>
@property UINib* OrdersGoodsNib;
@property UINib* OrderGiftNib;
@property UINib* OrderAmountNib;
@property UINib* PresellNib;
@property UINib* PickAndReturnNib;

@end

@implementation OrderCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    self.title = @"订单柜台";
    [self setupView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
//    self.items = [NSArray arrayWithObjects: nil];

    
    
//    self.items = [NSArray arrayWithObjects:[NSArray arrayWithObjects:dict,dict,dict, nil],[NSArray arrayWithObjects:dict,dict, nil], nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
//    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    
    self.PresellNib = [UINib nibWithNibName:@"PresellCell" bundle:nil];

    self.OrderGiftNib = [UINib nibWithNibName:@"OrderGiftCell" bundle:nil];
    
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
    
    self.PickAndReturnNib = [UINib nibWithNibName:@"PickAndReturnCell" bundle:nil];
    
    if (self.orderSaletype == SaleTypeReturnGoods) {
        [self.button setTitle:@"确认退货" forState:UIControlStateNormal];
    }
    else if(self.orderSaletype == SaleTypePickingGoods)
    {
        [self.button setTitle:@"确认提货" forState:UIControlStateNormal];
    }
    else
    {
        [self.button setTitle:@"确认订单" forState:UIControlStateNormal];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.items.count;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.orderSaletype == SaleTypeSellingGoods
            ||self.orderSaletype == SaleTypeReturnGoods
            ||self.orderSaletype == SaleTypePickingGoods) {
            OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
            if(cell==nil){
                cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            
            NSDictionary* dict =  [self.items objectAtIndex:indexPath.row];
            
            
            [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
            cell.titlelab.text = dict[@"productName"] ;
            cell.pricelab.text = dict[@"productPrice"];
            cell.countlab.text = [NSString stringWithFormat:@"%d",[dict[@"QrcList"] count]];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            PresellCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PresellCell"];
            if(cell==nil){
                cell = (PresellCell*)[[self.PresellNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                NSMutableArray *rightUtilityButtons = [NSMutableArray new];
                
                
                [rightUtilityButtons sw_addUtilityButtonWithColor:
                 [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                             icon:[UIImage imageNamed:@"left_slide_delete.png"]];
                [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
                cell.delegate = self;
                
            }
            
            
            
           [cell setupCell];
            NSDictionary* dict =  [self.items objectAtIndex:indexPath.row];
            
            
            [cell.GoodsImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
            cell.titlelab.text = dict[@"productName"] ;
            cell.pricelab.text = dict[@"productPrice"];
            cell.TextStepper.Current = [dict[@"quantity"] doubleValue];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    }
//    else if(indexPath.section == 1)
//    {
//        OrderGiftCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderGiftCell"];
//        if(cell==nil){
//            cell = (OrderGiftCell*)[[self.OrderGiftNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        if (self.orderSaletype == SaleTypeReturnGoods
//            ||self.orderSaletype == SaleTypePickingGoods)
//        {
//            cell.TextStepper.enabled = NO;
//        }
//        [cell setupCell];
//        
//        
//        cell.GoodImage.image = [UIImage imageNamed:[self.dict objectForKey:@"image"]];
//        cell.titlelab.text = [self.dict objectForKey:@"title"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
    else
    {
        if (self.orderSaletype == SaleTypePickingGoods ||self.orderSaletype == SaleTypeReturnGoods) {
            PickAndReturnCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PickAndReturnCell"];
            if(cell==nil){
                cell = (PickAndReturnCell*)[[self.PickAndReturnNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            if (self.orderSaletype == SaleTypePickingGoods) {
                cell.receivableNameLab.text =@"应收金额";
                cell.actualNameLab.text = @"实收金额";
                [cell.actualtext setEnabled:NO];
                cell.actualtext.text = [NSString stringWithFormat:@"%.2f",[self.priceDict[@"ssMoney"] doubleValue]] ;
            }
            else
            {
                cell.receivableNameLab.text =@"应退金额";
                cell.actualNameLab.text = @"实退金额";
                
            }
//            double allPrice;
//            for (int i = 0; i< self.items.count; i++) {
//                double price = [[self.items[i] objectForKey:@"productPrice"] doubleValue];
//                int count = [[self.items[i] objectForKey:@"QrcList"] count];
//                allPrice += price * count;
//                
//            }
            cell.receivableLab.text =[NSString stringWithFormat:@"%.2f",[self.priceDict[@"ysMoney"] doubleValue]] ;
            
//            cell.receivablelab.text = @"$336";
//            cell.favorablelab.text = @"16";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
            if(cell==nil){
                cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            double allPrice;
            
            for (int i = 0; i< self.items.count; i++) {
                double price = [[self.items[i] objectForKey:@"productPrice"] doubleValue];
                int count;
                if (self.orderSaletype == SaleTypeSellingGoods) {
                    count = [[self.items[i] objectForKey:@"QrcList"] count];
                }
                else
                {
                    count = [[self.items[i] objectForKey:@"quantity"] intValue];
                }
                
                allPrice += price * count;
                
            }
//            cell.receivableLab.text = [NSString stringWithFormat:@"%.1f",allPrice];
            cell.allprice = allPrice;
            cell.receivablelab.text = [NSString stringWithFormat:@"%.1f",allPrice];
//            cell.favorablelab.text = @"16";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

        }
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 30;
    }
    return 0.1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"商品";
    }
//    else if(section == 1)
//    {
//        return @"赠品";
//    }
    else
        return @"";
    
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 /*|| indexPath.section == 1*/) {
        return 70;
    }
    if (self.orderSaletype == SaleTypePickingGoods
        ||self.orderSaletype == SaleTypeReturnGoods)
    {
        return 60;
    }
    else
    {
        return 90;
    }
    
}
-(IBAction)OrderCounterView:(UIButton*)sender
{
    if (sender.tag == 104) {
        DLog(@"继续扫描")

        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(sender.tag == 105)
    {
        if (self.orderSaletype == SaleTypeReturnGoods ) {
            DLog(@"提货退货");

            UITextField* textField = (UITextField*)[self.view viewWithTag:1011];
            if (textField.text.length == 0) {
                [SGInfoAlert showInfo:@"请输入实退金额"
                              bgColor:[[UIColor darkGrayColor] CGColor]
                               inView:self.view
                             vertical:0.7];
                return;
            }
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认退货商品" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
          
                
                
            } otherButtonBlock:^{
                DLog(@"是");
           
                [self httpOrderCounter];
            
            }];
            [self.stAlertView show];
        }
        else if(self.orderSaletype == SaleTypePickingGoods)
        {
            DLog(@"确认提货");
            
            [self httpOrderCounter];
//            SaleType satype = SaleTypePickingGoods;
//            
//            
//            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
//            PresellGoodsView.orderSaletype = satype;
//            [self.navigationController pushViewController:PresellGoodsView animated:YES];

        }
        else
        {
            DLog(@"确认订单");
            [self httpOrderCounter];
//            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否需要添加赠品" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
//                DLog(@"否");
//                ConfirmOrderViewController* ConfirmOrderView = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
//                ConfirmOrderView.Confirmsaletype = self.orderSaletype;
//                [self.navigationController pushViewController:ConfirmOrderView animated:YES];
//                
//                
//            } otherButtonBlock:^{
//                DLog(@"是");
//                
//                [self.navigationController popViewControllerAnimated:YES];
//            }];
            
            [self.stAlertView show];
        }
        
        
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否删除此商品" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
                
                
            } otherButtonBlock:^{
                DLog(@"是");
                
            }];
            
            [self.stAlertView show];
            
            
            break;
        }
        default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}
-(void)httpOrderCounter
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:[ConfigManager sharedInstance].strCustId forKey:@"custId"];
    
    NSString* strurl;
    switch (self.orderSaletype) {
        case SaleTypeSellingGoods://卖货
        case SaleTypePresell://预售
        {
            if (self.orderSaletype == SaleTypeSellingGoods) {
                strurl = [APIAddress ApiCreateSaleOrder];
            }
            else
            {
                strurl = [APIAddress ApiCreateEngageOrder];
            }
            
//            [param setObject:@"1" forKey:@"orderAmount"];
//            [param setObject:@"2" forKey:@"orderFactAmount"];
//            [param setObject:@"3" forKey:@"orderDiscount"];
            
            NSArray* Amount = @[@"orderAmount",@"orderFactAmount",@"orderDiscount"];
            for (int i = 0; i < Amount.count; i++) {
                UITextField* textField = (UITextField*)[self.view viewWithTag:[[NSString stringWithFormat:@"101%d",i] intValue]];
                DLog(@"text = %@",textField.text);
                [param setObject:textField.text forKey:Amount[i]];
            }
            
            
            break;
        }
        case SaleTypeReturnGoods://卖货退货
//        case SaleTypeReturnEngageGoods://待提货退货
        {
            strurl = [APIAddress ApiCreateReturnOrder];
            UITextField* textField = (UITextField*)[self.view viewWithTag:1011];
            [param setObject:textField.text forKey:@"factAmount"];

            break;
        }
        case SaleTypePickingGoods://预定订单提货
        {
            strurl = [APIAddress ApiCreateSubOrder];
            break;
        }
        
        default:
            break;
    }
    
    NSMutableArray*  productList = [[NSMutableArray alloc] init];
    if (self.orderSaletype != SaleTypeReturnEngageGoods) {
        
        for (int i = 0; i < self.items.count; i ++) {
            if (self.orderSaletype == SaleTypeSellingGoods||self.orderSaletype == SaleTypePickingGoods||self.orderSaletype == SaleTypeReturnGoods)
            {
                NSArray* qrcArr = [self.items[i] objectForKey:@"QrcList"];
                
                for (int j = 0; j < qrcArr.count; j++) {
                    
                    NSMutableDictionary *product = [NSMutableDictionary dictionary];
                    [product setObject:[self.items[i] objectForKey:@"productId"] forKey:@"productId"];
                    [product setObject:qrcArr[j] forKey:@"productCode"];
                    
                    [product setObject:@"1"forKey:@"quantity"];

                    [productList addObject:product];
                }
                
            }
            else if (self.orderSaletype == SaleTypePresell)
            {
            
                NSMutableDictionary *product = [NSMutableDictionary dictionary];
                [product setObject:self.items[i][@"productId"] forKey:@"productId"];
                
                [product setObject:self.items[i][@"quantity"] forKey:@"quantity"];
                
                [productList addObject:product];
            }
            
        }
        
        
        [param setObject:productList forKey:@"productList"];
    }
        
        
    
    

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:strurl parameters:parameter];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",[data objectForKey:@"datas"],[data objectForKey:@"msg"]);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"] intValue]==200){
            
            ConfirmOrderViewController* ConfirmOrderView = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
            ConfirmOrderView.Confirmsaletype = self.orderSaletype;
            ConfirmOrderView.strOrderId = [NSString stringWithFormat:@"%d",[[[data objectForKey:@"datas"] objectForKey:@"orderId"] intValue]];
            [self.navigationController pushViewController:ConfirmOrderView animated:YES];
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
