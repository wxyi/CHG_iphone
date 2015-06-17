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
 *   账户总览
 */
+(NSString*) ApiGetAccountBrief;

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
 *   添加银行卡
 */
+(NSString*) ApiGetMyAccount;
/**
 *    检测新版本
 */
+(NSString*) ApiCheckVersion;

/**
 *    验证手机号
 */
+(NSString*) ApiValidateCustMobile;


/**
 *    会员注册
 */
+(NSString*) ApiCreateCustomer;

/**
 *    会员识别—验证手机号
 */
+(NSString*) ApiValidateMobile;

/**
 *    门店销售-日
 */
+(NSString*) ApiGetShopSellStatOfDay;

/**
 *    门店销售-月
 */
+(NSString*) ApiGetShopSellStatOfMonth;

/**
 *    门店销售-年
 */
+(NSString*) ApiGetShopSellStatOfYear;

/**
 *    会员增长-日
 */
+(NSString*) ApiGetMyNewCustCountStatOfDay;

/**
 *    会员增长-月
 */
+(NSString*) ApiGetMyNewCustCountStatOfMonth;

/**
 *    会员增长-年
 */
+(NSString*) ApiGetMyNewCustCountStatOfYear;

/**
 *    动销奖励-日
 */
+(NSString*) ApiGetAwardSalerStatOfDay;

/**
 *    动销奖励-月
 */
+(NSString*) ApiGetAwardSalerStatOfMonth;

/**
 *    动销奖励-年
 */
+(NSString*) ApiGetAwardSalerStatOfYear;

/**
 *    合作商消费分账奖励-日
 */
+(NSString*) ApiGetAwardPartnerStatOfDay;

/**
 *    合作商消费分账奖励-月
 */
+(NSString*) ApiGetAwardPartnerStatOfMonth;

/**
 *    合作商消费分账奖励-年
 */
+(NSString*) ApiGetAwardPartnerStatOfYear;

/**
 *    商品列表
 */
+(NSString*) ApiGetProductList;

/**
 *    品类集合
 */
+(NSString*) ApiGetProductCategoryList;

/**
 *    商品详情
 */
+(NSString*) ApiGetProduct;

/**
 *    创建一单一发订单
 */
+(NSString*) ApiCreateSaleOrder;

/**
 *    创建一单多发订单
 */
+(NSString*) ApiCreateEngageOrder;

/**
 *    订单列表
 */
+(NSString*) ApiGetOrderList;

/**
 *    验证订单商品
 */
+(NSString*) ApiValidateOrderProduct;

/**
 *    预定订单提货
 */
+(NSString*) ApiCreateSubOrder;

/**
 *    门店详情
 */
+(NSString*) ApiGetShop;

/**
 *    修改门店
 */
+(NSString*) ApiUpdateShop;

/**
 *    导购列表
 */
+(NSString*) ApiGetSellerList;

/**
 *    导购详情
 */
+(NSString*) ApiGetSeller;

/**
 *    修改导购
 */
+(NSString*) ApiUpdateSeller;

/**
 *    禁用/启用导购
 */
+(NSString*) ApiSetSellerStatus;

/**
 *    验证商品是否可以退货
 */
+(NSString*) ApiValidateProductReturn;

/**
 *    卖货退货
 */
+(NSString*) ApiCreateReturnOrder;

/**
 *    终止订单
 */
+(NSString*) ApiCancelOrder;

/**
 *    APP缓存是否需要更新
 */
+(NSString*) ApiRefreshCache;

/**
 *    获取地址列表
 */
+(NSString*) ApiAddressCode;


/**
 *    获取地址列表
 */
+(NSString*) ApiBankCode;

/**
 *    二维码扫描识别商品
 */
+(NSString*) ApiGetProductBrief;

/**
 *    订单详情
 */
+(NSString*) ApiGetOrder;
@end
