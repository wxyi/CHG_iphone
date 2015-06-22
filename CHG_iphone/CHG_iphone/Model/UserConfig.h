//
//  UserConfig.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfig : NSObject
@property(nonatomic, strong) NSString *strMobile; //手机号码
@property(nonatomic, strong) NSString *strUsername; //用户名
@property(nonatomic, strong) NSString *strNickname;//昵称
@property(nonatomic, strong) NSString *Roles;//角色
@property(nonatomic, strong) NSArray  *shopList;//角色
@property(nonatomic, strong) NSString  *strdimensionalCodeUrl;//二维码
-(id) initWithDictionary:(NSDictionary*)jsonData;
@end
