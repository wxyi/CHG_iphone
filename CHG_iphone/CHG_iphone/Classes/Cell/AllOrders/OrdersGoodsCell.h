//
//  OrdersGoodsCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/26.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersGoodsCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* GoodImage;
@property(nonatomic,weak)IBOutlet UILabel* titlelab;
@property(nonatomic,weak)IBOutlet UILabel* pricelab;
@property(nonatomic,weak)IBOutlet UILabel* countlab;
@property(nonatomic,weak)IBOutlet UILabel* returnCountlab;
@end
