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
 *  帮助中心
 */
@property(nonatomic,assign) NSString * PubServer_HELP;


/**
 *  获取token
 */
@property(nonatomic,assign) NSString * PubServer_TokenUrl;
/**
 *  系统版本
 */
@property(nonatomic,assign) NSString *sysVersion;

/**
 *  最后日期
 */
@property(nonatomic,assign) NSString *lastClientVersion;

/**
 *  设备名称
 */
@property(nonatomic,assign) NSString *deviceName;

//当前登录人员信息
@property(nonatomic,assign) NSString * currentUserInfo;


//当前登录人员信息
@property(nonatomic,assign) NSString * strUserName;
//token
@property(nonatomic,assign) NSString * access_token;
//刷新token
@property(nonatomic,assign) NSString * refresh_token;
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


//门店二维码
@property(nonatomic,assign) NSString * strdimensionalCodeUrl;

//门店名称
@property(nonatomic,assign) NSString * strStoreName;

//会员注册信息，由于nav统一从CHGNavigationController中调用，所以需要记录会员手机号，会员姓名，手机验证码
@property(nonatomic,assign) NSString * strcustMobile;
@property(nonatomic,assign) NSString * strcustName;
@property(nonatomic,assign) NSString * strcheckCode;

//地址更新时间
@property(nonatomic,assign) NSString * adressUpdateTime;
//银行卡更新时间
@property(nonatomic,assign) NSString * bankCodeUpdateTime;
//银行卡更新时间
@property(nonatomic,assign) NSString * promoListUpdateTime;


//图片保存路径
@property(nonatomic,assign) NSString* strImagePath;


//银行卡ID
@property(nonatomic,assign) NSString* strBankId;
@end
