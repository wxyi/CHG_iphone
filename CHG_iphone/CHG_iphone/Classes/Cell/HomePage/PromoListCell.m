//
//  PromoListCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PromoListCell.h"

@implementation PromoListCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithFrame:(CGRect)frame homeNews:(NSMutableArray*) news{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.pageview = [[LKPageView alloc] initWithURLStringArray:news andFrame:frame];
        [self addSubview:self.pageview];
    }
    return self;
}
//-(void)setUpPromoList:(NSArray*)imageArr
//{
//    DLog(@"frame = %@",NSStringFromCGRect(self.bounds));
//    
//    self.pageview = [[LKPageView alloc] initWithPathStringArray:imageArr andFrame:CGRectMake(0, -10, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
//    [self addSubview:self.pageview];
//}
@end
