//
//  HttpClient.m
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "HttpClient.h"
static BOOL isFirst = NO;
static BOOL canCHeckNetwork = NO;
@implementation HttpClient

+(void)asynchronousRequestWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock Refresh_tokenBlock:(Refresh_tokenBlock)refreshBlack
{
    
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];

    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
//        NSError *error = [NSError errorWithDomain:@"网络不可用" code:100 userInfo:nil];
        failureBlock(@"网络不可用");
        return;
    }
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"url = %@",url);
    NSError *error;
    AFHTTPRequestSerializer *requestSerializer=[[AFHTTPRequestSerializer alloc] init];
    NSMutableURLRequest *request=[requestSerializer requestWithMethod:@"GET" URLString:url parameters:parameters error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    //operation.securityPolicy.allowInvalidCertificates = YES;
    
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil;
    }];
    

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        
        NSMutableDictionary* json =  [[NSMutableDictionary alloc] init];
//        NSDictionary *
        json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        
        DLog(@"json = %@",json);
        if(!error){
//            successBlock(YES,json,@"");
            if([json objectForKeySafe:@"code"] &&[[json objectForKeySafe:@"code"]  intValue]==200){

                successBlock(YES,[json objectForKeySafe:@"datas"],@"");
            }
            else if([[json objectForKeySafe:@"code"] intValue] == 402)
            {
                [MMProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_FAILURE
                                                                    object:nil];
            }
            else if([[json objectForKeySafe:@"code"] intValue] == 401)
            {
                [MMProgressHUD dismiss];
                [HttpClient httpRefresh_token:^(BOOL success, id data, NSString *msg) {
                    if (success) {
                        DLog(@"刷新成功");
                        refreshBlack(YES);
                    }
                } failureBlock:^(NSString *description) {
                    DLog(@"刷新成功");
                }];
                
            }
            else{
                successBlock(NO,nil,[json objectForKeySafe:@"msg"]);
            }
            
        }else{
            successBlock(NO,nil,error.description);
        }
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        DLog(@"error = %d",error.code);
        failureBlock(@"网络异常");
        
        
    }];
    [operation start];
}




+(void)asynchronousRequestUploadWithProgress:(NSString *)url parameters:(NSDictionary *)parameters files:(NSArray *)files successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
{
    
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        //        NSError *error = [NSError errorWithDomain:@"网络不可用" code:100 userInfo:nil];
        failureBlock(@"网络不可用");
        return;
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(NSObject * obj in files){
            MImageFile * file = (MImageFile * )obj;
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:file.filePath] name:file.formName fileName:file.fileName mimeType:file.mimeType error:nil];
        }
        
    } error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if(progressBlock){
            progressBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
        DLog(@"Sent %lldof %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(responseObject);
//        NSDictionary *json = nil;
            NSMutableDictionary* json =  [[NSMutableDictionary alloc] init];
        NSError *nsError = nil;
        if([responseObject isKindOfClass:[NSDictionary class] ]){
            json = (NSDictionary *)responseObject;
        } else {
            json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&nsError];
        }
            
            DLog(@"json = %@",json);
        if(!nsError){
            if([json objectForKeySafe:@"code"] &&[[[json objectForKeySafe:@"code"] substringFromIndex:2] intValue]==1){
                successBlock(YES,[json objectForKeySafe:@"data"],@"");
            }
            else{
                successBlock(NO,nil,[json objectForKeySafe:@"msg"]);
            }
        }else{
            successBlock(NO,nil,nsError.description);
        }
        [operation cancel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        failureBlock(@"网络异常");
        
    }];
    [operation start];
    //    }
    
    
}
+(void)asynchronousCommonJsonRequestWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock Refresh_tokenBlock:(Refresh_tokenBlock)refreshBlack
{
    
    
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        //        NSError *error = [NSError errorWithDomain:@"网络不可用" code:100 userInfo:nil];
        failureBlock(@"网络不可用");
        return;
    }
    
    NSError *error;
    AFJSONRequestSerializer *requestSerializer=[[AFJSONRequestSerializer alloc] init];

    
    NSMutableURLRequest *request=[requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameters error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil;
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if(progressBlock){
            progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
        }
    }];
   
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(responseObject);
        NSError *error;
        NSMutableDictionary* json =  [[NSMutableDictionary alloc] init];
//        NSDictionary *
        json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(!error){
            if([[json objectForKeySafe:@"code"] intValue] == 402)
            {
                [MMProgressHUD dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_FAILURE
                                                    object:nil];
            }
            else if([[json objectForKeySafe:@"code"] intValue] == 401)
            {
//                [MMProgressHUD dismiss];
                [HttpClient httpRefresh_token:^(BOOL success, id data, NSString *msg) {
                    if (success) {
                        DLog(@"刷新成功");
                        refreshBlack(YES);
                    }
                } failureBlock:^(NSString *description) {
                    DLog(@"刷新失败");
                }];
            }
            else
            {
                
               successBlock(YES,json,@"");
            }
            
            
        }else{
            successBlock(NO,nil,error.description);
        }
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        DLog(@"error = %@",error)
        failureBlock(@"网络异常");
    
    }];
    [operation start];
}

+(void)asynchronousDownLoadFileWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(void (^)(NSURL *))successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
{
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        //        NSError *error = [NSError errorWithDomain:@"网络不可用" code:100 userInfo:nil];
        failureBlock(@"网络不可用");
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *paths = [url componentsSeparatedByString:@"/"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *downloadPath = [ NSHomeDirectory() stringByAppendingString:[@"/Documents/" stringByAppendingString:[paths lastObject]]];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:NO];
    // 设置下载进程块代码
    /*
     bytesRead                      当前一次读取的字节数(100k)
     totalBytesRead                 已经下载的字节数(4.9M）
     totalBytesExpectedToRead       文件总大小(5M)
     */
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if(progressBlock){
            progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
        }
    }];
    
    
    // 设置下载完成操作
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 下一步可以进行进一步处理，或者发送通知给用户。
        DLog(@"下载成功");
        successBlock([NSURL fileURLWithPath:downloadPath]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"下载失败 error ");
        failureBlock(@"网络异常");
    }];
    [operation start];
}


//+(void)asynchronousRequestPostWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(void (^)(NSURL *))successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"foo": @"bar"};
//    [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}
+(void)inithttps{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];

    securityPolicy.allowInvalidCertificates = YES;
    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;

}
+(void)httpRefresh_token:(RequestSuccessBlock) successBlock failureBlock:(RequestFailedBlock)failureBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:@"refresh_token" forKey:@"grant_type"];
    [parameter setObjectSafe:[ConfigManager sharedInstance].identifier forKey:@"client_code"];
    if ([ConfigManager sharedInstance].refresh_token.length == 0) {
        [ConfigManager sharedInstance].refresh_token = @"";
    }
    [parameter setObjectSafe:[ConfigManager sharedInstance].refresh_token forKey:@"refresh_token"];
    [parameter setObjectSafe:@"app" forKey:@"client_id"];
    [parameter setObjectSafe:@"appSecret" forKey:@"client_secret"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOauthToken] parameters:parameter];
    
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);
        
        //        if ([ConfigManager sharedInstance].access_token.length == 0)
        //            self.isfrist = NO;
        //        else
        //            self.isfrist = YES;
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200)
        {
            
            [ConfigManager sharedInstance].access_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"access_token"];
            [ConfigManager sharedInstance].refresh_token = [[data objectForKeySafe:@"datas"] objectForKeySafe:@"refresh_token"];
            successBlock(YES,data,@"");
            
        }
        else
        {
            successBlock(NO,nil,[data objectForKeySafe:@"msg"]);
        }
    } failureBlock:^(NSString *description) {
        DLog(@"description = %@",description);
        failureBlock(@"网络异常");
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        
    }];
}
@end
