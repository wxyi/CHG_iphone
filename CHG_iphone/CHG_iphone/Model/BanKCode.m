//
//  BanKCode.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/17.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BanKCode.h"

@implementation BanKCode
-(id) initWithDictionary:(NSDictionary*)jsonData{
    self=[super init];
    if(self){
        [jsonData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([key isEqualToString:@"bankName"]){
                
                self.bankName=key;
            } else if([key isEqualToString:@"bankCode"]){
                self.bankCode=obj;
            } else if([key isEqualToString:@"iconUrl"]){
                self.cardCodeList= obj;
            }
            
        }];
        
    }
    return self;
    
}
@end
