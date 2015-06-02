//
//  LKWelcomeView.h
//  CarDaMan
//
//  Created by y h on 12-9-24.
//  Copyright (c) 2012年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKWelcomeView : UIView<UIScrollViewDelegate>
{
    int width;
}
@property (strong, nonatomic) UIScrollView *page_scroll;
@property (strong, nonatomic) UIPageControl *page_control;
@property (nonatomic,strong) UIImageView *left;
@property (nonatomic,strong) UIImageView *right;
@property(strong,nonatomic) UIImageView* lastImageView;
-(id)initWithFrame:(CGRect)frame andPathArray:(NSArray*)array;
@property(strong,nonatomic)void(^endEvent)(void);
@end
