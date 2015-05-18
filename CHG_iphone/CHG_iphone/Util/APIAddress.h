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
 *  发送短信验证码
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiSendSMSCaptcha;

/**
 *  核准输入的短信验证码
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiCheckCaptcha;

/**
 *  核准用户登录
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiCheckLogin;

/**
 *  获取用户信息
 *
 *  @return <#return value description#>
 */
+(NSString*) ApiGetUser;

/**
 *  用户登录名唯一验证 *
 *  @return <#return value description#>
 */
+(NSString*) ApiExistUser;

/**
 *  根据用户主键查用户
 *  @return <#return value description#>
 */
+(NSString*) ApiGetUserById;

/**
 *  通过旧密码重置密码
 *  @return <#return value description#>
 */
+(NSString*) ApiUpdatePwdByOld;

/**
 *  通过短信验证码重置密码
 *  @return <#return value description#>
 */
+(NSString*) ApiUpdatePwdByCaptcha;

/**
 *  核准注册
 *  @return <#return value description#>
 */
+(NSString*) ApiVerifyRegister;

/**
 *  新建用户
 *  @return <#return value description#>
 */
+(NSString*) ApiCreateUser;

/**
 *  获取会员信息
 */
+(NSString*) ApiGetMemberByUserId;

/**
 *  编辑会员信息地址
 */
+(NSString*) ApiModifyMemberByUserId;



/*********************产品接口*********************/
/**
 *  获取产品类别
 */
+(NSString*) ApiSearchPcategoryList;

/**
 *  获取产品列表
 */
+(NSString*) ApiSearchProductList;

/**
 *  获取产品详情
 */
+(NSString*) ApiSearchProductInfoById;

/**
 *  添加产品（含详情）
 */
+(NSString*) ApiAddProduct;

/**
 *  更新产品（含详情）
 */
+(NSString*) ApiUpdateProduct;

/**
 *  发布产品
 */
+(NSString*) ApiReleaseProduct;

/**
 *  搜索产品列表
 */
+(NSString*) ApiGetProductListByCond;



/*********************收藏接口*********************/
/**
 *  添加收藏
 */
+(NSString*) ApiAddCollect;

/**
 *  删除收藏
 */
+(NSString*) ApiDeleteCollect;

/**
 *  获取收藏列表
 */
+(NSString*) ApiSearchCollect;

/*********************广告接口*********************/
/**
 *  获取广告列表
 */
+(NSString*) ApiGetAdList;


/*********************附件接口*********************/
/**
 *  上传附件
 */
+(NSString*) ApiUploadAnnex;

/**
 *  删除附件
 */
+(NSString*) ApiDeleteAnnex;

/**
 *  获得附件路径
 */
+(NSString*) ApiGetAnnexUrl;
@end
