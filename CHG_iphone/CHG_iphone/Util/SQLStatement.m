//
//  SQLStatement.m
//  seu_iphone
//
//  Created by fanxun on 14-4-29.
//  Copyright (c) 2014年 fanxun. All rights reserved.
//

#import "SQLStatement.h"

@implementation SQLStatement

NSString* const CT_SQL_BankCode=@"CREATE TABLE `tbl_bankcode` (`hId`  ,`bankName` varchar(200) NOT NULL,`bankCode` varchar(200) NOT NULL,`cardCodeList`  varchar(200) NOT NULL, PRIMARY KEY (`hId`))";

NSString* const R_SQL_BankCode=@"REPLACE INTO tbl_bankcode( `bankName` , `bankCode` , `cardCodeList`) VALUES ( ?, ?, ?  ) ";

NSString* const Q_SQL_BankCode=@"SELECT * FROM tbl_bankcode";

NSString* const Q_SQL_BankCodeByNumber=@"SELECT * FROM tbl_bankcode where cardCodeList  like  '%'||?||'%' ";

NSString* const Q_SQL_BankCodeByCode=@"SELECT * FROM tbl_bankcode where bankCode = ? ";

NSString* const D_SQL_BankCodeByCode = @"DELETE FROM tbl_bankcode where bankCode = ? ";
NSString* const D_SQL_BankCode = @"DELETE FROM tbl_bankcode ";


#pragma mark 创建省地址对照表
NSString* const CT_SQL_AddressProvinceCode = @"CREATE TABLE `tbl_addressprovince` (`hId`  ,`province` varchar(200) NOT NULL,`provinceID` varchar(200) NOT NULL, PRIMARY KEY (`hId`))";
#pragma mark 创建市地址对照表
NSString* const CT_SQL_AddressCityCode = @"CREATE TABLE `tbl_addresscity` (`hId`  ,`CityID` varchar(200) NOT NULL,`CityName` varchar(200) NOT NULL,`FatherID` varchar(200) NOT NULL, PRIMARY KEY (`hId`))";
#pragma mark 创建区地址对照表
NSString* const CT_SQL_AddressAreaCode = @"CREATE TABLE `tbl_addressarea` (`hId`  ,`AreaID` varchar(200) NOT NULL,`AreaName` varchar(200) NOT NULL,`FatherID` varchar(200) NOT NULL, PRIMARY KEY (`hId`))";

#pragma mark 新增或修改省地址对照表
NSString* const R_SQL_AddressProvinceCode = @"REPLACE INTO tbl_addressprovince( `province` , `provinceID`) VALUES ( ?, ? ) ";
#pragma mark 新增或修改市地址对照表
NSString* const R_SQL_AddressCityCode = @"REPLACE INTO tbl_addresscity( `CityID` , `CityName` , `FatherID`) VALUES ( ?, ?, ?  ) ";
#pragma mark 新增或修改区地址对照表
NSString* const R_SQL_AddressAreaCode = @"REPLACE INTO tbl_addressarea( `AreaID` , `AreaName` , `FatherID`) VALUES ( ?, ?, ?  ) ";

#pragma mark 查询省地址对照表
NSString* const Q_SQL_AddressProvinceCode=@"SELECT * FROM tbl_addressprovince";;
#pragma mark 查询省地址对照表
NSString* const Q_SQL_AddressAreaCode=@"SELECT * FROM tbl_addresscity";
#pragma mark 查询省地址对照表
NSString* const Q_SQL_AddressCityCode=@"SELECT * FROM tbl_addressarea";

#pragma mark 查询银行卡某个Code
NSString* const Q_SQL_AddressCitybyFatherID = @"SELECT * FROM tbl_addresscity where FatherID = ?";

#pragma mark 查询银行卡某个Code
NSString* const Q_SQL_AddressAreabyFatherID = @"SELECT * FROM tbl_addressarea where FatherID = ?";;

NSString* const D_SQL_AddressProvinceCode= @"DELETE FROM tbl_addressprovince ";
NSString* const D_SQL_AddressCity = @"DELETE FROM tbl_addresscity ";
NSString* const D_SQL_AddressArea = @"DELETE FROM tbl_addressarea ";


//根据省ＩＤ查询省名称
NSString* const Q_SQL_AddressProvinceCodeByProvinceID = @"SELECT * FROM tbl_addressprovince where provinceID = ?";
//根据市ＩＤ查询市名称
NSString* const Q_SQL_AddressCityByCityID = @"SELECT * FROM tbl_addresscity where CityID = ?";
//根据区ＩＤ查询区名称
NSString* const Q_SQL_AddressAreaByDistrictID= @"SELECT * FROM tbl_addressarea where AreaID = ?";

//根据名字查找
//NSString* const Q_SQL_ProvinceIDByProvince = @"SELECT * FROM tbl_addressprovince where province = ?";;
@end