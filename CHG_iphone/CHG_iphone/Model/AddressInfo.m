//
//  AddressInfo.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo
-(id) initWithDictionary:(NSDictionary*)jsonData{
    self=[super init];
    if(self){
        [jsonData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([key isEqualToString:@"userId"] || [key isEqualToString:@"id"]){
//                self.userId=[NSNumber numberWithInt:[obj intValue]];
            }
            
        }];
        
    }
    return self;
    
}
@end
