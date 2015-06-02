//
//  DidPickGoodsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "DidPickGoodsViewController.h"
#import "AllOrdersCell.h"
#import "amountCell.h"
@interface DidPickGoodsViewController ()
@property UINib* AllOrdersNib;
@property UINib* amountNib;
@end

@implementation DidPickGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"以提货";
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
-(IBAction)orderProcessing:(UIButton*)sender
{
    DLog(@"退货");
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
    self.amountNib = [UINib nibWithNibName:@"amountCell" bundle:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return  1;
    }
    return self.items.count;
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
        amountCell *cell=[tableView dequeueReusableCellWithIdentifier:@"amountCell"];
        if(cell==nil){
            cell = (amountCell*)[[self.amountNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.nameLab.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.priceLab.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"price"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 410;
    }
    return 40;
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
    
    UILabel* Pickuplab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    Pickuplab.text = @"共提货2次";
    Pickuplab.font = FONT(14);
    Pickuplab.textAlignment = NSTextAlignmentRight;
    [v_footer addSubview:Pickuplab];
    
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
