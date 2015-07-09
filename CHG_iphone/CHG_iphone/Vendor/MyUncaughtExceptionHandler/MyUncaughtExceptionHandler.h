//
//  UncaughtExceptionHandler.h
//  Game
//
//  Created by WangYue on 13-7-17.
//  Copyright (c) 2013年 ntstudio.imzone.in. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
