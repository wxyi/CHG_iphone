//
//  UIButtonImageWithLable.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/15.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "UIButtonImageWithLable.h"

@implementation UIButton(UIButtonImageWithLable)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
//    CGSize titleSize = [title sizeWithFont:FONT(12.0f)];
    [self.imageView setContentMode:UIViewContentModeScaleToFill];
    [self setImageEdgeInsets:UIEdgeInsetsMake(5,
                                              (self.frame.size.width -40)/2,
                                              30,
                                              (self.frame.size.width -40)/2)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:FONT(15.0f)];
    [self.titleLabel setTextColor:UIColorFromRGB(0xdddddd)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(45.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}
@end
