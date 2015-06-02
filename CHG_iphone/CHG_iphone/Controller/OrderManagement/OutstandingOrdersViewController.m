//
//  OutstandingOrdersViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OutstandingOrdersViewController.h"
#import "OrdersGoodsCell.h"
#import "PickGoodsViewController.h"
@interface OutstandingOrdersViewController ()
@property UINib* OrdersGoodsNib;
@end

@implementation OutstandingOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未完成订单";
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"image",@"Hikid聪尔壮金装复合益生源或工工工工式工工工工工工",@"title",@"336",@"price",@"X 2",@"count", nil];

    
    self.items = [NSArray arrayWithObjects:[NSArray arrayWithObjects:dict,dict,dict, nil],[NSArray arrayWithObjects:dict,dict, nil], nil];
    [self.tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.items objectAtIndex:section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
    if(cell==nil){
        cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    NSDictionary* dict =  [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
    
    cell.GoodImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    cell.titlelab.text = [dict objectForKey:@"title"];
    cell.pricelab.text = @"111";//[dict objectForKey:@"price"];
    cell.countlab.text = [dict objectForKey:@"count"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    v_header.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 14)];
    line.backgroundColor = [UIColor grayColor];
    [v_header addSubview:line];
    
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, CGRectGetWidth(self.view.bounds)-20, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = [UIColor lightGrayColor];
    datelab.text = @"2015-05-19 10:10:10";
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, CGRectGetWidth(self.view.bounds)-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = [UIColor lightGrayColor];
    orderstatus.text = @"已完成 卖货订单";
    [v_header addSubview:orderstatus];

    return v_header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    v_footer.backgroundColor = [UIColor whiteColor];
    
    UIButton* orderDetailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderDetailsbtn.tag = 101;
    [orderDetailsbtn.layer setMasksToBounds:YES];
    [orderDetailsbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [orderDetailsbtn.layer setBorderWidth:1.0]; //边框
    orderDetailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 40);
    [orderDetailsbtn setTitle:@"订单详情" forState:UIControlStateNormal];
    [orderDetailsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderDetailsbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:orderDetailsbtn];
    
    
    UIButton* Terminationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Terminationbtn.tag = 102;
    [Terminationbtn.layer setMasksToBounds:YES];
    [Terminationbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [Terminationbtn.layer setBorderWidth:1.0]; //边框
    Terminationbtn.frame = CGRectMake(SCREEN_WIDTH-90*2, 2, 80, 40);
    [Terminationbtn setTitle:@"终止订单" forState:UIControlStateNormal];
    [Terminationbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Terminationbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:Terminationbtn];
    return v_footer;
}
-(void)goskipdetails:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
    
    
}

-(IBAction)Returngoods:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (btn.tag == 103) {
        DLog(@" 退货");
    }
    else if(btn.tag == 104)
    {
        DLog(@"提货");
    }
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
