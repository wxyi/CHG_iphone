//
//  SUHelper.m
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "SUHelper.h"
#import "sys/utsname.h"
@implementation SUHelper
static dispatch_once_t onceToken;
static SUHelper *sSharedInstance;
+(SUHelper *)sharedInstance{
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[SUHelper alloc] init];
    });
    return sSharedInstance;
}
//系统初始化
-(void) sysInit:(void (^)(BOOL success))successBlock{
    //    [CommonViewConvert sharedInstance];
    //[ConfigManager sharedInstance].sysVersion = @"2.0.7";
//    [ConfigManager sharedInstance].currentBaseVersion = 15;
    DLog(@"systemName:%@",[self deviceString]);
    DLog(@"model:%@",[[UIDevice currentDevice] name]);
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sysconfig" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [ConfigManager sharedInstance].sysVersion =[dictionary objectForKey:@"clientVersion"];
    
    
    if (![ConfigManager sharedInstance].PubServer_URL) {
        [ConfigManager sharedInstance].PubServer_URL = [dictionary objectForKey:@"PubServer_HOST"];
    }
    
    DLog(@"PubServer_URL = %@",[ConfigManager sharedInstance].PubServer_URL);
    [ConfigManager sharedInstance].deviceName = [self deviceString];
    
    if([self hasUser]){
        [self httpGetClientConfig];
    }
    //[[SQLiteManager sharedInstance] test];
    successBlock(YES);
}

-(NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"] || [deviceString isEqualToString:@"iPhone3,2"] ||[deviceString isEqualToString:@"iPhone3,3"] )    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"] ||[deviceString isEqualToString:@"iPad2,2"]||[deviceString isEqualToString:@"iPad2,3"]||[deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"] ||[deviceString isEqualToString:@"iPad2,6"]||[deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad3,1"] ||[deviceString isEqualToString:@"iPad3,2"]||[deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,5"] ||[deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"]||[deviceString isEqualToString:@"iPad4,2"]||[deviceString isEqualToString:@"iPad4,3"])      return@"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,1"]||[deviceString isEqualToString:@"iPad5,3"]||[deviceString isEqualToString:@"iPad5,3"])      return@"iPad Air2";
    if ([deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"])      return@"iPad Mini2";
    if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"] ||[deviceString isEqualToString:@"iPad4,9"])      return@"iPad Mini3";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
-(BOOL) hasUser{
    NSString *currentUser = [ConfigManager sharedInstance].currentUserInfo;
    if(currentUser.length==0){
        return NO;
    } else {
        return YES;
    }
}
-(void)httpGetClientConfig{
   
}

@end
