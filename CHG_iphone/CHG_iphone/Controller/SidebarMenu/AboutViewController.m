//
//  AboutViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"关于我们";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -270)]; //初始化大小并自动释放
    
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    textView.font = [UIFont fontWithName:@"Arial" size:17.0];//设置字体名字和字体大小
    
//    self.textView.delegate = self;//设置它的委托方法
    
    textView.backgroundColor = UIColorFromRGB(0xdddddd);//设置它的背景颜色
    
    
    
    textView.text = @"    “晨冠珍爱宝贝”是一款门店管理专用APP，旨在为门店建立会员信息数据库，快速扩大门店会员规模。\r\n    晨冠 ，凝聚爱的力量！";//设置它显示的内容
    
//    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
//    
//    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    textView.scrollEnabled = NO;//是否可以拖动
    
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    
    
    [cell.contentView addSubview:textView];//加入到整个页面中
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT -270 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 135;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 135;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    
    
    UIImageView* logoimage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 10, 100, 80)];
//    logoimage.layer.masksToBounds =YES;
    
//    logoimage.layer.cornerRadius =40;
    logoimage.image = [UIImage imageNamed:@"icon_logo_big.png"];
    [v_header addSubview:logoimage];
    

    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 35)];
    title.text = [NSString stringWithFormat:@"当前版本:%@",[ConfigManager sharedInstance].sysVersion];
    title.textColor = UIColorFromRGB(0x323232);
    title.textAlignment = NSTextAlignmentCenter;
    [v_header addSubview:title];
    return v_header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    title.text = @"客服热线:400-8008-404";
    title.textColor = UIColorFromRGB(0x878787);
    title.textAlignment = NSTextAlignmentCenter;
    [v_footer addSubview:title];
    
    UILabel* title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 35)];
    title1.text = @"官方网站：www.chgry.com";
    title1.textColor = UIColorFromRGB(0x878787);
    title1.textAlignment = NSTextAlignmentCenter;
    [v_footer addSubview:title1];
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 35)];
    title2.text = @"版权所有：上海晨冠乳业有限公司";
    title2.textColor = UIColorFromRGB(0x878787);
    title2.textAlignment = NSTextAlignmentCenter;
    [v_footer addSubview:title2];
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
