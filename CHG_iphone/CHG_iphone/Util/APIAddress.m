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
 *  核准输入的短信验证码
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiCheckCaptcha
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/checkCaptcha.action"];
}

/**
 *  核准用户登录
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiCheckLogin
{
    DLog(@"PubServer_URL = %@",[ConfigManager sharedInstance].PubServer_URL);
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/checkLogin.action"];
}

/**
 *  获取用户信息
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiGetUser
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/getUser.action"];
}

/**
 *  用户登录名唯一验证 *
 *  @return <#return value description#>
 */
+(NSString*) ApiExistUser
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/existUser.action"];
}

/**
 *  根据用户主键查用户
 *  @return <#return value description#>
 */
+(NSString*) ApiGetUserById
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/getUserById.action"];
}

/**
 *  通过旧密码重置密码
 *  @return <#return value description#>
 */
+(NSString*) ApiUpdatePwdByOld;

{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/updatePwdByOld.action"];
}

/**
 *  通过短信验证码重置密码
 *  @return <#return value description#>
 */
+(NSString*) ApiUpdatePwdByCaptcha
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/updatePwdByCaptcha.action"];
}

/**
 *  核准注册
 *  @return <#return value description#>
 */
+(NSString*) ApiVerifyRegister
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/verifyRegister.action"];
}

/**
 *  新建用户
 *  @return <#return value description#>
 */
+(NSString*) ApiCreateUser;

{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/createUser.action"];
}


/**
 *  获取会员信息
 */
+(NSString*) ApiGetMemberByUserId
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/getMemberByUserId.action"];
}

/**
 *  编辑会员信息地址
 */
+(NSString*) ApiModifyMemberByUserId
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/modifyMemberByUserId.action"];
}


/*********************产品接口*********************/
/**
 *  获取产品类别
 */
+(NSString*) ApiSearchPcategoryList;
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/searchPcategoryList.action"];
}

/**
 *  获取产品列表
 */
+(NSString*) ApiSearchProductList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/searchProductList.action"];
}

/**
 *  获取产品详情
 */
+(NSString*) ApiSearchProductInfoById
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/searchProductInfoById.action"];
}
/**
 *  添加产品（含详情）
 */
+(NSString*) ApiAddProduct
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/addProduct.action"];
}
/**
 *  更新产品（含详情）
 */
+(NSString*) ApiUpdateProduct
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/updateProduct.action"];
}
/**
 *  发布产品
 */
+(NSString*) ApiReleaseProduct
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/releaseProduct.action"];
}

/**
 *  搜索产品列表
 */
+(NSString*) ApiGetProductListByCond
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/getProductListByCond.action"];
}


/*********************收藏接口*********************/
/**
 *  添加收藏
 */
+(NSString*) ApiAddCollect
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/addCollect.action"];
}
/**
 *  删除收藏
 */
+(NSString*) ApiDeleteCollect
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/deleteCollect.action"];
}

/**
 *  获取收藏列表
 */
+(NSString*) ApiSearchCollect
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/searchCollect.action"];
}

/*********************广告接口*********************/
/**
 *  获取广告列表
 */
+(NSString*) ApiGetAdList
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/getAdList.action"];
}

/*********************附件接口*********************/
/**
 *  上传附件
 */
+(NSString*) ApiUploadAnnex
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/uploadAnnex.action"];
}

/**
 *  删除附件
 */
+(NSString*) ApiDeleteAnnex
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/deleteAnnex.action"];
}

/**
 *  获得附件路径
 */
+(NSString*) ApiGetAnnexUrl
{
    return [[ConfigManager sharedInstance].PubServer_URL stringByAppendingString:@"/getAnnexUrl.action"];
}
@end
