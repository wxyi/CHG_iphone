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
@interface OrderCounterViewController ()
@property UINib* OrdersGoodsNib;
@property UINib* OrderGiftNib;
@property UINib* OrderAmountNib;
@end

@implementation OrderCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    self.dict = [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"image",@"Hikid聪尔壮金装复合益生源或工工工工式工工工工工工",@"title",@"336",@"price",@"X 2",@"count", nil];
    
    
//    self.items = [NSArray arrayWithObjects:[NSArray arrayWithObjects:dict,dict,dict, nil],[NSArray arrayWithObjects:dict,dict, nil], nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
//    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.OrderGiftNib = [UINib nibWithNibName:@"OrderGiftCell" bundle:nil];
    
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
        if(cell==nil){
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
   
        cell.GoodImage.image = [UIImage imageNamed:[self.dict objectForKey:@"image"]];
        cell.titlelab.text = [self.dict  objectForKey:@"title"];
        cell.pricelab.text = @"111";//[dict objectForKey:@"price"];
        cell.countlab.text = [self.dict  objectForKey:@"count"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        OrderGiftCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderGiftCell"];
        if(cell==nil){
            cell = (OrderGiftCell*)[[self.OrderGiftNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        [cell setupCell];
        
        
        cell.GoodImage.image = [UIImage imageNamed:[self.dict objectForKey:@"image"]];
        cell.titlelab.text = [self.dict objectForKey:@"title"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
        if(cell==nil){
            cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.receivablelab.text = @"$336";
        cell.favorablelab.text = @"16";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 30;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"商品";
    }
    else if(section == 1)
    {
        return @"赠品";
    }
    else
        return @"";
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 60;
    }
    return 90;
}
-(IBAction)OrderCounterView:(UIButton*)sender
{
    if (sender.tag == 100) {
        DLog(@"继续扫描")
//        PresellGoodsViewController* PresellGoodsView= [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
//        [self.navigationController pushViewController:PresellGoodsView animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(sender.tag == 101)
    {
        DLog(@"确认订单");
        ConfirmOrderViewController* ConfirmOrderView = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
        [self.navigationController pushViewController:ConfirmOrderView animated:YES];
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
