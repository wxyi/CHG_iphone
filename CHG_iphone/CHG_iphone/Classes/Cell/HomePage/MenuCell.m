//
//  MenuCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/25.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MenuCell.h"
#import "MenuCollectionCell.h"
@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.MenuCollection.backgroundColor = [UIColor lightGrayColor];
//    [self setupView];
    self.items = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupView:(NSMutableArray*)items
{
    self.items = items;
    [self modifyCollectionView:NO];
    self.MenuCollection.frame = CGRectMake(1, 0, SCREEN_WIDTH-2, self.height);
    DLog(@"self.MenuCollection.frame = %@",NSStringFromCGRect(self.MenuCollection.frame) );
    [self.MenuCollection registerNib:[UINib nibWithNibName:@"MenuCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
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
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH-2)/3, (SCREEN_WIDTH-2)/3)];
    [flowLayout setMinimumLineSpacing:1.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    [self.MenuCollection setCollectionViewLayout:flowLayout];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageName.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[[self.items objectAtIndex:indexPath.row] objectForKey:@"icon"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = [[self.items objectAtIndex:indexPath.row] objectForKey:@"icon"];
    if (self.didSelectedSubItemAction && title.length > 0) {
        self.didSelectedSubItemAction(indexPath);
    }
}

- (void)layoutSubviews //在这里进行元素的详细设置
{
    [super layoutSubviews];

    CGRect rect = self.frame;
    rect.size.height = self.height;
    self.frame = rect;
//    self.contentView.frame = rect;
    DLog(@"self.frame = %@",NSStringFromCGRect(self.frame) );
}
@end
