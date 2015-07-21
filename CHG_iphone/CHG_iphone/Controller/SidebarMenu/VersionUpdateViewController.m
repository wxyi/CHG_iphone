//
//  VersionUpdateViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "VersionUpdateViewController.h"
#import "UpdateVersionViCell.h"
@interface VersionUpdateViewController ()
@property UINib* UpdateVersionNib;
@end

@implementation VersionUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"版本更新";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.tableview.backgroundColor = [UIColor lightGrayColor];
    self.UpdateVersionNib = [UINib nibWithNibName:@"UpdateVersionViCell" bundle:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateVersionViCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UpdateVersionViCell"];
    if(cell==nil){
        cell = (UpdateVersionViCell*)[[self.UpdateVersionNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
    }
    cell.image.image = [UIImage imageNamed:@"icon.png"];
    cell.VersionNum.text = [NSString stringWithFormat:@"版本号:%@",[self.items objectForKeySafe: @"appVersion"]];
    cell.VersionUrl = [self.items objectForKeySafe:@"url"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SCREEN_WIDTH - 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 60)];
//    v_footer.backgroundColor = [UIColor lightGrayColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titlelab.text = @"新特性";
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.textColor = [UIColor grayColor];
    [v_footer addSubview:titlelab];
    
    UITextView* textview = [[UITextView alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 120)];
    textview.textColor = [UIColor grayColor];//设置textview里面的字体颜色
    
    textview.font = [UIFont fontWithName:@"Arial" size:15.0];//设置字体名字和字体大小

//    textview.delegate = self;//设置它的委托方法

    textview.backgroundColor = UIColorFromRGB(0xf0f0f0);//设置它的背景颜色
    textview.text = [self.items objectForKeySafe:@"appDes"];//设置它显示的内容

//    textview.returnKeyType = UIReturnKeyDefault;//返回键的类型
//    textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
//    textview.scrollEnabled = YES;//是否可以拖动
    textview.editable = NO;
    textview.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [v_footer addSubview: textview];//加入到整个页面中
//    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 120)];
//    image.image = [UIImage imageNamed:@"image1.jpg"];
//    [v_footer addSubview:image];
    return v_footer;
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
