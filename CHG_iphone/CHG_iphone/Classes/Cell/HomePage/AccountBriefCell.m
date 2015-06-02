//
//  AccountBriefCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AccountBriefCell.h"
#import "AccountBriefCollectionCell.h"
@implementation AccountBriefCell

- (void)awakeFromNib {
    // Initialization code
    self.AccountBriefView.backgroundColor = [UIColor lightGrayColor];
    
//    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupView:(NSArray*)items
{
    self.items = items;
    [self modifyCollectionView:NO];
    [self.AccountBriefView registerNib:[UINib nibWithNibName:@"AccountBriefCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.AccountBriefView.delegate = self;
    self.AccountBriefView.dataSource=self;
    self.AccountBriefView.scrollEnabled = NO;
}
-(void) modifyCollectionView:(BOOL) isH{
//    CGFloat width = SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_HEIGHT:SCREEN_WIDTH;
//    if(isH ){
//        width=SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_WIDTH:SCREEN_HEIGHT;
//    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH-2)/3, isPad?50.f:50.f)];
    [flowLayout setMinimumLineSpacing:0.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [self.AccountBriefView setCollectionViewLayout:flowLayout];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AccountBriefCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.numberLab.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"count"];
    cell.nameLab.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.didSelectedSubItemAction) {
        self.didSelectedSubItemAction(indexPath);
    }
}
@end