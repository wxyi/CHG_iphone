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
#import "OrderManagementViewController.h"
@interface OrderCounterViewController ()<SWTableViewCellDelegate,UITextFieldDelegate>
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
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
//    JTImageButton *leftbtn = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
//    [leftbtn createTitle:@"返回" withIcon:[UIImage imageNamed:@"btn_back.png"] font:[UIFont systemFontOfSize:17] iconHeight:JTImageButtonIconHeightDefault iconOffsetY:1.0];
//    leftbtn.titleColor = [UIColor whiteColor];
//    
//    leftbtn.iconColor = [UIColor whiteColor];
//    leftbtn.padding = JTImageButtonPaddingSmall;
//    leftbtn.borderColor = [UIColor clearColor];
//    leftbtn.iconSide = JTImageButtonIconSideLeft;
//    [leftbtn addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
////    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(goback)];
    if (self.orderSaletype == SaleTypeReturnGoods) {
        self.title = @"退货柜台";
    }
    else if(self.orderSaletype == SaleTypePickingGoods)
    {
        self.title = @"提货柜台";
    }
    else
    {
        self.title = @"订单柜台";
    }
//    self.title = @"订单柜台";
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

//    self.items = [[NSMutableArray alloc] init];
    
//    self.items = [NSArray arrayWithObjects:[NSArray arrayWithObjects:dict,dict,dict, nil],[NSArray arrayWithObjects:dict,dict, nil], nil];
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 40;
//    rect.size.width = SCREEN_WIDTH;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -40);
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
//    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    
    self.PresellNib = [UINib nibWithNibName:@"PresellCell" bundle:nil];

    self.OrderGiftNib = [UINib nibWithNibName:@"OrderGiftCell" bundle:nil];
    
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
    
    self.PickAndReturnNib = [UINib nibWithNibName:@"PickAndReturnCell" bundle:nil];
    
//    rect = self.button.frame;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    rect.size.width = SCREEN_WIDTH/2;
    self.continuebtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
    
    self.button.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-40, SCREEN_WIDTH/2, 40);
//
//    rect = self.continuebtn.frame;
//    rect.size.width = SCREEN_WIDTH/2;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    self.continuebtn.frame = rect;
    
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
            
            
            [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
            cell.titlelab.text = dict[@"productName"] ;
            cell.pricelab.text = dict[@"productPrice"];
            cell.countlab.text = [NSString stringWithFormat:@"x%d",[dict[@"QrcList"] count]];
            
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
            cell.indexPath = indexPath;
            cell.operationPage = @"1";
            NSDictionary* dict =  [self.items objectAtIndex:indexPath.row];
            
            cell.showCount =^(NSInteger count){
                UILabel* label = (UILabel*)[self.view viewWithTag:1010];
                label.text = [NSString stringWithFormat:@"%.2f",count*[dict[@"productPrice"] doubleValue]];
                
                UITextField* textfield = (UITextField*)[self.view viewWithTag:1011];
                textfield.text = [NSString stringWithFormat:@"%.2f",count*[dict[@"productPrice"] doubleValue]];
            };
            
            [cell.GoodsImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
            cell.titlelab.text = dict[@"productName"] ;
            cell.pricelab.text = dict[@"productPrice"];
            cell.TextStepper.Current = [dict[@"quantity"] doubleValue];
            cell.counter =  [dict[@"quantity"] intValue];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    }
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
                cell.actualtext.text = [NSString stringWithFormat:@"%.2f",[self.priceDict[@"ysMoney"] doubleValue]] ;
                
            }
            cell.receivableLab.text =[NSString stringWithFormat:@"%.2f",[self.priceDict[@"ysMoney"] doubleValue]] ;
            
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
            cell.orderSaletype = self.orderSaletype;
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

            cell.allprice = allPrice;
            cell.receivablelab.text = [NSString stringWithFormat:@"%.2f",allPrice];
            cell.Receivedlab.text = [NSString stringWithFormat:@"%.2f",allPrice];
            cell.favorablelab.text = @"0.00";
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
    else
        return @"";
    
}

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
        if (self.orderSaletype == SaleTypeReturnGoods ||self.orderSaletype == SaleTypePresell||self.orderSaletype == SaleTypeSellingGoods) {
            DLog(@"提货退货");

            UITextField* textField = (UITextField*)[self.view viewWithTag:1011];
//            UILabel* label = (UILabel*)[self.view viewWithTag:1010];
            NSString *info;
            if (textField.text.length == 0) {
                info = @"请输入金额";
            }
            
            if (info.length != 0) {
                [SGInfoAlert showInfo:info
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
                return;

            }
            
            if (self.orderSaletype == SaleTypeReturnGoods) {
                self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认退货商品" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
                    DLog(@"否");
                    
                    [self httpOrderCounter];
                    
                } otherButtonBlock:^{
                    DLog(@"是");
                    
                    
                    
                }];
                [self.stAlertView show];
            }
            else
            {
                [self httpOrderCounter];
            }
            
        }
        else
        {
            DLog(@"确认提货");
            
            [self httpOrderCounter];
        }
        
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否删除此商品" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
                DLog(@"否");
                NSMutableArray* tmArray = [self.items mutableCopy];
                
                [tmArray removeObjectAtIndex:index];
                NSString* strindex = [NSString stringWithFormat:@"%d",index];
                self.items = [tmArray copy];
                [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_PRESELL_GOODS object:strindex];
                [self.tableview reloadData];
                
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
            
            NSArray* Amount = @[@"orderAmount",@"orderFactAmount",@"orderDiscount"];
            for (int i = 0; i < Amount.count; i++) {
                UITextField* textField = (UITextField*)[self.view viewWithTag:[[NSString stringWithFormat:@"101%d",i] intValue]];
                DLog(@"text = %@",textField.text);
                [param setObject:textField.text forKey:Amount[i]];
            }
            
            
            break;
        }
        case SaleTypeReturnGoods://卖货退货
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
                
                [product setObject:[NSString stringWithFormat:@"%d",[self.items[i][@"quantity"]intValue]]  forKey:@"quantity"];
                
                [productList addObject:product];
            }
            
        }
        
        
        [param setObject:productList forKey:@"productList"];
    }
        
        
    
    

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:strurl parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",[data objectForKey:@"datas"],[data objectForKey:@"msg"]);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"] intValue]==200){
            
            [MMProgressHUD dismiss];
//            if (self.orderSaletype == SaleTypePickingGoods || self.orderSaletype == SaleTypeReturnGoods) {
//                OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
//                OrderManagementView.title = @"会员订单";
//                OrderManagementView.m_returnType = OrderReturnTypeAMember;
//                OrderManagementView.ManagementTyep = OrderManagementTypeSingle;
//                [self.navigationController pushViewController:OrderManagementView animated:YES];
//            }
//            else
            {
                ConfirmOrderViewController* ConfirmOrderView = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
                ConfirmOrderView.Confirmsaletype = self.orderSaletype;
                ConfirmOrderView.strOrderId = [NSString stringWithFormat:@"%d",[[[data objectForKey:@"datas"] objectForKey:@"orderId"] intValue]];
                [self.navigationController pushViewController:ConfirmOrderView animated:YES];
            }
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
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
