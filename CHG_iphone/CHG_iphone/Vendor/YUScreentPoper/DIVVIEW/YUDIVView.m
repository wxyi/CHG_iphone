//
//  YUDIVView.m
//  YUANBAOAPP
//
//  Created by yxy on 14-8-25.
//  Copyright (c) 2014年 ATAW. All rights reserved.
//

#import "YUDIVView.h"
#import "UIView+YUStyle.h"
#define MARGIN_TOP 10
@implementation YUDIVView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if(self){
        
        _marginRight = 0;
        
        _marginTop = 0 ;
        
        [self setUp];
        
    }
    
    return self;
    

}

-(void)setUp{
    self.backgroundColor = [UIColor whiteColor];
  
    


}
#pragma mark 子视图相关
-(BOOL)isNeedLineBreak:(UIView *) view1 view2:(UIView *) view2{

    [view2 y_rightFromView:view1 distance:_marginRight];
    
    float right = [view2 y_RightX];
    
    if(right<= [self y_Width]){
        
        return NO;
    }
    return YES;
    
    
}
-(void)clearSubView{

    for(UIView * view in self.subviews )
    {
    
        [view removeFromSuperview];
        
        
    
    }
    
}
-(void)setViews:(NSArray *)views marginRight:(float) marginRight marginTop:(float) marginTop paddingLeft:(float) paddingLeft{
    
    
    [self clearSubView] ; // reset view ;
    
   
    _marginRight = marginRight ; _marginTop = marginTop ;
    
    UIView * zeroView = [[UIView alloc]initWithFrame:CGRectMake(-marginRight +paddingLeft, 0, 0, 0)];
    
    _yFianlMaxBottomY = [zeroView y_BottomY];
    
    
    _viewsArray = [[NSMutableArray alloc]init];
    
    [_viewsArray addObject:zeroView];
    for (UIView * view in views) {
        
        [_viewsArray addObject:view];
        [self addSubview:view];
    }
     // 0 1 2
    for ( int i = 1 ; i< _viewsArray.count ;i++) {
        
        UIView * view1 = [_viewsArray objectAtIndex:i-1];
        UIView * view2 = [_viewsArray objectAtIndex:i];
        
        if([self isNeedLineBreak:view1 view2:view2])
        {
            // 需要换行(是第一个                                                             )
            [view2 y_bottomFromView:view1 distance:_marginTop];
            
            [view2 y_rightFromView:zeroView distance:_marginRight];
        
        }else{
            // 不需要换行
            [view2 y_rightFromView:view1 distance:_marginRight];
            
            [view2 y_setTop:[view1 y_TopY]];
            
        }
        
        _yFianlMaxBottomY = MAX(_yFianlMaxBottomY, [view2 y_BottomY]); // 选取最下面的位置Y
        
    }
    [self resizeSubViewFrame];
    

}
-(void)resizeSubViewFrame{

    if(_viewsArray.count >1){
        
        [self y_setHeight:_yFianlMaxBottomY ];
        
    }else{
        
        [self y_setHeight:0];
        
    
    }

    
    
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
