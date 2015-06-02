//
//  PromoListCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPageView.h"
@interface PromoListCell : UITableViewCell
@property(nonatomic ,strong) LKPageView* pageview;

- (id)initWithFrame:(CGRect)frame homeNews:(NSMutableArray*)news ;
@end
