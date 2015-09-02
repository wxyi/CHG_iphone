//
//  UIView+YUStyle.h
//  YUStyle
//
//  Created by yxy on 14-8-12.
//  Copyright (c) 2014年 YXY. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 
 所有方法要在 加入到指定view 后使用
 
 **/
@interface UIView (YUStyle)
-(void)y_bottomFromView:(UIView *)fromView distance:(float)v;
-(void)y_topFromView:(UIView *)fromView distance:(float)v;
-(void)y_leftFromView:(UIView *)fromView distance:(float)v;
-(void)y_rightFromView:(UIView *)fromView distance:(float)v;
-(void)y_setLeft:(float)distance;
-(void)y_setRight:(float)distance;
-(void)y_setTop:(float)distance;
-(void)y_setBottom:(float)distance;
-(void)y_setWidth:(float)width;
-(void)y_setHeight:(float)height;
-(void)y_setAlign:(int)align;
-(float) y_LeftX;
-(float) y_TopY;
-(float) y_RightX;
-(float) y_BottomY;
-(float) y_Width;
-(float) y_MidX;
-(float) y_MidY;
-(float) y_Height;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
