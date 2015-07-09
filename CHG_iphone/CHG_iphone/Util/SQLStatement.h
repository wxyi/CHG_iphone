//
//  SQLStatement.h
//  seu_iphone
//
//  Created by fanxun on 14-4-29.
//  Copyright (c) 2014年 fanxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLStatement : NSObject

#pragma mark 创建银行卡对照表
extern NSString* const CT_SQL_BankCode;
#pragma mark 新增或修改银行卡对照表
extern NSString* const R_SQL_BankCode;
#pragma mark 查询银行卡对照表
extern NSString* const Q_SQL_BankCode;
#pragma mark 查询银行卡某个前六位数字
extern NSString* const Q_SQL_BankCodeByNumber;
#pragma mark 查询银行卡某个Code
extern NSString* const Q_SQL_BankCodeByCode;
#pragma mark 删除BankCode相关数据
extern NSString* const D_SQL_BankCodeByCode;

#pragma mark 删除银行卡对照表所有数据
extern NSString* const D_SQL_BankCode;


#pragma mark 创建省地址对照表
extern NSString* const CT_SQL_AddressProvinceCode;
#pragma mark 创建市地址对照表
extern NSString* const CT_SQL_AddressCityCode;
#pragma mark 创建区地址对照表
extern NSString* const CT_SQL_AddressAreaCode;

//插入
#pragma mark 新增或修改省地址对照表
extern NSString* const R_SQL_AddressProvinceCode;
#pragma mark 新增或修改市地址对照表
extern NSString* const R_SQL_AddressCityCode;
#pragma mark 新增或修改区地址对照表
extern NSString* const R_SQL_AddressAreaCode;

//查询
#pragma mark 查询省地址对照表
extern NSString* const Q_SQL_AddressProvinceCode;
#pragma mark 查询省地址对照表
extern NSString* const Q_SQL_AddressAreaCode;
#pragma mark 查询省地址对照表
extern NSString* const Q_SQL_AddressCityCode;
#pragma mark 查询市地址对照表
extern NSString* const Q_SQL_AddressCitybyFatherID;
#pragma mark 查询区地址对照表
extern NSString* const Q_SQL_AddressAreabyFatherID;

//根据省ＩＤ查询省名称
extern NSString* const Q_SQL_AddressProvinceCodeByProvinceID;
//根据省ＩＤ查询省名称
extern NSString* const Q_SQL_ProvinceIDByProvince;

//根据市ＩＤ查询市名称
extern NSString* const Q_SQL_AddressCityByCityID;
//根据区ＩＤ查询区名称
extern NSString* const Q_SQL_AddressAreaByDistrictID;

//删除
extern NSString* const D_SQL_AddressProvinceCode;
extern NSString* const D_SQL_AddressCity;
extern NSString* const D_SQL_AddressArea;

@end
