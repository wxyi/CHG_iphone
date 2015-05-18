//
//  SUHelper.h
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUHelper : NSObject

+(SUHelper *)sharedInstance;

//系统初始化
-(void) sysInit:(void (^)(BOOL success))successBlock;
@end
