//
//  UIImage+ResizeMagick.h
//  seu_iphone
//
//  Created by sudyapp1 on 14-5-12.
//  Copyright (c) 2014年 fanxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeMagick)
- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;
@end
