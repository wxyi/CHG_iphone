//
//  BaseHttpDTO.h
//  SunLightCloud
//
//  Created by 武新义 on 14-10-28.
//  Copyright (c) 2014年 武新义. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^RequestSuccessBlock)(BOOL success, id data, NSString *msg);
typedef void (^RequestFailedBlock)(NSString *description);
typedef void (^BodyWithBlock)(id <AFMultipartFormData>formData);
typedef void (^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
typedef void (^Refresh_tokenBlock)(BOOL success);
/**
 *  modle层的基类
 */
@interface BaseHttpDTO : NSObject



@end
