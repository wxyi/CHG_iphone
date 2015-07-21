//
//  MyAccountCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/7/7.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MyAccountCell.h"
#import "RewardsCell.h"
#import "SettlementCell.h"
#import "GrowthCell.h"

@interface MyAccountCell ()
@property UINib* RewardsNib;
@property UINib* SettlementNib;
@property UINib* GrowthNib;
@end
@implementation MyAccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUpCell
{
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.RewardsNib = [UINib nibWithNibName:@"RewardsCell" bundle:nil];
    self.SettlementNib = [UINib nibWithNibName:@"SettlementCell" bundle:nil];
    self.GrowthNib = [UINib nibWithNibName:@"GrowthCell" bundle:nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
//    if (indexPath.section == 0) {
//        RewardsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RewardsCell"];
//        if(cell==nil){
//            cell = (RewardsCell*)[[self.RewardsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        
//        
//        
//        NSArray* itme = [NSArray arrayWithObjects:
//                         [NSDictionary dictionaryWithObjectsAndKeys:@"奖励余额(元)",@"title",[NSString stringWithFormat:@"%.2f",[self.dictionary[@"awardUsing"] doubleValue]],@"count", nil],
//                         [NSDictionary dictionaryWithObjectsAndKeys:@"累计奖励收益(元)",@"title",[NSString stringWithFormat:@"%.2f",[self.dictionary[@"awardTotal"] doubleValue]],@"count", nil], nil];
//        cell.RewardsView.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        cell.isMy = YES;
//        [cell setupView:[itme mutableCopy]];
//        
//        cell.didSelectedSubItemAction = ^(NSIndexPath* indexPath){
//            DLog(@"row = %ld",(long)indexPath.row);
//            //            [weakSelf didSelectRewardsCell:indexPath];
//        };
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
//    else
    if(indexPath.section == 0)
    {
        SettlementCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SettlementCell"];
        if(cell==nil){
            cell = (SettlementCell*)[[self.SettlementNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
//        cell.CardNumlab.text = @"6210*******79263";
        
        
        cell.datelab.text = [self.dictionary objectForKeySafe:@"amountDate"];
        cell.statelab.text = @"支出";
        cell.namelab.text = @"晨冠已结算";
        
       
        cell.pricelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.dictionary objectForKeySafe:@"awardArrive"] doubleValue]];
        cell.BankCardlab.text = [self.dictionary objectForKeySafe:@"awardArriveBank"];
        cell.CardNumlab.text = [self.dictionary objectForKeySafe:@"awardAccount"];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        GrowthCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrowthCell"];
        if(cell==nil){
            cell = (GrowthCell*)[[self.GrowthNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        
        if (indexPath.section == 2 ) {
            cell.datelab.text = [self.dictionary objectForKeySafe:@"amountDate"];
            cell.statelab.text = @"收入";
            cell.namelab.text = @"动销奖励";
            
            
            cell.iphonelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.dictionary objectForKeySafe:@"awardSaleAmount"] doubleValue]];;
            
            cell.skipbtn.tag = 101;
        }
        else
        {
            cell.datelab.text = [self.dictionary objectForKeySafe:@"amountDate"];
            cell.statelab.text = @"收入";
            cell.namelab.text = @"消费分账奖励";
            
            
            cell.iphonelab.text = [NSString stringWithFormat:@"￥%.2f",[[self.dictionary objectForKeySafe:@"awardPartnerAmount"] doubleValue]];

            cell.skipbtn.tag = 102;
        }
        
        cell.iphonelab.textColor = UIColorFromRGB(0xf5a541);
        cell.didSkipSubItem = ^(NSInteger tag){
            
            [weakSelf goskipdetails:tag];
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
//    else if(section == 1)
//    {
//        return 30;
//    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 75;
//    }
//    else
    if(indexPath.section == 0)
    {
        return 90;
    }
    else
        return 105;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        //        v_header.backgroundColor = UIColorFromRGB(0xdddddd);;
//        UILabel* detaillab = [[UILabel alloc] initWithFrame:v_header.frame];
//        detaillab.textAlignment = NSTextAlignmentCenter;
//        detaillab.textColor = [UIColor grayColor];
//        detaillab.text = @"账户明细";
//        detaillab.font = FONT(14);
//        [v_header addSubview:detaillab];
//        return v_header;
//    }
//    return nil;
//}
-(void)goskipdetails:(NSInteger)tag
{
    if (self.accountSkip) {
        self.accountSkip(tag,[self.dictionary objectForKeySafe:@"amountDate"]);
    }
    
}
@end
