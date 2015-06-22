//
//  BanKCode.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/17.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanKCode : NSObject
@property(nonatomic,strong) NSString *bankName;
@property(nonatomic,strong) NSString *bankCode;
@property(nonatomic,strong) NSString *cardCodeList;

-(id) initWithDictionary:(NSDictionary*)jsonData;
@end
