//
//  ConfigManager.h
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PAPreferences.h"

@interface ConfigManager : PAPreferences

/**
 *  openfire服务器
 */
@property(nonatomic,assign) NSString * PubServer_URL;


/**
 *  获取token
 */
@property(nonatomic,assign) NSString * PubServer_TokenUrl;
/**
 *  系统版本
 */
@property(nonatomic,assign) NSString *sysVersion;

/**
 *  设备名称
 */
@property(nonatomic,assign) NSString *deviceName;

//当前登录人员信息
@property(nonatomic,assign) NSString * currentUserInfo;


//token
@property(nonatomic,assign) NSString * access_token;

//获取设备的唯一标示符
@property(nonatomic,assign) NSString * identifier;

//用户配置
@property(nonatomic,assign) NSString * usercfg;

//商品ID
@property(nonatomic,assign) NSString * shopId;


//会员ID
@property(nonatomic,assign) NSString * strCustId;


//用户手机号
@property(nonatomic,assign) NSString * strIphone;
@end
