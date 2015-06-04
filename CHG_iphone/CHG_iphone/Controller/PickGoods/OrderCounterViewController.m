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
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.orderSaletype == SaleTypeSellingGoods) {
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
            
            
            cell.GoodsImage.image = [UIImage imageNamed:[self.dict objectForKey:@"image"]];
            cell.titlelab.text = [self.dict  objectForKey:@"title"];
            cell.pricelab.text = @"111";
           [cell setupCell];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
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
        if (self.orderSaletype == SaleTypePickingGoods ||self.orderSaletype == SaleTypeReturnGoods) {
            PickAndReturnCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PickAndReturnCell"];
            if(cell==nil){
                cell = (PickAndReturnCell*)[[self.PickAndReturnNib instantiateWithOwner:self options:nil] objectAtIndex:0];
                
            }
            if (self.orderSaletype == SaleTypePickingGoods) {
                cell.receivableNameLab.text =@"应收金额";
                cell.actualNameLab.text = @"实收金额";
            }
            else
            {
                cell.receivableNameLab.text =@"应退金额";
                cell.actualNameLab.text = @"实退金额";
                [cell.actualtext setEnabled:NO];
            }
            cell.receivableLab.text = @"$336";
            cell.actualtext.text = @"220";
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
            cell.receivablelab.text = @"$336";
            cell.favorablelab.text = @"16";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

        }
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
    if (sender.tag == 100) {
        DLog(@"继续扫描")

        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(sender.tag == 101)
    {
        if (self.orderSaletype == SaleTypeReturnGoods) {
            DLog(@"确认退货");
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认退货商品" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
          
                
                
            } otherButtonBlock:^{
                DLog(@"是");
           
            }];
        }
        else if(self.orderSaletype == SaleTypePickingGoods)
        {
            DLog(@"确认提货");
        }
        else
        {
            DLog(@"确认订单");
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否需要添加赠品" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
                ConfirmOrderViewController* ConfirmOrderView = [[ConfirmOrderViewController alloc] initWithNibName:@"ConfirmOrderViewController" bundle:nil];
                [self.navigationController pushViewController:ConfirmOrderView animated:YES];
                
                
            } otherButtonBlock:^{
                DLog(@"是");
                
                [self.navigationController popViewControllerAnimated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
