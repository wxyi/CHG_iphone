//
//  registeredMenuCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/5.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registeredMenuCell : MyTableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)IBOutlet UICollectionView* RewardsView;

@end
