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
 *   账户总览
 */
+(NSString*) ApiGetAccountBrief
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAccountBrief"];
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

+(NSString*) ApiGetMyAccount
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getMyAccount"];
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

/**
 *    会员注册
 */
+(NSString*) ApiCreateCustomer
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"createCustomer"];
}

/**
 *    会员识别—验证手机号
 */
+(NSString*) ApiValidateMobile
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"validateMobile"];
}

/**
 *    门店销售-日
 */
+(NSString*) ApiGetShopSellStatOfDay
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getShopSellStatOfDay"];
}

/**
 *    门店销售-月
 */
+(NSString*) ApiGetShopSellStatOfMonth
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getShopSellStatOfMonth"];
}

/**
 *    门店销售-年
 */
+(NSString*) ApiGetShopSellStatOfYear
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getShopSellStatOfYear"];
}

/**
 *    会员增长-日
 */
+(NSString*) ApiGetMyNewCustCountStatOfDay
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getMyNewCustCountStatOfDay"];
}

/**
 *    会员增长-月
 */
+(NSString*) ApiGetMyNewCustCountStatOfMonth
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getMyNewCustCountStatOfMonth"];
}

/**
 *    会员增长-年
 */
+(NSString*) ApiGetMyNewCustCountStatOfYear
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getMyNewCustCountStatOfYear"];
}

/**
 *    动销奖励-日
 */
+(NSString*) ApiGetAwardSalerStatOfDay
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAwardSalerStatOfDay"];
}

/**
 *    动销奖励-月
 */
+(NSString*) ApiGetAwardSalerStatOfMonth
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAwardSalerStatOfMonth"];
}

/**
 *    动销奖励-年
 */
+(NSString*) ApiGetAwardSalerStatOfYear
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAwardSalerStatOfYear"];
}

/**
 *    合作商消费分账奖励-日
 */
+(NSString*) ApiGetAwardPartnerStatOfDay
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAwardPartnerStatOfDay"];
}

/**
 *    合作商消费分账奖励-月
 */
+(NSString*) ApiGetAwardPartnerStatOfMonth
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAwardPartnerStatOfMonth"];
}

/**
 *    合作商消费分账奖励-年
 */
+(NSString*) ApiGetAwardPartnerStatOfYear
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getAwardPartnerStatOfYear"];
}

/**
 *    商品列表
 */
+(NSString*) ApiGetProductList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getProductList"];
}

/**
 *    品类集合
 */
+(NSString*) ApiGetProductCategoryList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getProductCategoryList"];
}

/**
 *    商品详情
 */
+(NSString*) ApiGetProduct
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getProduct"];
}

/**
 *    创建一单一发订单
 */
+(NSString*) ApiCreateSaleOrder
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"createSaleOrder"];
}

/**
 *    创建一单多发订单
 */
+(NSString*) ApiCreateEngageOrder
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"createEngageOrder"];
}

/**
 *    订单列表
 */
+(NSString*) ApiGetOrderList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getOrderList"];
}

/**
 *    验证订单商品
 */
+(NSString*) ApiValidateOrderProduct
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"validateOrderProduct"];
}

/**
 *    预定订单提货
 */
+(NSString*) ApiCreateSubOrder
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"createSubOrder"];
}

/**
 *    门店详情
 */
+(NSString*) ApiGetShop
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getShop"];
}

/**
 *    修改门店
 */
+(NSString*) ApiUpdateShop
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"updateShop"];
}

/**
 *    导购列表
 */
+(NSString*) ApiGetSellerList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getSellerList"];
}


/**
 *    导购详情
 */
+(NSString*) ApiGetSeller
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getSeller"];
}

/**
 *    修改导购
 */
+(NSString*) ApiUpdateSeller
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"updateSeller"];
}

/**
 *    禁用/启用导购
 */
+(NSString*) ApiSetSellerStatus
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"setSellerStatus"];
}

/**
 *    验证商品是否可以退货
 */
+(NSString*) ApiValidateProductReturn
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"validateProductReturn"];
}

/**
 *    卖货退货
 */
+(NSString*) ApiCreateReturnOrder
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"createReturnOrder"];
}

/**
 *    终止订单
 */
+(NSString*) ApiCancelOrder
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"cancelOrder"];
}

/**
 *    APP缓存是否需要更新
 */
+(NSString*) ApiRefreshCache
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"refreshCache"];
}



/**
 *    获取地址列表
 */
+(NSString*) ApiAddressCode
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"addressCode"];
}


/**
 *    获取地址列表
 */
+(NSString*) ApiBankCode
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"bankCode"];
}
/**
 *    二维码扫描识别商品
 */
+(NSString*) ApiGetProductBrief
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getProductBrief"];
}

/**
 *    订单详情
 */
+(NSString*) ApiGetOrder;
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"getOrder"];
}
@end
