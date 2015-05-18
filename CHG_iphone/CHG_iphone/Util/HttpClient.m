//
//  HttpClient.m
//  SecondHandTradingMarket
//
//  Created by wuxinyi on 15-4-23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

+(void)asynchronousRequestWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"url = %@",url);
    NSError *error;
    AFHTTPRequestSerializer *requestSerializer=[[AFHTTPRequestSerializer alloc] init];
    NSMutableURLRequest *request=[requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameters error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    //operation.securityPolicy.allowInvalidCertificates = YES;
    
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil;
    }];
    
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
//        if(progressBlock){
//            progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
//        }
//    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(!error){
//            successBlock(YES,json,@"");
            if([json objectForKey:@"code"] &&[[[json objectForKey:@"code"] substringFromIndex:2]  intValue]==1){
                successBlock(YES,[json objectForKey:@"data"],@"");
            }else{
                successBlock(NO,nil,[json objectForKey:@"msg"]);
            }
            
        }else{
            successBlock(NO,nil,error.description);
        }
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        failureBlock(error.localizedDescription);
        
    }];
    [operation start];
}




+(void)asynchronousRequestUploadWithProgress:(NSString *)url parameters:(NSDictionary *)parameters files:(NSArray *)files successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
{
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
        NSDictionary *json = nil;
        NSError *nsError = nil;
        if([responseObject isKindOfClass:[NSDictionary class] ]){
            json = (NSDictionary *)responseObject;
        } else {
            json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&nsError];
        }
            
            DLog(@"json = %@",json);
        if(!nsError){
            if([json objectForKey:@"code"] &&[[[json objectForKey:@"code"] substringFromIndex:2] intValue]==1){
                successBlock(YES,[json objectForKey:@"data"],@"");
            }else{
                successBlock(NO,nil,[json objectForKey:@"msg"]);
            }
        }else{
            successBlock(NO,nil,nsError.description);
        }
        [operation cancel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        failureBlock(error.localizedDescription);
        
    }];
    [operation start];
    //    }
    
    
}
+(void)asynchronousCommonJsonRequestWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
{
    NSError *error;
    AFHTTPRequestSerializer *requestSerializer=[[AFHTTPRequestSerializer alloc] init];
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
        //NSLog(responseObject);
        NSError *error;
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if(!error){
            successBlock(YES,json,@"");
            
        }else{
            successBlock(NO,nil,error.description);
        }
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        failureBlock(error.localizedDescription);
        
    }];
    [operation start];
}

+(void)asynchronousDownLoadFileWithProgress:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(void (^)(NSURL *))successBlock failureBlock:(RequestFailedBlock)failureBlock progressBlock:(progressBlock)progressBlock
{
    
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
        DLog(@"下载失败");
        failureBlock(error.localizedDescription);
    }];
    [operation start];
}
@end
