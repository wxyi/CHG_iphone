//
//  MemberRewardsCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/4.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MemberRewardsCell.h"
#import "MemberRewardsColCell.h"
@implementation MemberRewardsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupView:(NSMutableArray*)items
{
    self.items = items;
    [self modifyCollectionView:NO];
    [self.RewardsView registerNib:[UINib nibWithNibName:@"MemberRewardsColCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.RewardsView.delegate = self;
    self.RewardsView.dataSource=self;
    self.RewardsView.scrollEnabled = NO;
}
-(void) modifyCollectionView:(BOOL) isH{
    //    CGFloat width = SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_HEIGHT:SCREEN_WIDTH;
    //    if(isH ){
    //        width=SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_WIDTH:SCREEN_HEIGHT;
    //    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH-1)/2, isPad?85.f:85.f)];
    [flowLayout setMinimumLineSpacing:0.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [self.RewardsView setCollectionViewLayout:flowLayout];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberRewardsColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.RewardsAmountLab.text = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"count"];
    
    cell.RewardsNameLab.text = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"title"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.didSelectedSubItemAction) {
        self.didSelectedSubItemAction(indexPath);
    }
}
@end
