//
//  ConfirmOrderViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConfirmOrderCell.h"
#import "PickGoodsViewController.h"
@interface ConfirmOrderViewController ()
@property UINib* ConfirmOrderNib;
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单完成";
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
    self.ConfirmOrderNib = [UINib nibWithNibName:@"ConfirmOrderCell" bundle:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfirmOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell"];
    if(cell==nil){
        cell = (ConfirmOrderCell*)[[self.ConfirmOrderNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    titlelab.text = @"您还可以继续操作";
    titlelab.textColor = [UIColor lightGrayColor];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [v_footer addSubview:titlelab];
    UIButton* detailsbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    detailsbtn.frame = CGRectMake(6, 65, CGRectGetWidth(self.view.bounds)-12, 35);
    [detailsbtn.layer setMasksToBounds:YES];
    [detailsbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [detailsbtn setBackgroundColor:UIColorFromRGB(0x171c61)];
    [detailsbtn setTitle:@"订单详情" forState:UIControlStateNormal];
    [detailsbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [detailsbtn addTarget:self action:@selector(detailsbtn) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:detailsbtn];
    
    return v_footer;
}

-(void)detailsbtn
{
    DLog(@"订单详情");
    PickGoodsViewController* PickGoodsView = [[PickGoodsViewController alloc] initWithNibName:@"PickGoodsViewController" bundle:nil];
    [self.navigationController pushViewController:PickGoodsView animated:YES];
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
