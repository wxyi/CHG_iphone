//
//  OrderQuryViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderQuryViewController.h"
#import "OrderQueryCell.h"
#import "OrdersGoodsCell.h"
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
@interface OrderQuryViewController ()<UUDatePickerDelegate>
@property UINib* OrderQueryNib;
@property UINib* OrdersGoodsNib;
@end

@implementation OrderQuryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单查询";
    [self setupView ];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.OrderQueryNib = [UINib nibWithNibName:@"OrderQueryCell" bundle:nil];
    
    
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    //delegate
    self.startdatePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 200)
                                               Delegate:self
                                            PickerStyle:UUDateStyle_YearMonthDay];
    NSDate *now = [NSDate date];
    self.startdatePicker.ScrollToDate = now;
    
    //delegate
    self.enddatePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 200)
                                                    Delegate:self
                                                 PickerStyle:UUDateStyle_YearMonthDay];
//    NSDate *now = [NSDate date];
    self.enddatePicker.ScrollToDate = now;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        OrderQueryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderQueryCell"];
        if(cell==nil){
            cell = (OrderQueryCell*)[[self.OrderQueryNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        cell.selectQradio =^(NSString* strtitle){
            DLog(@"strtitle = %@",strtitle);
            weakSelf.strOrderType = strtitle;
        };
        cell.queryOrder =^(NSInteger tag){
            
            [self checkDatas];
            
        };
        cell.starttime.inputView = self.startdatePicker;
        cell.endtime.inputView = self.enddatePicker;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
        if(cell==nil){
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        //    NSDictionary* dict =  [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
        
        //    cell.GoodImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        NSArray* array = [[self.items objectAtIndex:indexPath.section- 1] objectForKey:@"productList"];
        NSDictionary* dict = [array objectAtIndex:indexPath.row];
        
        [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
        cell.titlelab.text = dict[@"productName"];
        cell.pricelab.text = dict[@"productPrice"];;
        cell.countlab.text = [NSString stringWithFormat:@"x %d",[[dict objectForKey:@"quantity"] intValue] ];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    //    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_header.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_header addSubview:line];
    
    NSDictionary* dict = [self.items objectAtIndex:section - 1] ;
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
    if (section == 0) {
        return 1;
    }
    return 65;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    v_footer.backgroundColor = [UIColor clearColor];
    NSDictionary* dict = [self.items objectAtIndex:section -1] ;
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
#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    
    UITextField* textfield;
    if (datePicker == self.startdatePicker) {
        textfield = (UITextField*)[self.view viewWithTag:100];
        
    }
    else
    {
        textfield = (UITextField*)[self.view viewWithTag:101];
    }
    
    textfield.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
}

-(void)checkDatas
{
    UITextField* startData = (UITextField*)[self.view viewWithTag:100];
    UITextField* endData = (UITextField*)[self.view viewWithTag:101];
    NSString* info;
    if (startData.text.length == 0 || endData.text.length == 0) {
        info = @"请输入时间";
    }
    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    
    if (self.strOrderType.length == 0) {
        for (int i = 0 ; i < 3 ; i++) {
            QRadioButton* radionbtn = (QRadioButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"11%d",i] intValue]];
            if (radionbtn.selected) {
                
                self.strOrderType = radionbtn.titleLabel.text;
                break;
            }
            
        }
    }
    DLog(@"self.strOrderType = %@",self.strOrderType);
    if ([self.strOrderType isEqualToString:@"全部订单"]) {
        self.strOrderType = @"2";
    }
    else if ([self.strOrderType isEqualToString:@"卖货订单"]) {
        self.strOrderType = @"0";
    }
    else  {
        self.strOrderType = @"1";
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:[ConfigManager sharedInstance].strCustId  forKey:@"custId"];
    [parameter setObject:@"1" forKey:@"pageNumber"];
    [parameter setObject:@"20" forKey:@"pageSize"];
    [parameter setObject:startData.text forKey:@"startDate"];
    
    [parameter setObject:endData.text forKey:@"endDate"];
    [parameter setObject:self.strOrderType forKey:@"orderType"];
    
    [self httpQueryOrderList:parameter];
}

-(void)httpQueryOrderList:(NSDictionary*)parame
{
 
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrderList] parameters:parame];
    
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        self.items = [data objectForKey:@"datas"];
        [self.tableview reloadData];
        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}


@end
