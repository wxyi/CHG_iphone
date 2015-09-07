//
//  HttpClient.h
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BaseHttpDTO.h"


@interface HttpClient : BaseHttpDTO
//////////////////////////////////////////接口处理/////////////////////////////////////////
+(void)asynchronousRequestWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(RequestSuccessBlock) successBlock failureBlock:(RequestFailedBlock)failureBlock  progressBlock:(progressBlock)progressBlock Refresh_tokenBlock:(Refresh_tokenBlock)refreshBlack;

+(void)asynchronousRequestUploadWithProgress:(NSString *)url parameters:(NSDictionary *)parameters files:(NSArray *) files successBlock:(RequestSuccessBlock) successBlock failureBlock:(RequestFailedBlock)failureBlock  progressBlock:(progressBlock)progressBlock ;

+(void)asynchronousCommonJsonRequestWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(RequestSuccessBlock) successBlock failureBlock:(RequestFailedBlock)failureBlock  progressBlock:(progressBlock)progressBlock Refresh_tokenBlock:(Refresh_tokenBlock)refreshBlack;
//+(void)asynchronousDownLoadFileWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(void (^)(NSURL* filePath))successBlock failureBlock:(void (^)(NSString *description))failureBlock;

+(void)asynchronousDownLoadFileWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(void (^)(NSURL* filePath))successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock;

//刷新token
+(void)httpRefresh_token:(RequestSuccessBlock) successBlock failureBlock:(RequestFailedBlock)failureBlock ;

+ (void)inithttps;

//取消所有请求
+ (void)cancelAllAsynchronousOperations;

@end
