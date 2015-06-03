//
//  DidNotPickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "DidNotPickGoodsViewController.h"
#import "AllOrdersCell.h"
#import "OrderAmountCell.h"
@interface DidNotPickGoodsViewController ()
@property UINib* AllOrdersNib;
@property UINib* OrderAmountNib;
@end

@implementation DidNotPickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未提货";
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}

-(void)setupView
{

    self.items = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"应收金额",@"title",@"$504",@"price", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"实收金额",@"title",@"$504",@"price", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"优惠金额",@"title",@"$504",@"price", nil],nil];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.AllOrdersNib = [UINib nibWithNibName:@"AllOrdersCell" bundle:nil];
    self.OrderAmountNib = [UINib nibWithNibName:@"OrderAmountCell" bundle:nil];
//    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
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
    }
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
        AllOrdersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AllOrdersCell"];
        if(cell==nil){
            cell = (AllOrdersCell*)[[self.AllOrdersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        [cell setupView:nil];
        return cell;
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
        return 410;
    }
    return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 10;
    }
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
    if (section != 0) {
        return nil;
    }
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    v_footer.backgroundColor = [UIColor whiteColor];
    UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.text = @" 共3件商品 1件赠品";
    goodscountlab.font = FONT(14);
    goodscountlab.textAlignment = NSTextAlignmentLeft;
    [v_footer addSubview:goodscountlab];

    return v_footer;
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
