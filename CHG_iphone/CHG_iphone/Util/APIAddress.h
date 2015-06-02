//
//  APIAddress.h
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIAddress : NSObject

/**
 * 用户登录获取token
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiGetOauthToken;

/**
 *  获得用户配置信息
 */
+(NSString*) ApiGetUserConfig;


/**
 *  获取验证码
 */
+(NSString*) ApiGetCheckCode;

/**
 *  修改密码
 */
+(NSString*) ApiUpdatePassword;


/**
 *  重置密码/忘记密码
 */
+(NSString*) ApiResetPassword;

/**
 *   活动列表
 */
+(NSString*) ApiGetPromoList;

/**
 *   我的基础信息
 */
+(NSString*) ApiGetMyProfile;

/**
 *   银行卡列表
 */
+(NSString*) ApiGetBankCardList;

/**
 *   添加银行卡
 */
+(NSString*) ApiAddBankCard;

/**
 *    检测新版本
 */
+(NSString*) ApiCheckVersion;

/**
 *    验证手机号
 */
+(NSString*) ApiValidateCustMobile;


@end
