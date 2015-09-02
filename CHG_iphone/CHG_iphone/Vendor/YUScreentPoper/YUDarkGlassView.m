//
//  YUDarkGlassView.m
//  YUANBAOAPP
//
//  Created by yxy on 14/11/20.
//  Copyright (c) 2014年 ATAW. All rights reserved.
//

#import "YUDarkGlassView.h"
#import "UIWindow+YUBottomPoper.h"
#import "yConst.h"
@implementation YUDarkGlassView


-(id)initDefault{
    
    self =[super initWithFrame:CGRectMake(0, 0, (int)[UIScreen mainScreen].bounds.size.width, ScreenHeight)];
    
    if(self){
        
        self.backgroundColor = [UIColor blackColor];
        
        self.alpha = 0;
        
    
    }
    
    return self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    YUBottomPopSelctView * popView =    [YUBottomPopSelctView share];
    
    popView.whenSelectViewTouchUpInside(popView.yTitles.count -1);
    
    
    [self.window  disMissPopSelectView];
    
   
    
    
}

+(YUDarkGlassView *)share{

    static YUDarkGlassView * view = nil;
    
    if(view == nil){
    
        view = [[YUDarkGlassView alloc]initDefault];
        
    
    }
    
    return view;

}

-(void)dealloc{


}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
