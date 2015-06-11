//
//  DidNotPickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "DidNotPickGoodsViewController.h"
//#import "AllOrdersCell.h"
#import "OrderAmountCell.h"
#import "OrdersGoodsCell.h"

@interface DidNotPickGoodsViewController ()
//@property UINib* AllOrdersNib;
@property UINib* OrderAmountNib;
@property UINib* OrdersGoodsNib;
@end

@implementation DidNotPickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未提货";
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
    [self setupView];
}

-(void)setupView
{

    
    self.items = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"应收金额",@"title",@"$504",@"price", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"实收金额",@"title",@"$504",@"price", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"优惠金额",@"title",@"$504",@"price", nil],nil];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
//    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
//    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
    if (self.picktype == PickUpTypeDidNot) {
        self.Returnbtn.hidden = YES;
        self.Terminationbtn.hidden = NO;
        self.PickUpbtn.hidden = NO;
    }
    else
    {
        self.Returnbtn.hidden = NO;
        self.Terminationbtn.hidden = YES;
        self.PickUpbtn.hidden = YES;

    }
}
-(IBAction)orderProcessing:(UIButton*)sender
{
    if (sender.tag == 100) {
        DLog(@"终止订单");
        self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确定终止订单" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
            DLog(@"否");
            
            
        } otherButtonBlock:^{
            DLog(@"是");
            
        }];
        
        [self.stAlertView show];
    }
    else if(sender.tag == 101)
    {
        DLog(@"提货");
        if (self.didSkipSubItem) {
            self.didSkipSubItem(sender.tag);
        }
    }
    else if(sender.tag == 102)
    {
        DLog(@"退货");
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
        if(cell==nil){
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
//        NSDictionary* dict =  [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
        
        cell.GoodImage.image = [UIImage imageNamed:@"image1.jpg"];
        cell.titlelab.text = @"理；大口日大日大田土日大田日土田大日";
        cell.pricelab.text = @"111";//[dict objectForKey:@"price"];
        cell.countlab.text = @"500";
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
//        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
//        if(cell==nil){
//            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        cell.height = 360;
//        [cell setupView:nil];
//        cell.didSelectedSubItemAction=^(NSIndexPath* indexPath){
//            if (self.didSelectedSubItemAction) {
//                self.didSelectedSubItemAction(indexPath);
//            }
//        };
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
    }
    else
    {
        OrderAmountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderAmountCell"];
        if(cell==nil){
            cell = (OrderAmountCell*)[[self.OrderAmountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
       
        cell.receivablelab.text = @"$336";
        cell.Receivedlab.text = @"320";
        [cell.Receivedlab setEnabled:NO];
        cell.favorablelab.text = @"16";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 65;
    }
    else if(indexPath.section == 1)
    {
        return 90;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return nil;
    }
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    //    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_header.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    line.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_header addSubview:line];
    
    UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    datelab.textAlignment = NSTextAlignmentLeft;
    datelab.font = FONT(13);
    datelab.textColor = UIColorFromRGB(0x878787);
    if (self.picktype == PickUpTypeDid) {
        datelab.text = @"已提商品";
    }
    else
        datelab.text = @"未提商品";
    [v_header addSubview:datelab];
    
    
    UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds)-20, 30)];
    orderstatus.textAlignment = NSTextAlignmentRight;
    orderstatus.font = FONT(13);
    orderstatus.textColor = UIColorFromRGB(0x878787);;
    orderstatus.text = @"制单人:武新义(导购)";
    [v_header addSubview:orderstatus];
    
    return v_header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        v_footer.backgroundColor = UIColorFromRGB(0xf0f0f0);
        v_footer.backgroundColor = [UIColor clearColor];
        UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
        goodscountlab.text = @" 共3件商品";
        goodscountlab.font = FONT(13);
//        goodscountlab.textColor = UIColorFromRGB(<#rgbValue#>)
        goodscountlab.textAlignment = NSTextAlignmentLeft;
        [v_footer addSubview:goodscountlab];
        
        return v_footer;
    }
    return nil;
    
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
