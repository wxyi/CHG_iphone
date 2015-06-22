//
//  AddressInfo.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo
@synthesize strAddress; //地址
@synthesize strCityName; //市
@synthesize strCityCode;
@synthesize strProvinceName;//省
@synthesize strprovinceCode;
@synthesize strDistrictName;//区
@synthesize strdistrictCode;
-(id) initWithDictionary:(NSDictionary*)jsonData{
    self=[super init];
    if(self){
        [jsonData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([key isEqualToString:@"address"] ){
                self.strAddress=obj;
            }else if([key isEqualToString:@"cityName"]){
                self.strCityName=obj;
            } else if([key isEqualToString:@"cityCode"]){
                self.strCityCode=obj;
            } else if([key isEqualToString:@"provinceName"]){
                self.strProvinceName=obj;
            } else if([key isEqualToString:@"provinceCode"]){
                self.strprovinceCode=obj;
            } else if([key isEqualToString:@"districtName"]){
                self.strDistrictName=obj;
            } else if([key isEqualToString:@"districtCode"]){
                self.strdistrictCode=obj;
            }

        }];
        
    }
    return self;
    
}
@end
