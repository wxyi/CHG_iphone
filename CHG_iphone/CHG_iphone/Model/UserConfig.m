//
//  UserConfig.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "UserConfig.h"

@implementation UserConfig
@synthesize strMobile; //手机号码
@synthesize strUsername; //用户名
@synthesize strNickname;//昵称
@synthesize Roles;//角色
@synthesize shopList;//角色

-(id) initWithDictionary:(NSDictionary*)jsonData
{
    self=[super init];
    if(self){
        [jsonData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([key isEqualToString:@"mobile"] ){
                self.strMobile = obj;
            } else if([key isEqualToString:@"username"]){
                self.strUsername=obj;
            } else if([key isEqualToString:@"nickname"]){
                self.strNickname=obj;
            } else if([key isEqualToString:@"roles"]){
                NSArray* roleslist = obj;
                
                for (int i = 0; i < roleslist.count; i++) {
                    if ([[roleslist objectAtIndex:i] isEqualToString:@"SHOP_OWNER"])
                    {
                        self.Roles = @"SHOP_OWNER";
                        break;
                    }
                    else if ([[roleslist objectAtIndex:i] isEqualToString:@"SHOPLEADER"]) {
                        self.Roles = @"SHOPLEADER";
                        break;
                    }
                    else if ([[roleslist objectAtIndex:i] isEqualToString:@"SHOPSELLER"]) {
                        self.Roles = @"SHOPSELLER";
                        break;
                    }
                    else  {
                        
                        self.Roles = @"PARTNER";
                    }
                    
                }
                
            } else if([key isEqualToString:@"shops"]){
                self.shopList=obj;
            }
            
        }];
        
    }
    return self;
}
@end
