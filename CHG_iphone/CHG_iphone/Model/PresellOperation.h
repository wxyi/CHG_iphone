//
//  PresellOperation.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/7/9.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresellOperation : NSObject
@property(nonatomic,strong)NSString * strClickType;// 0 无操作 ，1 减去1 ，2 增加1
@property(nonatomic,strong)NSIndexPath* indexpath;//用于对哪个cell里边的商品进行操作

@property(nonatomic,strong)NSString* operationPage;//操作页面 0 扫描页面，1订单柜台
@end
