//
//  HelpCenterViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HelpCenterCollCell.h"
#import "HelpDetailsViewController.h"
#import "UIButtonImageWithLable.h"
@interface HelpCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property UINib* HelpCenterCollNib;
@property (nonatomic,strong)NSMutableArray* btnArray;
@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"帮助中心";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupTopView];
    [self setupCollectionView];
}
-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setuptableview
//{
//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
////    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.category = 0;
//    [self httpGetHelps:self.category];
//}
-(void)setupTopView
{
    self.btnArray = [[NSMutableArray alloc] init];
//    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4)];
//    bgView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    NSArray* imagearr = @[@"icon_boss1.png",@"icon_leader.png",@"icon_seller.png",@"icon_partners.png"];
    NSArray* titleArr = @[@"门店",@"店长",@"导购",@"合作商"];
    for (int i = 0; i < 4; i ++) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.backgroundColor = [UIColor clearColor];
        [Button setFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 80)];
//        [Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Button setImage:[UIImage imageNamed:[imagearr objectAtIndex:i]] withTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [Button setTitleColor:[UIColor darkGrayColor ] forState:UIControlStateNormal];
        [Button setTitleColor:UIColorFromRGB(0x171C61) forState:UIControlStateSelected];
        [Button addTarget:self action:@selector(SwitchViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        Button.tag = [[NSString stringWithFormat:@"100%d",i] integerValueSafe];
        [Button.layer setBorderWidth:.5];
        UIColor *color = UIColorFromRGB(0xdddddd);
        [Button.layer setBorderColor:color.CGColor];
//        UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, 1, SCREEN_WIDTH/4)];
//        line.backgroundColor = [UIColor grayColor];
//        [bgView addSubview:line];
        [self.btnArray addObject:Button];
        if (i == 0) {
            Button.selected = YES;
        }
        [self.bgView addSubview:Button];
    }
//    [self.view addSubview:bgView];
    self.items = [[NSMutableArray alloc] init];
    self.category = 1;
    [self httpGetHelps:self.category];
}
-(void) setupCollectionView{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT - 80)];
    [flowLayout setMinimumLineSpacing:0.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collection setCollectionViewLayout:flowLayout];
    self.collection.bounces = NO;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.pagingEnabled = YES;
    //    self.collectionview.backgroundColor = [UIColor orangeColor];
    self.HelpCenterCollNib = [UINib nibWithNibName:@"HelpCenterCollCell" bundle:nil];
    [self.collection registerNib:self.HelpCenterCollNib  forCellWithReuseIdentifier:@"cell"];
    
}
-(void)SwitchViewBtn:(UIButton*)sender
{
    DLog(@"tag = %d",sender.tag);
    if(!sender.selected){
        for (UIButton *eachBtn in self.btnArray) {
            if(eachBtn.isSelected){
                [eachBtn setSelected:NO];
            }
        }
        [sender setSelected:YES];
        if (self.items.count != 0) {
            NSString *strtag = [NSString stringWithFormat:@"%d",sender.tag];
            NSInteger row = [[strtag substringFromIndex:2] integerValueSafe];
            [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

        }
    }
}
-(void)selectBtn:(UIButton*)sender
{
    if(!sender.selected){
        for (UIButton *eachBtn in self.btnArray) {
            if(eachBtn.isSelected){
                [eachBtn setSelected:NO];
            }
        }
        [sender setSelected:YES];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HelpCenterCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    DLog(@"")
    cell.indexPath = indexPath;
    [cell setupTableview:[self.items objectAtIndex:indexPath.row]];
    cell.selectBtn = ^(NSIndexPath* indexPath){
//        UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",indexPath.row] integerValueSafe]];
//        [self selectBtn:btn];
    };
 
    
    cell.skipweb = ^(NSDictionary* dict)
    {
        [self didSelectViewController:dict];
    };
/*    NSArray* imagearr = @[@"icon_boss1.png",@"icon_leader.png",@"icon_seller.png",@"icon_partners.png"];
    NSArray* titleArr = @[@"门店",@"店长",@"导购",@"合作商"];
    cell.icon.image = [UIImage imageNamed:[imagearr objectAtIndex:indexPath.row]];
    cell.titlelab.text = [titleArr objectAtIndex:indexPath.row];
    cell.titlelab.textColor = [UIColor darkGrayColor ];
    if (self.category  == indexPath.row) {
        
//        DLog(@"row = %d",indexPath.row);
        cell.titlelab.textColor = UIColorFromRGB(0x171C61);
    }*/
    return cell;
    
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    for (int i = 0 ; i < 4; i++) {
//        NSIndexPath* myindexpath = [NSIndexPath indexPathForRow:i inSection:0];
//        HelpCenterCollCell *cell = (HelpCenterCollCell*)[self.collection cellForItemAtIndexPath:myindexpath];
//        cell.titlelab.textColor = [UIColor darkGrayColor ];
//    }
//    self.category = indexPath.row ;
//    [self httpGetHelps:indexPath.row];
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.items.count;
//}
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"InfoCell";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] ;
//    }
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] objectForKeySafe:@"title"];
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    UILabel* title = [[UILabel alloc] initWithFrame:v_header.frame];
//    title.font = FONT(15);
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = @"常见问题";
//    [v_header addSubview:title];
//    
//    return v_header;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HelpDetailsViewController *HelpDetailsView = [[HelpDetailsViewController alloc] initWithNibName:@"HelpDetailsViewController" bundle:nil];
//    HelpDetailsView.dict = [self.items objectAtIndexSafe:indexPath.row];
//    [self.navigationController pushViewController:HelpDetailsView animated:YES];
//}
-(void)didSelectViewController:(NSDictionary*)dict
{
    HelpDetailsViewController *HelpDetailsView = [[HelpDetailsViewController alloc] initWithNibName:@"HelpDetailsViewController" bundle:nil];
    HelpDetailsView.dict =dict;
    [self.navigationController pushViewController:HelpDetailsView animated:YES];

}
-(void)httpGetHelps:(NSInteger)category
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObjectSafe:[NSString stringWithFormat:@"%d",category] forKey:@"category"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetHelps] parameters:parameter];

    DLog(@"url = %@",url);
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        if (success) {
            
            [self.items addObject:[data objectForKeySafe:@"datas"]];
            
            if (self.category <4) {
                self.category += 1;
                [self httpGetHelps:self.category];
                
            }
            else
            {
                [self.collection reloadData];
            }
            
            
//            [self.tableview reloadData];
        }
        else
        {
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    NSLog(@"frame = %@",NSStringFromCGRect(scrollView.frame));
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    DLog(@"index = %d",index);
    UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index] integerValueSafe]];
    [self selectBtn:btn];
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
}
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//    return YES;
//}
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
//{
//    CGPoint point=scrollView.contentOffset;
//    NSLog(@"%f,%f",point.x,point.y);
//    NSInteger index = point.x /SCREEN_WIDTH;
//    DLog(@"scrollViewDidScrollToTop --- index = %d",index);
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (decelerate) {
//        NSLog(@"wxy-------scrollViewDidEndDragging  -  End of Scrolling.");
//        CGPoint point=scrollView.contentOffset;
//        NSLog(@"%f,%f",point.x,point.y);
//        NSInteger index = point.x /SCREEN_WIDTH;
//        DLog(@"wxy --- index = %d",index);
//
////        if (self.point.x < point.x) {
////            
////            if (point.x -self.point.x > 160 && index + 1 <= self.items.count) {
////                
////                UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index+1] integerValueSafe]];
////                [self selectBtn:btn];
////            }
////            else
////            {
////                UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index] integerValueSafe]];
////                [self selectBtn:btn];
////            }
////            
////        }
////        else if(self.point.x > point.x)
////        {
////            if (self.point.x - point.x > 160 && index - 1 >= 0) {
////                UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index-1] integerValueSafe]];
////                [self selectBtn:btn];
////            }
////            else
////            {
////                UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index] integerValueSafe]];
////                [self selectBtn:btn];
////            }
////        }
////        else
////        {
////            UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index] integerValueSafe]];
////            [self selectBtn:btn];
////        }
////
////
//        
//    }
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
////开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDragging");
    self.point =scrollView.contentOffset;
    NSLog(@"%f,%f",self.point.x,self.point.y);
}
//减速停止了时执行，手触摸时执行执行
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewDidEndDecelerating");
//    CGPoint point=scrollView.contentOffset;
//    NSLog(@"%f,%f",point.x,point.y);
//    NSInteger index = self.point.x /SCREEN_WIDTH;
//    DLog(@"index = %d",index);
//    if (self.point.x < point.x) {
//        
//        if (point.x -self.point.x > 160 && index + 1 <= self.items.count) {
//            
//            UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index+1] integerValueSafe]];
//            [self selectBtn:btn];
//        }
//        else
//        {
//            UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index+1] integerValueSafe]];
//            [self selectBtn:btn];
//        }
//        
//    }
//    else if(self.point.x > point.x)
//    {
//        if (self.point.x - point.x > 160 && index - 1 >= 0) {
//            UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index-1] integerValueSafe]];
//            [self selectBtn:btn];
//        }
//        else
//        {
//            
//        }
//    }
//    else
//    {
//        UIButton* btn = (UIButton*)[self.view viewWithTag:[[NSString stringWithFormat:@"100%d,",index] integerValueSafe]];
//        [self selectBtn:btn];
//    }
//
//
//    
//}
@end
