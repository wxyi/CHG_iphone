//
//  AccountBriefCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AccountBriefSelect)(NSIndexPath* indexPath);

@interface AccountBriefCell : MyTableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)IBOutlet UICollectionView* AccountBriefView;
@property(nonatomic,weak)IBOutlet UIImageView* line;

@end
