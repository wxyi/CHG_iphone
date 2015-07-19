//
//  NSDownNetImage.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/23.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "NSDownNetImage.h"

@implementation NSDownNetImage
+(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}


+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}


+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

// 删除沙盒里的文件
+(void)deleteFile
{
    
    
    NSString *path = [NSObject CreateDocumentsfileManager:@"image"];
    //文件名
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:path];
    DLog(@"file = %@",file);
    for (int i = 0; i <file.count; i ++) {
        NSString *newstr =[NSString stringWithFormat:@"%@/%@",[APPDocumentsDirectory stringByAppendingString:@"/image"],[file objectAtIndex:i]] ;
        DLog(@"newstr = %@",newstr);
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:newstr];
        if (!blHave) {
            NSLog(@"no  have");
            return ;
        }else {
            NSLog(@" have");
            BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:newstr error:nil];
            if (blDele) {
                NSLog(@"dele success");
            }else {
                NSLog(@"dele fail");
            }
            
        }
    }
    
    
}

@end
