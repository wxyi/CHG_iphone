//
//  OrderAmountCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAmountCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet NoCopyTextField* receivablelab;
@property(nonatomic,weak)IBOutlet NoCopyTextField* Receivedlab;
@property(nonatomic,weak)IBOutlet NoCopyTextField* favorablelab;
@property(nonatomic,assign)BOOL isHaveDian;
@property(nonatomic,assign)SaleType orderSaletype;
@property(nonatomic,copy)OrderPrice orderpriceBlock;
@property(nonatomic,assign)double allprice;
@property (nonatomic, copy) GetCheckCode didGetCode;
@end
