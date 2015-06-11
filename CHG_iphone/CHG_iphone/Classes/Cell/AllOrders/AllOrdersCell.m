//
//  AllOrdersCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AllOrdersCell.h"
#import "OrdersGoodsCell.h"
#import "OrderGiftCell.h"
@interface AllOrdersCell ()
@property UINib* OrdersGoodsNib;
@property UINib* OrderGiftNib;
@end
@implementation AllOrdersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupView:(NSArray *)items
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"image",@"Hikid聪尔壮金装复合益生源或工工工工式工工工工工工",@"title",@"336",@"price",@"x 2",@"count", nil];
    
    NSDictionary* dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"image1.jpg",@"image",@"Hikid聪尔壮金装复合益生源或工工工工式工工工工工工",@"title",@"x 2",@"count", nil];
    
    
    
    self.allitems = [NSArray arrayWithObjects:[NSArray arrayWithObjects:dict,dict,dict, nil],[NSArray arrayWithObjects:dict1,dict1, nil], nil];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.OrderGiftNib = [UINib nibWithNibName:@"OrderGiftCell" bundle:nil];
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allitems count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.allitems objectAtIndex:section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
        if(cell==nil){
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        NSDictionary* dict =  [[self.allitems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
        
        cell.GoodImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        cell.titlelab.text = [dict objectForKey:@"title"];
        cell.pricelab.text = [dict objectForKey:@"price"];
        cell.countlab.text = [dict objectForKey:@"count"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else
    {
        OrderGiftCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderGiftCell"];
        if(cell==nil){
            cell = (OrderGiftCell*)[[self.OrderGiftNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        NSDictionary* dict =  [[self.allitems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
        
        [cell setupCell];
        cell.GoodImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        cell.titlelab.text = [dict objectForKey:@"title"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30)];
//    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_header.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, 30)];
        datelab.textAlignment = NSTextAlignmentLeft;
        datelab.font = FONT(13);
        datelab.textColor = UIColorFromRGB(0x878787);
        datelab.text = @"2015-05-19 10:10:10";
        [v_header addSubview:datelab];
        
        
        UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, 30)];
        orderstatus.textAlignment = NSTextAlignmentRight;
        orderstatus.font = FONT(13);
        orderstatus.textColor = UIColorFromRGB(0x878787);
        orderstatus.text = @"已完成 卖货订单";
        [v_header addSubview:orderstatus];
        
    }
    else
    {
        UILabel* namelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, 30)];
        namelab.textAlignment = NSTextAlignmentLeft;
        namelab.font = FONT(13);
        namelab.textColor = UIColorFromRGB(0x878787);
        namelab.text = @"赠品";
        [v_header addSubview:namelab];
    }
    
    return v_header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedSubItemAction) {
        self.didSelectedSubItemAction(indexPath);
    }
}
- (void)layoutSubviews //在这里进行元素的详细设置
{
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    rect.size.height = self.height;
    self.frame = rect;
    //    self.contentView.frame = rect;
    DLog(@"self.frame = %@",NSStringFromCGRect(self.frame) );
}

@end
