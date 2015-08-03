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
    else if(self.orderSaletype == SaleTypeStopOrder)
    {
        self.title = @"终止订单";
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
    self.countitem = [[NSMutableArray alloc] init];
    self.isfrist = YES;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -40);
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.showsVerticalScrollIndicator = NO;
//    self.tableview.scrollEnabled = NO;
    self.tableview.bounces = NO;
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
//    //测试
//    
//    double allPrice;
//    double price;
//    int count;
//    [SGInfoAlert showInfo:[NSString stringWithFormat:@"allPrice = %.2f count = %d price = %.2f",allPrice,count,price]
//                  bgColor:[[UIColor blackColor] CGColor]
//                   inView:self.view
//                 vertical:0.2];
//    for (int i = 0; i< self.items.count; i++) {
//        price = [[self.items[i] objectForKey:@"productPrice"] doubleValue];
//        
//        if (self.orderSaletype == SaleTypeSellingGoods) {
//            count = [[self.items[i] objectForKey:@"QrcList"] count];
//        }
//        else
//        {
//            count = [[self.items[i] objectForKey:@"quantity"] intValue];
//        }
//        
//        allPrice += price * count;
//        
//    }
//    [SGInfoAlert showInfo:[NSString stringWithFormat:@"allPrice = %.2f count = %d price = %.2f",allPrice,count,price]
//                  bgColor:[[UIColor blackColor] CGColor]
//                   inView:self.view
//                 vertical:0.7];
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
                cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            
            NSDictionary* dict =  [self.items objectAtIndexSafe:indexPath.row];
            
            
            [cell.GoodImage setImageWithURL:[NSURL URLWithString:[dict objectForKeySafe: @"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
            cell.titlelab.text = [dict objectForKeySafe:@"productName"] ;
//            cell.pricelab.text = [dict objectForKeySafe:@"productPrice"];
            cell.pricelab.text = [NSString stringWithFormat:@"￥%@",[dict objectForKeySafe:@"productPrice"]];
            cell.countlab.text = [NSString stringWithFormat:@"x%d",[(NSArray*)[dict objectForKeySafe:@"QrcList"] count]];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            PresellCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PresellCell"];
            if(cell==nil){
                cell = (PresellCell*)[[self.PresellNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                NSMutableArray *rightUtilityButtons = [NSMutableArray new];
                
                
                [rightUtilityButtons sw_addUtilityButtonWithColor:
                 [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                             icon:[UIImage imageNamed:@"left_slide_delete.png"]];
                [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
                cell.delegate = self;
                
            }
            
            
            cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
           [cell setupCell];
            cell.indexPath = indexPath;
            
            cell.operationPage = @"1";
            NSDictionary* dict =  [self.items objectAtIndexSafe:indexPath.row];
            
            
            cell.showCount =^(NSString* state,CGFloat price,NSIndexPath* indexPath,NSInteger count){
                UILabel* label = (UILabel*)[self.view viewWithTag:1010];
                CGFloat allpice = [[self.OrderDate objectForKeySafe:@"totalAmount"] floatValue];
                if ([state integerValue] == 2) {
                    DLog(@"加");
                    allpice += price;
                }
                else if([state integerValue]== 1)
                {
                    DLog(@"减");
                    allpice -= price;
                }
                
                [self.countitem replaceObjectAtIndexSafe:indexPath.row withObject:[NSString stringWithFormat:@"%d",count]];
                label.text = [NSString stringWithFormat:@"￥%.2f",allpice];
//
                UITextField* textfield = (UITextField*)[self.view viewWithTag:1011];
                textfield.text = [NSString stringWithFormat:@"￥%.2f",allpice];
                
                
                
                //add
                NSMutableDictionary* dict = [self.items objectAtIndexSafe:indexPath.row];
                [dict setObjectSafe:[NSString stringWithFormat:@"%d",count] forKey:@"quantity"];
                [self.items replaceObjectAtIndex:indexPath.row withObject:dict];
                [self.OrderDate setObject:[NSString stringWithFormat:@"%.2f",allpice] forKey:@"totalAmount"];
                [self.OrderDate setObject:[NSString stringWithFormat:@"%.2f",allpice] forKey:@"FactAmount"];
                [self.OrderDate setObject:@"0.00" forKey:@"DiscountAmount"];
                [self.OrderDate setObject:self.items forKey:@"orderList"];
                
            };
            
            [cell.GoodsImage setImageWithURL:[NSURL URLWithString:[dict objectForKeySafe:@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
            cell.titlelab.text = [dict objectForKeySafe:@"productName"] ;
//            cell.pricelab.text = [dict objectForKeySafe:@"productPrice"];
            
            cell.price = [[dict objectForKeySafe:@"productPrice"] doubleValue];
            cell.pricelab.text = [NSString stringWithFormat:@"￥%@",[dict objectForKeySafe:@"productPrice"]];
            
            
            cell.TextStepper.Current = [[[[self.OrderDate objectForKeySafe:@"orderList"] objectAtIndexSafe:indexPath.row] objectForKeySafe:@"quantity"] doubleValue];
            cell.counter =  [[[[self.OrderDate objectForKeySafe:@"orderList"] objectAtIndexSafe:indexPath.row] objectForKeySafe:@"quantity"] intValue];
//            if (self.isfrist ) {
////                self.isfrist = NO;
////                [self.countitem removeAllObjects];
//                
//                [self.countitem addObject:[dict objectForKeySafe:@"quantity"]];
//                
//            }
//            else
//            {
//                cell.TextStepper.Current = [[self.countitem objectAtIndexSafe:indexPath.row] doubleValue];
//                cell.counter =  [[self.countitem objectAtIndexSafe:indexPath.row] intValue];
//            }
            
            cell.TextStepper.tag = [[NSString stringWithFormat:@"1011%ld",(long)indexPath.row] intValue];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    }
    else
    {
        if (self.orderSaletype == SaleTypePickingGoods ||self.orderSaletype == SaleTypeReturnGoods) {
            PickAndReturnCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PickAndReturnCell"];
            if(cell==nil){
                cell = (PickAndReturnCell*)[[self.PickAndReturnNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            
            DLog(@"totalamout = %@",[self.OrderDate objectForKeySafe:@"totalAmount"]);
            CGFloat price= 0.0;
            for (int i = 0; i < [self.items count]; i++) {
                NSInteger count = [[[self.items objectAtIndexSafe:i] objectForKeySafe:@"QrcList"] count];
                CGFloat productPrice = [[[self.items objectAtIndexSafe:i] objectForKeySafe:@"productPrice"] doubleValueSafe];
                price += count * productPrice;
            }
//            CGFloat price= [ floatValue];
            cell.orderpriceBlock = ^(NSMutableDictionary *dict)
            {
                
                self.ChangePriceDict = [dict copy];
                
                NSString* fact = [self.ChangePriceDict objectForKeySafe:@"orderFactAmount"] ;
//                NSString* Discount = [self.ChangePriceDict objectForKeySafe:@"orderDiscount"] ;
                [self.OrderDate setObject:[fact substringFromIndex:1] forKey:@"FactAmount"];
//                [self.OrderDate setObject:[Discount substringFromIndex:1] forKey:@"DiscountAmount"];
                
            };
            
            if (self.orderSaletype == SaleTypePickingGoods) {
                cell.receivableNameLab.text =@"应收金额:";
                cell.actualNameLab.text = @"实收金额:";
                [cell.actualtext setEnabled:NO];
//                cell.actualtext.text = [NSString stringWithFormat:@"%.2f",[[self.priceDict objectForKeySafe: @"ysMoney"] floatValue]] ;
                cell.actualtext.text = [NSString stringWithFormat:@"￥%.2f",price];
                cell.receivableLab.text =[NSString stringWithFormat:@"￥%.2f",price] ;
            }
            else
            {
                
                
                cell.returnPrice = [NSString stringWithFormat:@"%.2f",price];
                cell.receivableNameLab.text =@"应退金额:";
                cell.actualNameLab.text = @"实退金额:";
                cell.receivableLab.text =[NSString stringWithFormat:@"￥%.2f",[[self.OrderDate objectForKeySafe:@"totalAmount"] floatValue]] ;
                
                cell.actualtext.text = [NSString stringWithFormat:@"￥%.2f",[[self.OrderDate objectForKeySafe:@"FactAmount"] floatValue]] ;
//                cell.receivableLab.text =[NSString stringWithFormat:@"￥%.2f",[[self.priceDict objectForKeySafe:@"ysMoney"] floatValue]] ;
//                
//                
//                
//                if (self.isfrist) {
//                    self.isfrist = NO;
//                    
//                    cell.actualtext.text = [NSString stringWithFormat:@"￥%.2f",[[self.priceDict objectForKeySafe:@"ysMoney"] floatValue]] ;
//                    
//                }
//                else{
//
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    [dict setObjectSafe:[NSString stringWithFormat:@"￥%.2f",[[self.priceDict objectForKeySafe:@"ysMoney"] floatValue]] forKey:@"orderFactAmount"];
//                    
//                    self.ChangePriceDict = [dict copy];
//                    
//                    cell.actualtext.text = [self.ChangePriceDict objectForKeySafe:@"orderFactAmount"];
//                }
                
                
            }
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
            if(cell==nil){
                cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            cell.allprice  = [[self.OrderDate objectForKeySafe:@"totalAmount"] floatValue];
            cell.orderSaletype = self.orderSaletype;
//            for (int i = 0; i< self.items.count; i++) {
//                CGFloat price = [[self.items[i] objectForKeySafe:@"productPrice"] floatValue];
//                NSInteger count;
//                if (self.orderSaletype == SaleTypeSellingGoods) {
//                    count = [[self.items[i] objectForKeySafe:@"QrcList"] count];
//                }
//                else
//                {
//                    count = [[self.items[i] objectForKeySafe:@"quantity"] intValue];
//                }
//                
//                allPrice += price * count;
//                
//            }

            cell.orderpriceBlock = ^(NSMutableDictionary *dict)
            {
                self.ChangePriceDict = [dict copy];
                
                NSString* fact = [self.ChangePriceDict objectForKeySafe:@"orderFactAmount"] ;
                NSString* Discount = [self.ChangePriceDict objectForKeySafe:@"orderDiscount"] ;
                [self.OrderDate setObject:[fact substringFromIndex:1] forKey:@"FactAmount"];
                [self.OrderDate setObject:[Discount substringFromIndex:1] forKey:@"DiscountAmount"];
            };
            cell.receivablelab.text = [NSString stringWithFormat:@"￥%@",[self.OrderDate objectForKeySafe:@"totalAmount"]];
            cell.Receivedlab.text = [NSString stringWithFormat:@"￥%@",[self.OrderDate objectForKeySafe:@"FactAmount"]];
            cell.favorablelab.text = [NSString stringWithFormat:@"￥%@",[self.OrderDate objectForKeySafe:@"DiscountAmount"]];;
//            if (self.isfrist) {
//                self.isfrist = NO;
//                cell.allprice = allPrice;
////                cell.receivablelab.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
//                cell.Receivedlab.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
//                cell.favorablelab.text = @"￥0.00";
//                
//                
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                [dict setObjectSafe:[NSString stringWithFormat:@"￥%.2f",allPrice]forKey:@"orderFactAmount"];
//                [dict setObjectSafe: @"￥0.00" forKey:@"orderDiscount"];
//                self.ChangePriceDict = [dict copy];
//            }
//            else
//            {
//                
//                cell.Receivedlab.text = [self.ChangePriceDict objectForKeySafe:@"orderFactAmount"];
//                cell.favorablelab.text = [self.ChangePriceDict objectForKeySafe:@"orderDiscount"];;
//                
//            }
            
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

//            UITextField* textField = (UITextField*)[self.view viewWithTag:1011];
//            UILabel* label = (UILabel*)[self.view viewWithTag:1010];
//            NSString *info;
//            if (textField.text.length == 0) {
//                info = @"请输入金额";
//            }
//            
//            if (info.length != 0) {
//                [SGInfoAlert showInfo:info
//                              bgColor:[[UIColor blackColor] CGColor]
//                               inView:self.view
//                             vertical:0.7];
//                return;
//
//            }
            
            if (self.orderSaletype == SaleTypeReturnGoods) {
                self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认退货商品?" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
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
            
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认提货?" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
                DLog(@"否");
                
                [self httpOrderCounter];
                
            } otherButtonBlock:^{
                DLog(@"是");
                
                
                
            }];
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
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否删除此商品?" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
                DLog(@"否");
                NSMutableArray* tmArray = [self.items mutableCopy];
                NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
                
                [tmArray removeObjectAtIndex:cellIndexPath.row];
                
                
                
//                [tmArray removeObjectAtIndexSafe:index];
//                NSString* strindex = [NSString stringWithFormat:@"%d",index];
                
                
                self.items = tmArray;
                
                CGFloat allprice = 0.0;
                for (int i = 0; i < self.items.count; i ++) {
                    CGFloat price = [[[self.items objectAtIndexSafe:i] objectForKeySafe:@"productPrice"] doubleValueSafe];
                    NSInteger quantity = [[[self.items objectAtIndexSafe:i] objectForKeySafe:@"quantity"] integerValueSafe];
                    allprice += price * quantity;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObjectSafe:[NSString stringWithFormat:@"￥%.2f",allprice]forKey:@"orderFactAmount"];
                [dict setObjectSafe: @"￥0.00" forKey:@"orderDiscount"];
                self.ChangePriceDict = [dict copy];
                
                
                //add
//                NSString* fact = [self.ChangePriceDict objectForKeySafe:@"orderFactAmount"] ;
//                NSString* Discount = [self.ChangePriceDict objectForKeySafe:@"orderDiscount"] ;
                [self.OrderDate setObject:[NSString stringWithFormat:@"%.2f",allprice] forKey:@"totalAmount"];
                
                [self.OrderDate setObject:[NSString stringWithFormat:@"%.2f",allprice]  forKey:@"FactAmount"];
                [self.OrderDate setObject:@"0.00" forKey:@"DiscountAmount"];
                [self.OrderDate setObjectSafe:self.items forKey:@"orderList"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_PRESELL_GOODS object:cellIndexPath];
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
    [param setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObjectSafe:[ConfigManager sharedInstance].strCustId forKey:@"custId"];
    
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
            
//            NSArray* Amount = @[@"orderAmount",@"orderFactAmount",@"orderDiscount"];
//            for (int i = 0; i < Amount.count; i++) {
//                UITextField* textField = (UITextField*)[self.view viewWithTag:[[NSString stringWithFormat:@"101%d",i] intValue]];
//                DLog(@"text = %@",textField.text);
//                [param setObjectSafe:[textField.text substringFromIndex:1] forKey:Amount[i]];
//            }
            
            [param setObjectSafe:[self.OrderDate objectForKeySafe:@"totalAmount"] forKey:@"orderAmount"];
            [param setObjectSafe:[self.OrderDate objectForKeySafe:@"FactAmount"] forKey:@"orderFactAmount"];
            [param setObjectSafe:[self.OrderDate objectForKeySafe:@"DiscountAmount"] forKey:@"orderDiscount"];
            
            break;
        }
        case SaleTypeReturnGoods://卖货退货
        {
            strurl = [APIAddress ApiCreateReturnOrder];
//            UITextField* textField = (UITextField*)[self.view viewWithTag:1011];
//            [param setObjectSafe:[textField.text substringFromIndex:1] forKey:@"factAmount"];
            [param setObjectSafe:[self.OrderDate objectForKeySafe:@"FactAmount"] forKey:@"factAmount"];
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
                NSArray* qrcArr = [self.items[i] objectForKeySafe:@"QrcList"];
                
                for (int j = 0; j < qrcArr.count; j++) {
                    
                    NSMutableDictionary *product = [NSMutableDictionary dictionary];
                    [product setObjectSafe:[[self.items objectAtIndexSafe: i] objectForKeySafe:@"productId"] forKey:@"productId"];
                    [product setObjectSafe:[qrcArr objectAtIndexSafe: j] forKey:@"productCode"];
                    
                    [product setObjectSafe:@"1"forKey:@"quantity"];

                    [productList addObjectSafe:product];
                }
                
            }
            else if (self.orderSaletype == SaleTypePresell)
            {
            
                NSArray* item = [self.OrderDate objectForKeySafe:@"orderList"];
                NSMutableDictionary *product = [NSMutableDictionary dictionary];
                
                [product setObjectSafe:[[self.items objectAtIndexSafe: i] objectForKeySafe: @"productId"] forKey:@"productId"];
//                NSInteger tag  = [[NSString stringWithFormat:@"1011%d",i] intValue];
//                TextStepperField* TextStepper = (TextStepperField*)[self.view viewWithTag:tag];
                [product setObjectSafe:[[item objectAtIndexSafe:i] objectForKeySafe:@"quantity"]  forKey:@"quantity"];
                
                [productList addObjectSafe:product];
            }
            
        }
        
        
        [param setObjectSafe:productList forKey:@"productList"];
    }
        
        
    
    

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:strurl parameters:parameter];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",[data objectForKeySafe:@"datas"],[data objectForKeySafe:@"msg"]);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"] intValue]==200){
            
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
                ConfirmOrderView.returnType = self.m_returnType;
                ConfirmOrderView.strOrderId = [NSString stringWithFormat:@"%d",[[[data objectForKeySafe:@"datas"] objectForKeySafe:@"orderId"] intValue]];
                [self.navigationController pushViewController:ConfirmOrderView animated:YES];
            }
            
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
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
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpOrderCounter];
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
