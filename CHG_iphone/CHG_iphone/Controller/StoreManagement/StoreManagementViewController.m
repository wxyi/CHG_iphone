//
//  StoreManagementViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/26.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoreManagementViewController.h"
#import "DropDownListView.h"
#import "StoresInfoViewController.h"
@interface StoreManagementViewController (){
    NSMutableArray *chooseArray ;
}

@end

@implementation StoreManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   @[@"门店C",@"花相似",@"不同",@"门店Ｃ"],
                                                   
                                                   ]];
    
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,175, SCREEN_WIDTH, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    dropDownView.layer.borderWidth = 1.0;//边框
    
    [self.view addSubview:dropDownView];

}


#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"童大爷选了section:%d ,index:%d",section,index);
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}
-(IBAction)goSkipStore:(id)sender
{
    DLog(@"进入门店");
    StoresInfoViewController* StoresInfoView= [[StoresInfoViewController alloc] initWithNibName:@"StoresInfoViewController" bundle:nil];
    [self.navigationController pushViewController:StoresInfoView animated:YES];
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
