//
//  UIButtonImageWithLable.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/15.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end
