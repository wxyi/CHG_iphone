//
//  APIAddress.m
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "APIAddress.h"

@implementation APIAddress
/**
 *  发送短信验证码
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiSendSMSCaptcha
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/sendSMSCaptcha.action"];
}

/**
 * 用户登录获取token
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiGetOauthToken
{
    return [[ConfigManager sharedInstance].PubServer_TokenUrl stringByAppendingString:@"oauth/token"];
}

/**
 *  获得用户配置信息
 */
+(NSString*) ApiGetUserConfig
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getUserConfig"];
}


/**
 *  获取验证码
 */
+(NSString*) ApiGetCheckCode
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getCheckCode"];
}

/**
 *  修改密码
 */
+(NSString*) ApiUpdatePassword
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"updatePassword"];
}


/**
 *  重置密码/忘记密码
 */
+(NSString*) ApiResetPassword
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"resetPassword"];
}

/**
 *   活动列表
 */
+(NSString*) ApiGetPromoList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getPromoList"];
}


/**
 *   我的基础信息
 */
+(NSString*) ApiGetMyProfile;
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getMyProfile"];
}
/**
 *   银行卡列表
 */
+(NSString*) ApiGetBankCardList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getBankCardList"];
}

/**
 *   添加银行卡
 */
+(NSString*) ApiAddBankCard
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"addBankCard"];
}

/**
 *    检测新版本
 */
+(NSString*) ApiCheckVersion
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"checkVersion"];
}

/**
 *    验证手机号
 */
+(NSString*) ApiValidateCustMobile
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"validateCustMobile"];
}


@end
