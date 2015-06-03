//
//  StoresInfoViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoresInfoViewController.h"
#import "StoreManagementCell.h"
#import "StoresDetailsViewController.h"
#import "AddShoppersViewController.h"
@interface StoresInfoViewController ()
@property UINib* StoreManagementNib;
@end

@implementation StoresInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"门店信息";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.StoreManagementNib = [UINib nibWithNibName:@"StoreManagementCell" bundle:nil];
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
    StoreManagementCell *cell=[tableView dequeueReusableCellWithIdentifier:@"StoreManagementCell"];
    if(cell== nil){
        cell = (StoreManagementCell*)[[self.StoreManagementNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    NSString* imagename ;
    if (indexPath.row == 0) {
        imagename = @"icon_boss.png";
    }
    else if(indexPath.row == 1)
    {
        imagename = @"icon_Shopowner.png";
    }
    else
    {
        imagename = @"icon_shopping_guide.png";
    }
    cell.icon.image = [UIImage imageNamed:imagename];
    cell.clerkName.text = @"武新义";
    cell.clerkiphone.text = @"13382050875";
    cell.clerktype.text = @"门店老板";
    cell.sconImage.image = [QRCodeGenerator qrImageForString:@"神仙小武子" imageSize:60];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 70;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 1;
    }
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        
        v_header.backgroundColor = [UIColor whiteColor];
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor lightGrayColor];
        [v_header addSubview:line];
        UILabel* StoresName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH -20, 30)];
        
        StoresName.text = @"花相似";
        [v_header addSubview:StoresName];
        
        
        UILabel* address = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH -20, 30)];
        address.font = FONT(14);
        address.textColor = [UIColor grayColor];
        address.text = @"江苏省南京市雨花大道";
        [v_header addSubview:address];
        return v_header;
    }
    return nil;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    v_footer.backgroundColor = [UIColor whiteColor];
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [v_footer addSubview:line];
    UIButton* blockupbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    blockupbtn.tag = 102;
    [blockupbtn.layer setMasksToBounds:YES];
    [blockupbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [blockupbtn.layer setBorderWidth:1.0]; //边框
    blockupbtn.frame = CGRectMake(SCREEN_WIDTH-90, 2, 80, 30);
    [blockupbtn setTitle:@"停用" forState:UIControlStateNormal];
    [blockupbtn setTitle:@"启用" forState:UIControlStateSelected];
    [blockupbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [blockupbtn addTarget:self action:@selector(addStoresInfo:) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:blockupbtn];
    
    return v_footer;
}
-(IBAction)addStoresInfo:(UIButton*)sender
{
    if (sender.tag == 100) {
        DLog(@"添加店长");
    }
    else if(sender.tag == 101)
    {
        DLog(@"添加导购");
        AddShoppersViewController* AddShoppersView = [[AddShoppersViewController alloc] initWithNibName:@"AddShoppersViewController" bundle:nil];
        [self.navigationController pushViewController:AddShoppersView animated:YES];
    }
    else if(sender.tag == 102)
    {
        DLog(@"停用");
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoresDetailsViewController* StoresDetailsView = [[StoresDetailsViewController alloc] initWithNibName:@"StoresDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:StoresDetailsView animated:YES];
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
