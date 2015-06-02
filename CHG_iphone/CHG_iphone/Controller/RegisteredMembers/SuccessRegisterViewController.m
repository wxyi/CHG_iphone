//
//  SuccessRegisterViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SuccessRegisterViewController.h"
#import "SuccessRegistereCell.h"
#import "MenuCell.h"

#import "SellingGoodsViewController.h"
#import "PresellGoodsViewController.h"
@interface SuccessRegisterViewController ()
@property UINib* SuccessRegistereNib;
@property UINib* MenuNib;
@end

@implementation SuccessRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setupView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.SuccessRegistereNib = [UINib nibWithNibName:@"SuccessRegistereCell" bundle:nil];
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
        SuccessRegistereCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SuccessRegistereCell"];
        if(cell==nil){
            cell = (SuccessRegistereCell*)[[self.SuccessRegistereNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
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
                          [NSDictionary dictionaryWithObjectsAndKeys:@"",@"icon",@"",@"title", nil],
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
        
            
        default:
            break;
    }
}
@end