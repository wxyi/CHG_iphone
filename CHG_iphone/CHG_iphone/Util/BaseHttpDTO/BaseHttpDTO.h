//
//  BaseHttpDTO.h
//  SunLightCloud
//
//  Created by 李标 on 14-10-28.
//  Copyright (c) 2014年 李标. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "Configure.h"

typedef void (^RequestSuccessBlock)(BOOL success, id data, NSString *msg);
typedef void (^RequestFailedBlock)(NSString *description);
typedef void (^BodyWithBlock)(id <AFMultipartFormData>formData);
typedef void (^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

/**
 *  modle层的基类
 */
@interface BaseHttpDTO : NSObject



@end
