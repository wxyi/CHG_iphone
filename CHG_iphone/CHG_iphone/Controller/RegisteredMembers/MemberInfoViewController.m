//
//  MemberInfoViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "MembersRelationCell.h"
#import "MembersBirthdayCell.h"
#import "MembersSexCell.h"
#import "SuccessRegisterViewController.h"
#import "CHGNavigationController.h"

@interface MemberInfoViewController ()<UUDatePickerDelegate,UITextFieldDelegate>
@property UINib* MembersRelationNib;
@property UINib* MembersBirthdayNib;
@property UINib* MembersSexNib;
@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员注册";
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:(UINavigationController*)self.navigationController action:@selector(RegisteSuccessful)];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
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
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
//    self.tableview.scrollEnabled = NO;
//    [NSObject setExtraCellLineHidden:self.tableview];
    self.MembersRelationNib = [UINib nibWithNibName:@"MembersRelationCell" bundle:nil];
    self.MembersBirthdayNib = [UINib nibWithNibName:@"MembersBirthdayCell" bundle:nil];
    self.MembersSexNib = [UINib nibWithNibName:@"MembersSexCell" bundle:nil];
    
    //delegate
    self.datePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, SCREEN_WIDTH, 200)
                                                        Delegate:self
                                                     PickerStyle:UUDateStyle_YearMonthDay];
    NSDate *now = [NSDate date];
    self.datePicker.ScrollToDate = now;
//    self.datePicker.maxLimitDate = now;
//    self.datePicker.minLimitDate = [now dateByAddingTimeInterval:-111111111];
//    rect = self.promptlabel.frame;
//    rect.origin.y = SCREEN_WIDTH -70;
//    self.promptlabel.frame = rect;
//    self.promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//    self.promptlabel.textLabel.text = @"请仔细校对填写信息,确认之后不能修改";
//    self.promptlabel.textLabel.font = FONT(12);
//    self.promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
//    self.promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
//    self.promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
//    
//    rect = self.submitbtn.frame;
//    rect.origin.y = SCREEN_WIDTH -40;
//    self.submitbtn.frame = rect;
    self.promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -70, SCREEN_WIDTH, 30)];
    self.promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
    self.promptlabel.textLabel.text = @"请仔细校对填写信息,确认之后不能修改";
    self.promptlabel.textLabel.font = FONT(12);
    self.promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
    self.promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
    self.promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);

    [self.view addSubview:self.promptlabel];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        MembersRelationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersRelationCell"];
        if(cell==nil){
            cell = (MembersRelationCell*)[[self.MembersRelationNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
//        [cell setupCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        MembersBirthdayCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersBirthdayCell"];
        if(cell==nil){
            cell = (MembersBirthdayCell*)[[self.MembersBirthdayNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
//        [cell setupCell];
        cell.Birthdayfield.inputView = self.datePicker;
        cell.Birthdayfield.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MembersSexCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersSexCell"];
        if(cell==nil){
            cell = (MembersSexCell*)[[self.MembersSexNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
//        [cell setupCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == 2) {
//        return 70;
//    }
    return 1;
}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 2) {
//        UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
//        JTImageLabel * promptlabel= [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//        promptlabel.textLabel.text = @"请仔细校对填写信息,确认之后不能修改";
//        promptlabel.textLabel.font = FONT(12);
//        promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
//        promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
//        promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
//        [v_footer addSubview:promptlabel];
//        
//        UIButton* finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        finishBtn.frame = CGRectMake(0, 30, SCREEN_WIDTH, 40);
////        [finishBtn.layer setMasksToBounds:YES];
////        [finishBtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
//        [finishBtn setBackgroundColor:UIColorFromRGB(0x171c61)];
//        [finishBtn setTitle:@"提交完成" forState:UIControlStateNormal];
//        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [finishBtn addTarget:self action:@selector(SubmitCompleted:) forControlEvents:UIControlEventTouchUpInside];
//        [v_footer addSubview:finishBtn];
//        return v_footer;
//        
//    }
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 85;
    }
    else
    {
        return 160;
    }
}

-(IBAction)SubmitCompleted:(id)sender
{
    DLog(@"提交完成");
    
    NSIndexPath* indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
    MembersRelationCell *cell = (MembersRelationCell*)[self.tableview cellForRowAtIndexPath:indexpath];
    
    
    self.strBabyRelation = @"";
    NSArray *radioGroup = cell.radioButton.groupButtons;
    for (int i = 0; i < radioGroup.count; i ++) {
        RadioButton* btn = radioGroup[i];
        if (btn.selected) {
            self.strBabyRelation = btn.titleLabel.text;
        }
    }
    
    self.strBabyRelation = [self.strBabyRelation stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    indexpath = [NSIndexPath indexPathForItem:0 inSection:2];
    MembersSexCell *cell1 = (MembersSexCell*)[self.tableview cellForRowAtIndexPath:indexpath];
    
    radioGroup = cell1.radioButton.groupButtons;
    for (int i = 0; i < radioGroup.count; i ++) {
        RadioButton* btn = radioGroup[i];
        if (btn.selected) {
            self.strBabyGender = btn.titleLabel.text;
        }
    }
    self.strBabyGender = [self.strBabyGender stringByReplacingOccurrencesOfString:@" " withString:@""];
    UITextField* textfield = (UITextField*)[self.view viewWithTag:99];
    NSString* info;
    
     if (self.strBabyRelation.length == 0) {
        info = @"请选择与宝宝关系";
    }
    else if (textfield.text.length == 0) {
        info = @"请输入宝宝生日";
    }
    else if (self.strBabyGender.length == 0) {
        info = @"请选择宝宝性别";
    }
    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    
    
    if ([self.strBabyRelation isEqualToString:@"母亲"]) {
        self.strBabyRelation = @"MOTHER";
    }
    else if ([self.strBabyRelation isEqualToString:@"父亲"])
    {
        self.strBabyRelation = @"FATHER";
        
    }
    else
    {
        self.strBabyRelation = @"OTHER";
    }
    
    if ([self.strBabyGender isEqualToString:@"女宝宝"]) {
        self.strBabyGender = @"F";
    }
    else
    {
        self.strBabyGender = @"M";
    }

    [self httpCreateCustomer];
    
}
#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    UITextField* textfield = (UITextField*)[self.view viewWithTag:99];
    textfield.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    
    
    self.strBabyBirthday = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}
-(void)httpCreateCustomer
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCreateCustomer] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafe:[ConfigManager sharedInstance].strcustMobile forKey:@"custMobile"];
    [param setObjectSafe:[ConfigManager sharedInstance].strcheckCode forKey:@"checkCode"];
    [param setObjectSafe:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObjectSafe:[ConfigManager sharedInstance].strcustName forKey:@"custName"];
    [param setObjectSafe:self.strBabyBirthday forKey:@"babyBirthday"];
    [param setObjectSafe:self.strBabyRelation forKey:@"babyRelation"];
    [param setObjectSafe:self.strBabyGender forKey:@"babyGender"];
    [param setObjectSafe:@"1" forKey:@"isBabyInfo"];
    
    DLog(@"param = %@ babyBirthday＝ %@",param,self.strBabyBirthday);
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            
            [ConfigManager sharedInstance].strCustId = [NSString stringWithFormat:@"%d",[[[data objectForKeySafe:@"datas"] objectForKeySafe:@"custId"] intValue]];
            SuccessRegisterViewController* SuccessRegisterView = [[SuccessRegisterViewController alloc] initWithNibName:@"SuccessRegisterViewController" bundle:nil];

            [self.navigationController pushViewController:SuccessRegisterView animated:YES];
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpCreateCustomer];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        self.strBabyBirthday = [dateformatter stringFromDate:senddate];
        [dateformatter setDateFormat:@"YYYY年MM月dd日"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        textField.text = locationString;
//        self.strBabyBirthday = locationString;
        NSLog(@"locationString:%@",self.strBabyBirthday);
    }
}
@end
