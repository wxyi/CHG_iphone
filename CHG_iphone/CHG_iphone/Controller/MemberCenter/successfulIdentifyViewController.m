//
//  successfulIdentifyViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "successfulIdentifyViewController.h"
#import "successfulIdentifyCell.h"
#import "MenuCell.h"

#import "SellingGoodsViewController.h"
#import "OrderManagementViewController.h"
#import "PresellGoodsViewController.h"
@interface successfulIdentifyViewController ()
@property UINib* successfulIdentifyNib;
@property UINib* MenuNib;
@end

@implementation successfulIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.successfulIdentifyNib = [UINib nibWithNibName:@"successfulIdentifyCell" bundle:nil];
    self.MenuNib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        successfulIdentifyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"successfulIdentifyCell"];
        if(cell==nil){
            cell = (successfulIdentifyCell*)[[self.successfulIdentifyNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.iphoneLab.text = @"13382050875";
        cell.nameLab.text = @"武新义";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        if(cell==nil){
            cell = (MenuCell*)[[self.MenuNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        
        NSArray* items = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"icon",@"卖货",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"image2.jpg",@"icon",@"预售",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"image3.jpg",@"icon",@"订单管理",@"title", nil],
                          nil];
        [cell setupView:items];
        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
            DLog(@"row = %ld",(long)indexPath.row);
            [weakSelf didSelectMenuCell:indexPath];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else
    {
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  150;
    }
    else
    {
        return 106;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return @"您还可以继续";
    }
    return @"";
}
-(void)didSelectMenuCell:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DLog(@"卖货");
            SellingGoodsViewController* SellingGoodsView = [[SellingGoodsViewController alloc] initWithNibName:@"SellingGoodsViewController" bundle:nil];
            [self.navigationController pushViewController:SellingGoodsView animated:YES];
            break;
        }
        case 1:
        {
            DLog(@"预售");
            
            PresellGoodsViewController* PresellGoodsView = [[PresellGoodsViewController alloc] initWithNibName:@"PresellGoodsViewController" bundle:nil];
            [self.navigationController pushViewController:PresellGoodsView animated:YES];
            break;
        }
        case 2:
        {
            DLog(@"订单管理");
            OrderManagementViewController* OrderManagementView = [[OrderManagementViewController alloc] initWithNibName:@"OrderManagementViewController" bundle:nil];
            [self.navigationController pushViewController:OrderManagementView animated:YES];
            break;
        }
        
        default:
            break;
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
