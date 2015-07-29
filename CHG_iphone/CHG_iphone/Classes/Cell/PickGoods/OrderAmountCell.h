//
//  OrderAmountCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAmountCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UITextField* receivablelab;
@property(nonatomic,weak)IBOutlet UITextField* Receivedlab;
@property(nonatomic,weak)IBOutlet UITextField* favorablelab;
@property(nonatomic,assign)BOOL isHaveDian;
@property(nonatomic,assign)SaleType orderSaletype;
@property(nonatomic,copy)OrderPrice orderpriceBlock;
@property(nonatomic,assign)double allprice;
@end
