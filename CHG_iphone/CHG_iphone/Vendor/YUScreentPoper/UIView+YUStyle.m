//
//  UIView+YUStyle.m
//  YUStyle
//
//  Created by yxy on 14-8-12.
//  Copyright (c) 2014年 Ataw. All rights reserved.
//

#import "UIView+YUStyle.h"
#define ERROR_CRY NSLog(@"请先加入到某个VIEW 中!");

@implementation UIView (YUStyle)

#pragma mark 距离某个View
-(void)y_bottomFromView:(UIView *)fromView distance:(float)v {
    // 距离 fromView 底部 v 个 point
    float y = CGRectGetMaxY(fromView.frame)+v;
    self.frame = CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
-(void)y_topFromView:(UIView *)fromView distance:(float)v{
    // 距离 fromView 顶部 v 个 point
    float y = CGRectGetMinY(fromView.frame) - v - CGRectGetHeight(self.frame);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
-(void)y_leftFromView:(UIView *)fromView distance:(float)v{
    // 距离 fromView 左部 v 个 point
    float x = CGRectGetMinX(fromView.frame) - v -CGRectGetWidth(self.frame);
    self.frame = CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
}
-(void)y_rightFromView:(UIView *)fromView distance:(float)v{
    // 距离 fromView 右部 v 个 point
    float x = CGRectGetMaxX(fromView.frame) + v ;
    self.frame = CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
#pragma mark 距离父亲视图

-(void)y_setLeft:(float)distance{
    // 距离 父视图 左部 distance 个 point

    self.frame =  CGRectMake(distance, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
-(void)y_setRight:(float)distance{
     // 距离 父视图 右部 distance 个 point
    if(self.superview == nil){
        ERROR_CRY
        return;
    }
    float x = self.superview.frame.size.width - distance- self.frame.size.width;
    self.frame =  CGRectMake(x, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
-(void)y_setTop:(float)distance{
     // 距离 父视图 顶部 distance 个 point
    self.frame =  CGRectMake(CGRectGetMinX(self.frame), distance, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
-(void)y_setBottom:(float)distance{
     // 距离 父视图 底部 distance 个 point
    if(self.superview == nil){
        
        
        return;
    }
    float y = self.superview.frame.size.height-  self.frame.size.height - distance;
  
    
    self.frame =  CGRectMake(CGRectGetMinX(self.frame), y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
}
-(void)y_setWidth:(float)width{
   // 设置宽度
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), width, CGRectGetHeight(self.frame));
}
-(void)y_setHeight:(float)height{
    //设置高度
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height);
}
#pragma mark 对齐方式
-(void)y_setAlign:(int)align{
/*
 对齐方
 7 8 9
 4 5 6
 1 2 3
 */
    if(!self.superview){
        NSLog(@"error:先加入到父Viw");
        return;
    }
    float x,y;
    
    float fw = self.superview.frame.size.width,fh = self.superview.frame.size.height,sw = self.frame.size.width,sh = self.frame.size.height;
    switch (align) {
        case 1:
            x = 0,y = fh-sh;
            break;
        case 2:
            x = fw/2 - sw/2; y = fh - sh;
            break;
        case 3:
            x = fw - sw ;y = fh - sh ;
            break;
        case 4:
            x =0 ; y = fh/2 - sh /2 ;
            break;
        case 5:
            x = fw /2 - sw/2 ; y = fh/2 - sh /2 ;
            break;
        case 6:
            x = fw -sw ; y = fh/2 - sh  /2 ;
            break;
        case 7:
            x = 0 ; y = 0;
            break;
        case 8:
            x = fw /2 -sw/2;y =0;
            break;
        case 9:
            x = fw -sw ;y = 0;
            break;
        default:
            x = self.frame.origin.x ;y = self.frame.origin.y;
            break;
    }
    
    self.frame = CGRectMake(x, y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

}

-(float) y_LeftX{

    float x =  CGRectGetMinX(self.frame);
    return  x;
    
}
-(float) y_TopY{
    float y = CGRectGetMinY(self.frame);
    return  y ;
    
}
-(float) y_RightX{
    float x = CGRectGetMaxX(self.frame);
    
    return  x ;
}
-(float) y_BottomY{

    float y = CGRectGetMaxY(self.frame);
    return  y ;
    
}
-(float) y_Width{
    float w = CGRectGetWidth(self.frame);

    return w ;
    
}
-(float) y_MidX{

    float w = CGRectGetMinX(self.frame);
    return  w ;

}
-(float) y_MidY{
    float y = CGRectGetMidY(self.frame);
    return y ;
    
}

-(float) y_Height{

    float h= CGRectGetHeight(self.frame);
    return  h ;
    
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
