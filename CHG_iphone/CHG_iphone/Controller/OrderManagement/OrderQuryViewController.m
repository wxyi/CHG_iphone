//
//  OrderQuryViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderQuryViewController.h"
#import "OrderQueryCell.h"
#import "AllOrdersCell.h"
@interface OrderQuryViewController ()<UUDatePickerDelegate>
@property UINib* OrderQueryNib;
@property UINib* AllOrdersNib;
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
    
    
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
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
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OrderQueryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderQueryCell"];
        if(cell==nil){
            cell = (OrderQueryCell*)[[self.OrderQueryNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        cell.starttime.inputView = self.startdatePicker;
        cell.endtime.inputView = self.enddatePicker;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.height = 360;
        [cell setupView:nil];
        cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
            
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 360;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 65;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    v_header.backgroundColor = UIColorFromRGB(0xdddddd);
    return v_header;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    //    v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_footer.backgroundColor = [UIColor clearColor];
    UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.text = @" 共3件商品";
    goodscountlab.font = FONT(13);
    goodscountlab.textAlignment = NSTextAlignmentLeft;
    [v_footer addSubview:goodscountlab];
    
    UILabel* pricelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    pricelab.text = @" 实付504.00元";
    pricelab.font = FONT(13);
    pricelab.textAlignment = NSTextAlignmentRight;
    [v_footer addSubview:pricelab];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    
    UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailsbtn.layer setMasksToBounds:YES];
    [detailsbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    [detailsbtn.layer setBorderWidth:1.0]; //边框
    [detailsbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
    detailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 32, 80, 30);
    [detailsbtn setTitle:@"详情" forState:UIControlStateNormal];
    detailsbtn.titleLabel.font = FONT(13);
    [detailsbtn setTitleColor:UIColorFromRGB(0x171c61) forState:UIControlStateNormal];
    [detailsbtn addTarget:self action:@selector(goskipdetails) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:detailsbtn];
    
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
@end
