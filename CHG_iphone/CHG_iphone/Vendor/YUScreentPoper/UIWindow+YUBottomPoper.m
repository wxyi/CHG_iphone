//
//  UIWindow+YUBottomPoper.m
//  YUANBAOAPP
//
//  Created by yxy on 14/11/20.
//  Copyright (c) 2014年 ATAW. All rights reserved.
//

#import "UIWindow+YUBottomPoper.h"
#import "YUDarkGlassView.h"
#import "UIView+YUStyle.h"
#import "yConst.h"
@implementation UIWindow (YUBottomPoper)

#pragma mark 弹出菜单 block 回调方式
-(void)showPopWithButtonTitles:(NSArray *)titles styles:(NSArray *)styles whenButtonTouchUpInSideCallBack:(_int_type_block)callBack{

    YUBottomPopSelctView * globlShareBottomView = [YUBottomPopSelctView share] ;
    // 过滤网
    if (globlShareBottomView == nil){
    
        return;
        
    }
    if(titles.count != styles.count){
    
        NSLog(@"######注意:标题个数必须要和样式个数相同!");
        
    }
    
    // 设置选择表按下后回调block方法
    globlShareBottomView.whenSelectViewTouchUpInside = callBack;
    
    YUDarkGlassView * glassView  = [YUDarkGlassView share];
    
      // 将黑色遮罩加入到WINDOW
    [self addSubview:glassView];
    
    [globlShareBottomView removeFromSuperview];
    
    [globlShareBottomView ySetAutoSizeWithButtonTitles:titles styles:styles]; // 设置了宽高
    
    [self popSelectView:globlShareBottomView];

}
#pragma mark 弹出菜单 代理回调方式
-(void)showPopWithButtonTitles:(NSArray *)titles styles:(NSArray *)styles deledge:(id<YUBottomPopSelctViewDeledge>)deledge{
    
    YUBottomPopSelctView * globlShareBottomView = [YUBottomPopSelctView share] ;
    // 过滤网
    if (globlShareBottomView == nil){
    
        return;
        
    }

    globlShareBottomView.deldge = deledge;
    
    YUDarkGlassView * glassView  = [YUDarkGlassView share];
    
    // 将黑色遮罩加入到WINDOW
    [self addSubview:glassView];
    [globlShareBottomView ySetAutoSizeWithButtonTitles:titles styles:styles]; // 设置了宽高
    
    [self popSelectView:globlShareBottomView];
    
}

#pragma mark 弹出选择框
-(void)popSelectView:(UIView *)view {

    // 将选择列表加入到window
    [self addSubview:view];
    // 设置坐标
    [view y_setLeft:0];
    
    [view y_setTop:ScreenHeight];
  
    [UIView animateWithDuration:0.3 animations:^{
        
        [YUDarkGlassView share].alpha = 0.3 ;
         view.frame = CGRectMake(0, ScreenHeight -  view.frame.size.height, view.frame.size.width, view.frame.size.height);
        
    }];
    
   
    
}

#pragma mark 渐隐选择框
-(void)disMissPopSelectView{
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [YUBottomPopSelctView share].frame = CGRectMake(0, ScreenHeight, [YUBottomPopSelctView share].frame.size.width, [YUBottomPopSelctView share].frame.size.height);
        [YUDarkGlassView share].alpha = 0 ;
         
        
    } completion:^(BOOL finished) {
        [[YUDarkGlassView share] removeFromSuperview];
        [[YUBottomPopSelctView share] removeFromSuperview];
        
    }];

}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
