//
//  YUBottomPopSelctView.m
//  YUANBAOAPP
//
//  Created by yxy on 14/11/20.
//  Copyright (c) 2014年 ATAW. All rights reserved.
//

#import "YUBottomPopSelctView.h"
#import "YUDIVView.h"
#import "UIButton+Bootstrap.h"
#import "UIWindow+YUBottomPoper.h"
#import "UIColor+YUColor.h"
#import "yConst.h"
#define PADDING_LEFT 20
#define PADDING_TOP 20

#define BtnHeigh 45
#define BtnMargin_top 20

#define Btn_BASE_TAG 1994
@implementation YUBottomPopSelctView


// 初始化WITH 自动宽高

-(id)init{
    self = [super init];
    
    if(self){
    
        [self setUp];
        
    }
    return self;
}

-(void)setUp{

    self.backgroundColor = [UIColor MainViewbackGroundColor];
    
    _yMainDivView = [[YUDIVView alloc]init];
    
    [_yMainDivView setFrame:CGRectMake(PADDING_LEFT, PADDING_TOP,SCREEN_WIDTH - PADDING_LEFT * 2, 0)];
    
    _yMainDivView.backgroundColor= [UIColor MainViewbackGroundColor];
    
    [self addSubview:_yMainDivView];
    
}

#pragma mark 设置按钮
-(void)ySetAutoSizeWithButtonTitles:(NSArray *)titles styles:(NSArray *)styles{
    
    // 过滤网
 
   
    
    NSMutableArray * absoluteTitles = [[NSMutableArray alloc]init];
    
    for(NSString * title in titles){
        
        [absoluteTitles addObject:title];
    }
    [absoluteTitles addObject:@"取消"];
    
    _yTitles = absoluteTitles;
    
    int sum = absoluteTitles.count;
    
    float buttonWidth = SCREEN_WIDTH - PADDING_LEFT * 2 ;
    
    float buttonHeigh = buttonHeigh;
    
    float finalHeigh = PADDING_TOP * 2 + (sum -1) * BtnMargin_top +sum * BtnHeigh;
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, finalHeigh)];
    
    NSMutableArray * mutableArray  = [[NSMutableArray alloc]init];
    
    for(int i = 0 ; i< absoluteTitles.count ;i++){
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:[absoluteTitles objectAtIndex:i] forState:UIControlStateNormal];
        
        [btn setFrame:CGRectMake(0, 0, buttonWidth, BtnHeigh)];
        
        btn.tag = Btn_BASE_TAG + i ;
        
        if(i == absoluteTitles.count - 1){
            
            // 最后一个取消按钮
            
            [btn cancelStyle];
            
        }else {
            // 普通按钮
            [self setButtonStyle:btn style: styles[i] ];
            
        }
        [btn addTarget:self action:@selector(whenButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [mutableArray addObject:btn];
    }
    
    [_yMainDivView setViews:mutableArray marginRight:0 marginTop:BtnMargin_top paddingLeft:0];

}



#pragma mark 某个按钮按下
-(void)whenButtonTouch:(id)sender{
    
    // 解析

    
    UIButton * thisBtn = (UIButton *)sender;
    
    int thisRow = thisBtn.tag - Btn_BASE_TAG;
    
    
    if([_deldge respondsToSelector:@selector(whenSelectViewTouchUpInside:) ]){
    
        [_deldge whenSelectViewTouchUpInside:thisRow];
        
    }
    
    if(_whenSelectViewTouchUpInside){
    
        _whenSelectViewTouchUpInside(thisRow);
        
    }
    [self.window disMissPopSelectView];
}

#pragma mark 设置按钮样式
-(void)setButtonStyle:(UIButton *)button style:(NSString *)style{

    if([style isEqualToString:YUDefaultStyle]){
    
        [button defaultStyle];
        
        return ;
        
    }
    
    if([style isEqualToString:YUSuccessStyle]){
        
        [button successStyle];
        
        return ;
        
    }
   
    if([style isEqualToString:YUCancelStyle]){
        
        [button cancelStyle];
        
        return ;
        
    }
    
    if([style isEqualToString:YUDangerStyle]){
        
        [button dangerStyle];
        
        return ;
        
    }


}

+(YUBottomPopSelctView *)share {
    
    static YUBottomPopSelctView * view = nil;
    
    if(view == nil){
    
        view = [[YUBottomPopSelctView alloc]init];
        
    }
    
    return view;
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
