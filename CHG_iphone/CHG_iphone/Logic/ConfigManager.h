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
@end
