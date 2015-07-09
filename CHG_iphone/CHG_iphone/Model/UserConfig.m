//
//  UserConfig.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "UserConfig.h"
#import "NSDownNetImage.h"
@implementation UserConfig
@synthesize strMobile; //手机号码
@synthesize strUsername; //用户名
@synthesize strNickname;//昵称
@synthesize Roles;//角色
@synthesize shopList;//角色
@synthesize nRoleType;
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
                    if ([[roleslist objectAtIndex:i] isEqualToString:@"SHOP_OWNER"]||[[roleslist objectAtIndex:i] isEqualToString:@"ShopOwner"])
                    {
                        self.Roles = @"SHOP_OWNER";
                        break;
                    }
                    else if ([[roleslist objectAtIndex:i] isEqualToString:@"SHOPLEADER"]||[[roleslist objectAtIndex:i] isEqualToString:@"ShopLeader"]) {
                        self.Roles = @"SHOPLEADER";
                        break;
                    }
                    else if ([[roleslist objectAtIndex:i] isEqualToString:@"SHOPSELLER"]||[[roleslist objectAtIndex:i] isEqualToString:@"ShopSeller"]) {
                        self.Roles = @"SHOPSELLER";
                        break;
                    }
                    else if ([[roleslist objectAtIndex:i] isEqualToString:@"CHGSELLER"]||[[roleslist objectAtIndex:i] isEqualToString:@"ChgSeller"]) {
                        self.Roles = @"CHGSELLER";
                        break;
                    }
                    else  {
                        
                        self.Roles = @"PARTNER";
                    }
                    
                }
                
            } else if([key isEqualToString:@"shops"]){
                self.shopList=obj;
            }
            else if([key isEqualToString:@"roleType"]){
                self.nRoleType=[obj integerValue];
            }
            else if([key isEqualToString:@"dimensionalCodeUrl"]){
                self.strdimensionalCodeUrl=obj;
      
            }
            
        }];
        
    }
    return self;
}
@end
