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
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"
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
-(void)setupAllOrderView:(NSDictionary *)items
{
    self.allitems = items;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    self.OrdersGoodsNib = [UINib nibWithNibName:@"OrdersGoodsCell" bundle:nil];
    self.OrderGiftNib = [UINib nibWithNibName:@"OrderGiftCell" bundle:nil];
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.allitems objectForKey:@"productList"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
        OrdersGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrdersGoodsCell"];
        if(cell==nil){
            cell = (OrdersGoodsCell*)[[self.OrdersGoodsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        NSDictionary* dict =  [[self.allitems objectForKey:@"productList"] objectAtIndex:indexPath.row] ;
        
        [cell.GoodImage setImageWithURL:[NSURL URLWithString:dict[@"productSmallUrl"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        cell.titlelab.text = dict[@"productName"];
        cell.pricelab.text = dict[@"productPrice"];
    
    int goodNum = 0;
    if (self.picktype == PickUpTypeDid) {
        goodNum = [[dict objectForKey:@"quantity"] intValue] -  [[dict objectForKey:@"remainQuantity"] intValue] - [[dict objectForKey:@"returnQuantity"] intValue];
    }
    else if(self.picktype == PickUpTypeFinish  || self.picktype == PickUpTypeStop)
    {
        goodNum = [[dict objectForKey:@"quantity"] intValue];
    }
    else
    {
        goodNum = [[dict objectForKey:@"remainQuantity"] intValue];
    }
    
    if ([dict[@"returnQuantity"] intValue] != 0 && self.picktype != PickUpTypeDidNot) {
        cell.returnCountlab.text = [NSString stringWithFormat:@"已退货%d件",[dict[@"returnQuantity"] intValue]];
    }
        cell.countlab.text = [NSString stringWithFormat:@"x %d",goodNum ];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
//    }
//    else
//    {
//        OrderGiftCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderGiftCell"];
//        if(cell==nil){
//            cell = (OrderGiftCell*)[[self.OrderGiftNib instantiateWithOwner:self options:nil] objectAtIndex:0];
//            
//        }
//        NSDictionary* dict =  [[self.allitems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] ;
//        
//        [cell setupCell];
//        cell.GoodImage.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
//        cell.titlelab.text = [dict objectForKey:@"title"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        return cell;
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.picktype == PickUpTypeStop) {
        return 30;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    //    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    v_header.backgroundColor = [UIColor clearColor];
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//    line.backgroundColor = UIColorFromRGB(0xdddddd);
//    [v_header addSubview:line];
    
    UILabel* namelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, 30)];
    namelab.textAlignment = NSTextAlignmentLeft;
    namelab.font = FONT(13);
    namelab.textColor = UIColorFromRGB(0x878787);
    if (self.picktype == PickUpTypeFinish  || self.picktype == PickUpTypeStop) {
        namelab.text = @"商品";
    }
    else if(self.picktype == PickUpTypeDidNot)
    {
        namelab.text = @"未提商品";
    }
    else
    {
        namelab.text = @"已提商品";
    }
    
    [v_header addSubview:namelab];
    
    if (self.picktype != PickUpTypeStop) {
        UILabel* orderstatus = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, 30)];
        orderstatus.textAlignment = NSTextAlignmentRight;
        orderstatus.font = FONT(13);
        orderstatus.textColor = UIColorFromRGB(0x878787);
        if (self.picktype != PickUpTypeFinish)
        {
            orderstatus.text = [NSString stringWithFormat:@"制单人:%@",self.allitems[@"orderCreator"]];;
        }
        [v_header addSubview:orderstatus];
        
        //    NSDictionary* dict = [self.items objectAtIndex:section] ;
        UILabel* datelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-20, 30)];
        datelab.textAlignment = NSTextAlignmentLeft;
        datelab.font = FONT(13);
        datelab.textColor = UIColorFromRGB(0x878787);;
        datelab.text = self.allitems[@"orderDate"];
        [v_header addSubview:datelab];
        
        
        UILabel* Seriallab = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-20, 30)];
        Seriallab.textAlignment = NSTextAlignmentRight;
        Seriallab.font = FONT(13);
        Seriallab.textColor = UIColorFromRGB(0x878787);;
        Seriallab.text = [NSString stringWithFormat:@"订单编号:%d",[self.allitems[@"orderId"] intValue]];
        
        [v_header addSubview:Seriallab];

    }
    
    return v_header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    v_footer.backgroundColor = [UIColor clearColor];
//    UILabel* goodscountlab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    NSArray* productList = self.allitems[@"productList"];
    NSInteger count = 0;
    if (self.picktype == PickUpTypeDid)
    {
        for (int i = 0; i< [productList count]; i++) {
            NSInteger remainQuantity= [productList[i][@"remainQuantity"] integerValue];
            NSInteger quantity= [productList[i][@"quantity"] integerValue];
            NSInteger returnQuantity= [productList[i][@"returnQuantity"] integerValue];
            count += quantity - remainQuantity - returnQuantity;
        }
    }
    else
    {
        for (int i = 0; i< [productList count]; i++) {
            count += [productList[i][@"remainQuantity"] intValue];
        }
    }
    
    
    NSString* string = [NSString stringWithFormat:@"共%ld件商品",(long)count];
    NSRange rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%ld",(long)count]];
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
    
    NIAttributedLabel* goodscountlab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
    goodscountlab.font = FONT(15);
    goodscountlab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    goodscountlab.attributedText = text;
    [v_footer addSubview:goodscountlab];
    

    if (self.picktype == PickUpTypeDid) {
        string = [NSString stringWithFormat:@"共提货%d次",[self.allitems[@"getGoodsNum"] intValue]];
        rangeOfstart = [string rangeOfString:[NSString stringWithFormat:@"%d",[self.allitems[@"getGoodsNum"] intValue]]];
        text = [[NSMutableAttributedString alloc] initWithString:string];
        [text setTextColor:UIColorFromRGB(0xF5A541) range:rangeOfstart];
        
        
        
        
        //设置一个行高上限
        CGSize size = CGSizeMake(320,2000);
        //计算实际frame大小，并将label的frame变成实际大小
        CGSize labelsize = [string sizeWithFont:FONT(15) constrainedToSize:size];
        
        
        NIAttributedLabel* pricelab = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - labelsize.width+5, 0, labelsize.width, 30)];
        
        pricelab.font = FONT(15);
        pricelab.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
        pricelab.textAlignment = NSTextAlignmentRight;
        pricelab.attributedText = text;
        [v_footer addSubview:pricelab];
    }
    return v_footer;
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
    
    CGRect rect = self.tableview.frame;
    rect.size.height = self.height;
    self.tableview.frame = rect;
    //    self.contentView.frame = rect;
    DLog(@"self.frame = %@",NSStringFromCGRect(self.frame) );
}

@end
