//
//  NSDownNetImage.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDownNetImage : NSObject
+(UIImage *) getImageFromURL:(NSString *)fileURL ;
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

+(void)deleteFile;
@end
