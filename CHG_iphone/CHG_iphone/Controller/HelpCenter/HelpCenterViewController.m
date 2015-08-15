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
@interface HelpCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property UINib* HelpCenterCollNib;
@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"帮助中心";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setuptableview];
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

-(void)setuptableview
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.category = 0;
    [self httpGetHelps:self.category];
}
-(void) setupCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH /4,SCREEN_WIDTH /4)];
    [flowLayout setMinimumLineSpacing:0.f];
    [flowLayout setMinimumInteritemSpacing:0.f];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collection setCollectionViewLayout:flowLayout];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.pagingEnabled = YES;
    //    self.collectionview.backgroundColor = [UIColor orangeColor];
    self.HelpCenterCollNib = [UINib nibWithNibName:@"HelpCenterCollCell" bundle:nil];
    [self.collection registerNib:self.HelpCenterCollNib  forCellWithReuseIdentifier:@"cell"];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HelpCenterCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray* imagearr = @[@"icon_boss1.png",@"icon_leader.png",@"icon_seller.png",@"icon_partners.png"];
    NSArray* titleArr = @[@"门店",@"店长",@"导购",@"合作商"];
    cell.icon.image = [UIImage imageNamed:[imagearr objectAtIndex:indexPath.row]];
    cell.titlelab.text = [titleArr objectAtIndex:indexPath.row];
    cell.titlelab.textColor = [UIColor darkGrayColor ];
    if (self.category  == indexPath.row) {
        
//        DLog(@"row = %d",indexPath.row);
        cell.titlelab.textColor = UIColorFromRGB(0x171C61);
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0 ; i < 4; i++) {
        NSIndexPath* myindexpath = [NSIndexPath indexPathForRow:i inSection:0];
        HelpCenterCollCell *cell = (HelpCenterCollCell*)[self.collection cellForItemAtIndexPath:myindexpath];
        cell.titlelab.textColor = [UIColor darkGrayColor ];
    }
    self.category = indexPath.row ;
    [self httpGetHelps:indexPath.row];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] ;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] objectForKeySafe:@"title"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel* title = [[UILabel alloc] initWithFrame:v_header.frame];
    title.font = FONT(15);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"常见问题";
    [v_header addSubview:title];
    
    return v_header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpDetailsViewController *HelpDetailsView = [[HelpDetailsViewController alloc] initWithNibName:@"HelpDetailsViewController" bundle:nil];
    HelpDetailsView.dict = [self.items objectAtIndexSafe:indexPath.row];
    [self.navigationController pushViewController:HelpDetailsView animated:YES];
}
-(void)httpGetHelps:(NSInteger)category
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObjectSafe:[NSString stringWithFormat:@"%d",category + 1] forKey:@"category"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetHelps] parameters:parameter];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        if (success) {
            self.items = [data objectForKeySafe:@"datas"];
            [self.collection reloadData];
            [self.tableview reloadData];
        }
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
