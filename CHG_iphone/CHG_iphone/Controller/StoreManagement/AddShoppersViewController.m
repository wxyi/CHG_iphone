//
//  AddShoppersViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/2.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AddShoppersViewController.h"
#import "NIAttributedLabel.h"
@interface AddShoppersViewController ()<UITextFieldDelegate>

@end

@implementation AddShoppersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加导购";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.items = [NSArray arrayWithObjects:@"姓名",@"手机号码",@"身份证号" ,nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-100 , 40)];
    //        [textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    
    textField.placeholder = @""; //默认显示的字
    
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel* shopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
    shopName.text = @"门店";
    [v_header addSubview:shopName];
    
    UILabel* bossName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    bossName.text = @"花相似";
    bossName.textAlignment = NSTextAlignmentRight;
    [v_header addSubview:bossName];
    return v_header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    NIAttributedLabel* label = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
    
    // When we assign the text we do not include any markup for the images.
    label.text = @"确认添加后信息不可修改";
    
    label.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(14);
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectInset(self.view.bounds, 40, 0);
    [label insertImage:[UIImage imageNamed:@"icon_tips_small.png"]
               atIndex:0
               margins:UIEdgeInsetsMake(15, 10, 5, 5)];
    
    [v_footer addSubview:label];
    UIButton* Confirmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Confirmbtn.backgroundColor = [UIColor redColor];
    [Confirmbtn.layer setMasksToBounds:YES];
    [Confirmbtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    //    [loginout.layer setBorderWidth:1.0]; //边框
    Confirmbtn.frame = CGRectMake(5, 40, SCREEN_WIDTH-10 , 40);
    [Confirmbtn setTitle:@"确认添加" forState:UIControlStateNormal];
    [Confirmbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Confirmbtn addTarget:self action:@selector(Confirm) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:Confirmbtn];
    
    return v_footer;
}
-(void)Confirm
{
    DLog(@"确认添加");
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
