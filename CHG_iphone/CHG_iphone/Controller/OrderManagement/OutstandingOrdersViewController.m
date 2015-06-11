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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"image",@"Hikid聪尔壮金装复合益生源或工工工工式工工工工工工",@"title",@"336",@"price",@"x 2",@"count", nil];

    
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
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = UIColorFromRGB(0x878787);;
    datelab.text = @"2015-05-19 10:10:10";
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = UIColorFromRGB(0x878787);
    orderstatus.text = @"已完成 卖货订单";
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
//    v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_footer.backgroundColor = [UIColor clearColor];
    UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.text = @" 共3件商品";
    goodscountlab.font = FONT(13);
    goodscountlab.textAlignment = NSTextAlignmentLeft;
    [v_footer addSubview:goodscountlab];
    
    UIButton* orderDetailsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderDetailsbtn.tag = 101;
    [orderDetailsbtn.layer setMasksToBounds:YES];
    [orderDetailsbtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [orderDetailsbtn.layer setBorderWidth:1.0]; //边框
    [orderDetailsbtn.layer setBorderColor:[UIColorFromRGB(0x171c61) CGColor]];
    orderDetailsbtn.frame = CGRectMake(SCREEN_WIDTH-90, 32, 80, 30);
    [orderDetailsbtn setTitle:@"详情" forState:UIControlStateNormal]
    ;
    orderDetailsbtn.titleLabel.font = FONT(14);
    [orderDetailsbtn setTitleColor:UIColorFromRGB(0x171c61) forState:UIControlStateNormal];
    [orderDetailsbtn addTarget:self action:@selector(goskipdetails:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:orderDetailsbtn];
    
    
    UIButton* Terminationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Terminationbtn.tag = 102;
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
    return v_footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedSubItemAction) {
        self.didSelectedSubItemAction(indexPath);
    }
}
-(void)goskipdetails:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
    }
    
    
}

-(IBAction)Returngoods:(UIButton*)sender
{
    if (self.didSkipSubItem) {
        self.didSkipSubItem(sender.tag);
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
