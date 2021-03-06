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
#import "PresellGoodsViewController.h"
#import "PickAndReturnCell.h"
#import "ConfirmOrderViewController.h"
#import "OrderManagementViewController.h"
#import "OrderQuryViewController.h"
#import "SuccessRegisterViewController.h"
#import "successfulIdentifyViewController.h"
@interface CompletedOrderDetailsViewController ()
@property UINib* OrdersGoodsNib;
@property UINib* OrderAmountNib;
@property UINib* AllOrdersNib;
@property UINib* amountNib;
@property UINib* PickAndReturnNib;
@end

@implementation CompletedOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (self.Comordertype == TerminationOrder)
    {
        self.title = @"终止订单";
        NSString* info = @"点击实退金额项可以修改实退金额";
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    }
    else
    {
        self.title = @"订单详情";
    }
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    if (self.skiptype == SkipfromOrderManage) {

        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if (self.skiptype == SkipFromPopPage ) {
        [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if (self.m_returnType == OrderReturnTypeHomePage)
        {
            [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (self.m_returnType == OrderReturnTypeQueryOrder)
        {
            [leftButton addTarget:self action:@selector(gobacktoQuery) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (self.m_returnType == OrderReturnTypeAMember) {
            
            [leftButton addTarget:self action:@selector(gobacktoSuccessFulldentify) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (self.m_returnType == OrderReturnTypePopPage)
        {
            [leftButton addTarget:self action:@selector(gobackRegistePage) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [leftButton addTarget:self action:@selector(gotoOrderManagement) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
    
}
-(void)gobacktoQuery
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[OrderQuryViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(void)gobacktoSuccessFulldentify
{
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[successfulIdentifyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(void)gobackRegistePage
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SuccessRegisterViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(void)gotoOrderManagement
{
    OrderManagementViewController* OrderManagement = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
    OrderManagement.ManagementTyep = OrderManagementTypeSingle;
    OrderManagement.m_returnType = self.m_returnType;
    OrderManagement.title = @"会员订单";
    
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.3f;
    
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = kCATransitionFromLeft;
    
    //    transition.delegate = self;
    
    [self.view.superview.layer addAnimation:transition forKey:nil];
    
    
    
    [self.navigationController pushViewController:OrderManagement animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)orderProcessing:(UIButton*)sender
{
    if (self.Comordertype == TerminationOrder)
    {
        DLog(@"确认终止订单");
        self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单?" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
            DLog(@"否");
            [self httpCancelOrder:self.items];
            
        } otherButtonBlock:^{
            DLog(@"是");
            
        }];
        
        [self.stAlertView show];

        
    }
    else
    {
        DLog(@"退货");
        //    SaleType satype = SaleTypeReturnGoods;
        
        NSInteger pickQuantity = 0;
        NSArray* productList = [self.items objectForKey:@"productList"] ;
        for (int j = 0; j < productList.count; j++) {
            NSInteger quantity = [[[productList objectAtIndexSafe:j] objectForKeySafe:@"quantity"] integerValue];
            NSInteger returnQuantity = [[[productList objectAtIndexSafe:j] objectForKeySafe:@"returnQuantity"] integerValue];
            pickQuantity += quantity - returnQuantity;
        }
        if ([productList count] != 0 && pickQuantity != 0) {
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            PresellGoodsView.orderSaletype = SaleTypeReturnGoods;
            PresellGoodsView.m_returnType = self.m_returnType;
            PresellGoodsView.skiptype = SkipfromOrderManage;
            [self.navigationController pushViewController:PresellGoodsView animated:YES];
        }
        else
        {
            [SGInfoAlert showInfo:@"没有可退货的商品"
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            return;
        }
        
    }
    
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT - 40;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.isfrist = NO;
    self.ChangePriceDict = [NSMutableDictionary dictionary];
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -40);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
//    self.tableview.scrollEnabled = NO;
    //    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
    
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
    
    self.PickAndReturnNib = [UINib nibWithNibName:@"PickAndReturnCell" bundle:nil];
    
    self.returnBtn.frame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
//    self.ManagementTyep = OrderManagementTypeSingle;
    if (self.ManagementTyep == OrderManagementTypeAll) {
//        CGRect rect = self.tableview.frame;
//        rect.size.height = rect.size.height + 40;
//        self.tableview.frame = rect;
        self.returnBtn.hidden = YES;
        self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
    }
    if (self.Comordertype == TerminationOrder) {
        
        self.tableview.bounces = NO;
        [self.returnBtn setTitle:@"确认终止订单" forState:UIControlStateNormal];
    }
    
//    rect = self.returnBtn.frame;
//    rect.origin.y = SCREEN_HEIGHT - 40;
//    rect.size.width = SCREEN_WIDTH;
    
    if (self.Comordertype == TerminationOrder)
    {
        [self httpGetOrder];
        
    }
    else
    {
        [self setupRefresh];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.Comordertype == TerminationOrder)
    {
        return 2;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.Comordertype == TerminationOrder){
//        if (section == 0) {
//            return [[self.items objectForKey:@"productList"] count];
//        }
//    }
//    if (section == 1) {
//        return [[self.items objectForKey:@"productList"] count];
//    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        
//        if (self.Comordertype != TerminationOrder){
//            amountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"amountCell"];
//            if(cell==nil){
//                cell = (amountCell*)[[self.amountNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
//                
//            }
//            
//            if ([[self.items objectForKeySafe: @"orderCreator"] length] == 0) {
//                cell.nameLab.text = [NSString stringWithFormat:@"制单人:%@",@""];
//            }
//            else
//            {
//                cell.nameLab.text = [NSString stringWithFormat:@"制单人:%@",[self.items objectForKeySafe:@"orderCreator"]];
//            }
//            
//            
//            NSString* custName= [self.items objectForKeySafe:@"custName"];
//            DLog(@"wxy -custName = %@",custName);
//            if (custName.length != 0) {
//                custName = [custName substringToIndex:custName.length - 1];
//            }
//            else
//            {
//                custName = @"";
//            }
//            cell.priceLab.text = [NSString stringWithFormat:@"会员:%@*",custName];
////            if (custName.length > 8) {
//////                NSMutableString * string = [custName mutableCopy];
//////                [string insertString:@"    " atIndex:10];
//////                custName = [string copy];
////                cell.priceLab.textAlignment = NSTextAlignmentLeft;
////            }
////            UILabel *pricelab = [[UILabel alloc] initWithFrame:CGRectZero];
////            pricelab.font = FONT(13);
////            pricelab.textColor = UIColorFromRGB(0xBCBCBC);
////            pricelab.numberOfLines = 0; // 最关键的一句
////            CGSize size = CGSizeMake(110,2000);
////            //计算实际frame大小，并将label的frame变成实际大小
////            CGSize labelsize = [custName sizeWithFont:FONT(13) constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
////            pricelab.frame = CGRectMake(SCREEN_WIDTH - 10 -labelsize.width, 5, labelsize.width, labelsize.height);
////            pricelab.text = [NSString stringWithFormat:@"%@*",custName];
////            [cell.contentView addSubview:pricelab];
////            
////            size = CGSizeMake(40,2000);
////            //计算实际frame大小，并将label的frame变成实际大小
////            NSString* name = @"会员:";
////            CGSize labelsize1 = [name sizeWithFont:FONT(13) constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//////            cell.MemberLab.frame = CGRectZero;
////            UILabel* MemberLab = [[UILabel alloc] initWithFrame:CGRectZero];
////            MemberLab.frame = CGRectMake(SCREEN_WIDTH - labelsize1.width -labelsize.width - 10, 5, labelsize1.width , labelsize1.height);
////            MemberLab.text = name;
////            MemberLab.font = FONT(13);
////            MemberLab.textColor = UIColorFromRGB(0xBCBCBC);
////            [cell.contentView addSubview:MemberLab];
//            
//            
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            return cell;
//        }
//        else
//        {
//            AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
//            if(cell==nil){
//                cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
//                
//            }
//            cell.picktype = PickUpTypeStop;
//            cell.height = self.m_height;
//            [cell setupAllOrderView:self.items];
//            cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
//                if (self.didSelectedSubItemAction) {
//                    self.didSelectedSubItemAction(indexPath);
//                }
//            };
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            return cell;
//        }
//    }
//    else if (indexPath.section == 1 && self.Comordertype != TerminationOrder) {
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        if (self.Comordertype == TerminationOrder)
        {
            cell.picktype = PickUpTypeStop;
        }
        else
        {
            cell.picktype = PickUpTypeFinish;
        }
        
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
        
        if (self.Comordertype == TerminationOrder)
        {
            PickAndReturnCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PickAndReturnCell"];
            if(cell==nil){
                cell = (PickAndReturnCell*)[[self.PickAndReturnNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            cell.orderpriceBlock = ^(NSMutableDictionary *dict)
            {
                [self.ChangePriceDict setObject:[dict objectForKeySafe:@"orderFactAmount"] forKey:@"orderFactAmount"];
            };
            cell.receivableNameLab.text =@"应退金额:";
            cell.actualNameLab.text = @"实退金额:";
            cell.returnPrice = [[self.ChangePriceDict objectForKeySafe:@"orderAmount"] substringFromIndex:1];
            
            cell.receivableLab.text =[self.ChangePriceDict objectForKeySafe:@"orderAmount"];
            cell.actualtext.text = [self.ChangePriceDict objectForKeySafe:@"orderFactAmount"];
//            if (self.isfrist) {
//                [cell.actualtext becomeFirstResponder];
//            }
            cell.didGetCode = ^(NSString* checkcode)
            {
                [SGInfoAlert showInfo:checkcode
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            };
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
            if(cell==nil){
                cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
                
            }
            
            cell.receivablelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.items objectForKeySafe:@"orderAmount"] doubleValue]];
            cell.Receivedlab.text =[NSString stringWithFormat:@"￥%.2f",[[self.items objectForKeySafe:@"orderFactAmount"] doubleValue]] ;
            if(self.Comordertype == TerminationOrder)
            {
                [cell.Receivedlab setEnabled:YES];
//                [cell.Receivedlab becomeFirstResponder];
            }
            else
            {
                [cell.Receivedlab setEnabled:NO];
            }
            cell.didGetCode = ^(NSString* checkcode)
            {
                [SGInfoAlert showInfo:checkcode
                              bgColor:[[UIColor blackColor] CGColor]
                               inView:self.view
                             vertical:0.7];
            };
            cell.favorablelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.items objectForKeySafe:@"orderDiscount"] doubleValue]] ;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.Comordertype == TerminationOrder){
        
        if (indexPath.section == 0 ) {
            return self.m_height;
        }
        return 60;
    }
    else
    {
//        if (indexPath.section == 0) {
//            return 40;
//        }
//        else
            if (indexPath.section == 0) {
            return self.m_height;
        }
        return 90;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 2;
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
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    [parameter setObjectSafe:self.strOrderId forKey:@"orderId"];
    
    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrder] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    WEAKSELF
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@,msg = %@",data,msg);
        if (success) {
//            [MMProgressHUD dismiss];
            self.items = [data objectForKeySafe:@"order"] ;
            NSString* AmountWth = [NSString stringWithFormat:@"￥%.2f",[[self.items objectForKey:@"orderFactAmountWth"]  floatValue]];
            NSString* FactAmountWth = [NSString stringWithFormat:@"￥%.2f",[[self.items objectForKey:@"orderFactAmountWth"]  floatValue]];
            [self.ChangePriceDict setValue: AmountWth forKey:@"orderAmount"];
            [self.ChangePriceDict setValue: FactAmountWth forKey:@"orderFactAmount"];
            if (self.Comordertype == TerminationOrder){
                self.m_height = ([[weakSelf.items objectForKeySafe:@"productList"] count] + 1)*65 - 5 - 30  ;
            }
            else{
                weakSelf.m_height = ([[weakSelf.items objectForKeySafe:@"productList"] count] + 1)*65 - 5 + 35;
            }
            self.isfrist = YES;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];

        }
        else
        {
            [self.tableview.header endRefreshing];
//            [MMProgressHUD dismissWithError:msg];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpGetOrder];
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
    __weak __typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.autoChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
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


-(void)httpCancelOrder:(NSDictionary*)dict
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCancelOrder] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObjectSafe:[dict objectForKeySafe:@"orderId"] forKey:@"orderId"];
//    UITextField* textfield = (UITextField*)[self.view viewWithTag:1011];
    [param setObjectSafe:[[self.ChangePriceDict objectForKeySafe:@"orderFactAmount"] substringFromIndex:1] forKey:@"factAmount"];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",[data objectForKeySafe:@"datas"],[data objectForKeySafe:@"msg"]);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"] intValue]==200){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER object:nil];
            
            ConfirmOrderViewController* ConfirmOrderView = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
            ConfirmOrderView.Confirmsaletype = SaleTypeStopOrder;
            ConfirmOrderView.returnType = self.m_returnType;
            ConfirmOrderView.skiptype = self.skiptype;
            ConfirmOrderView.strOrderId = [NSString stringWithFormat:@"%@",[dict objectForKeySafe:@"orderId"]];
            [self.navigationController pushViewController:ConfirmOrderView animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpCancelOrder:dict];
    }];
}
@end
