//
//  MemberMenuCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/4.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MemberMenuCell.h"
#import "MemberMenuColCell.h"
@implementation MemberMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupView:(NSArray*)items
{
    self.items = [items mutableCopy];
    [self modifyCollectionView:NO];
    
    [self.MenuCollection registerNib:[UINib nibWithNibName:@"MemberMenuColCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.MenuCollection.delegate = self;
    self.MenuCollection.dataSource=self;
    self.MenuCollection.scrollEnabled = NO;
}
-(void) modifyCollectionView:(BOOL) isH{
    //    CGFloat width = SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_HEIGHT:SCREEN_WIDTH;
    //    if(isH ){
    //        width=SCREEN_WIDTH>SCREEN_HEIGHT?SCREEN_WIDTH:SCREEN_HEIGHT;
    //    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH-2)/3, 72)];
    [flowLayout setMinimumLineSpacing:0.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [self.MenuCollection setCollectionViewLayout:flowLayout];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberMenuColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageName.text = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"title"];
    cell.imageView.image = [UIImage imageNamed:[[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"icon"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = [[self.items objectAtIndexSafe:indexPath.row] objectForKeySafe:@"icon"];
    if (self.didSelectedSubItemAction && title.length > 0) {
        self.didSelectedSubItemAction(indexPath);
    }
}
@end
