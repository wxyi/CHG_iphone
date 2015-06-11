//
//  MemberRewardsCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/4.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberRewardsCell : MyTableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)IBOutlet UICollectionView* RewardsView;

@end
