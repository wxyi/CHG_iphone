//
//  AddressInfo.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject
@property(nonatomic, strong) NSString *strAddress; //地址
@property(nonatomic, strong) NSString *strCityName; //市
@property(nonatomic, strong) NSString *strCityCode; //市代码
@property(nonatomic, strong) NSString *strProvinceName;//省
@property(nonatomic, strong) NSString *strprovinceCode;//省代码
@property(nonatomic, strong) NSString *strDistrictName;//区
@property(nonatomic, strong) NSString *strdistrictCode;//区代码
-(id) initWithDictionary:(NSDictionary*)jsonData;
@end
