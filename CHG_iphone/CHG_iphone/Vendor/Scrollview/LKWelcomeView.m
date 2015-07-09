//
//  LKWelcomeView.m
//  CarDaMan
//
//  Created by y h on 12-9-24.
//  Copyright (c) 2012年 LK. All rights reserved.
//

#import "LKWelcomeView.h"
#import "UIImage+SplitImageIntoTwoParts.h"
@implementation LKWelcomeView
@synthesize page_control;
@synthesize page_scroll;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //原理很简单  用ScrollView 当底层 按页滚动
        UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        scrollView.showsHorizontalScrollIndicator =NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.page_scroll = scrollView;
        
        UIPageControl* pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - 36,frame.size.width,36)];
        [self addSubview:pageControl];
        self.page_control = nil;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andPathArray:(NSArray *)array
{
    self = [self initWithFrame:frame];
    if (self) {
        int count = array.count;
        self.page_control.numberOfPages = count;
        width = frame.size.width;
        int height = frame.size.height;

        for (int i=0;i<count;i++) {
            
            NSString* path = [array objectAtIndex:i];
            UIImageView* imageview = [[UIImageView alloc] init];
            imageview.userInteractionEnabled = YES;
            
            imageview.frame = CGRectMake(i*width, 0, width, height);
            imageview.image = [UIImage imageWithContentsOfFile:path];
            imageview.tag = i;
            if(i + 1==count)
            {   //如果是 最后一页 就加个按钮
                UIButton* startBt = [UIButton buttonWithType:UIButtonTypeCustom];
                startBt.userInteractionEnabled = YES;
                startBt.frame = CGRectMake((SCREEN_WIDTH -220)/2, height-50, 220, 30);
                [startBt.titleLabel setTextAlignment:NSTextAlignmentCenter];
//                [startBt setTitle:@"立即体验" forState:UIControlStateNormal];
                [startBt setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
                [startBt addTarget:self action:@selector(startbt_pressed:) forControlEvents:UIControlEventTouchUpInside];
                [imageview addSubview:startBt];
                self.lastImageView = imageview;
            }
            [page_scroll addSubview:imageview];
        }
        page_scroll.contentSize  = CGSizeMake(count*width,height);
        page_scroll.contentOffset  = CGPointMake(0, 0);
        
    }
    return self;
}
-(void)startbt_pressed:(id)sender
{
    //别人写的 把一个UIImage 分成两块
    NSArray *array = [UIImage splitImageIntoTwoParts:self.lastImageView.image];
    
    self.left = [[UIImageView alloc] initWithImage:[array objectAtIndex:0]];
    self.left.frame = CGRectMake(0, 0, width,self.frame.size.height);
    self.right = [[UIImageView alloc] initWithImage:[array objectAtIndex:1]];
    self.right.frame = self.left.frame;
    
    [self addSubview:self.left];
    [self addSubview:self.right];
    
    self.lastImageView = nil;
    
    self.page_control.hidden = YES;
    self.page_scroll.hidden = YES;
    [self.page_control removeFromSuperview];
    [self.page_scroll removeFromSuperview];
    self.page_scroll = nil;
    self.page_control = nil;
    
    if(self.endEvent != nil)
    {
        self.endEvent();
        self.endEvent = nil;
    }
    
    self.left.transform = CGAffineTransformIdentity;
    self.right.transform = CGAffineTransformIdentity;
    [UIView beginAnimations:@"split" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.left.transform = CGAffineTransformMakeTranslation(-200 ,0);
    self.right.transform = CGAffineTransformMakeTranslation(200 ,0);
    [UIView commitAnimations];

}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"split"] && finished) {
        [self.left removeFromSuperview];
        [self.right removeFromSuperview];
        self.lastImageView = nil;
        [self removeFromSuperview];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int offsetX = scrollView.contentOffset.x;
    int pageindex = offsetX / width;
    self.page_control.currentPage = pageindex;
}
-(void)dealloc
{
    NSLog(@"LKWelcome release");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
