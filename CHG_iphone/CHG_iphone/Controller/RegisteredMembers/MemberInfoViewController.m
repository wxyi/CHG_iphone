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
@interface MemberInfoViewController ()<UUDatePickerDelegate>
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:(CHGNavigationController *)self.navigationController action:@selector(skipPage)];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)skipPage
{
    DLog(@"跳过");
    SuccessRegisterViewController* SuccessRegisterView = [[SuccessRegisterViewController alloc] initWithNibName:@"SuccessRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:SuccessRegisterView animated:YES];
}
-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.scrollEnabled = NO;
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
    
    self.promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
    self.promptlabel.textLabel.text = @"请仔细校对填写信息,确认之后不能修改";
    self.promptlabel.textLabel.font = FONT(12);
    self.promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
    self.promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
    self.promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
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
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        MembersRelationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersRelationCell"];
        if(cell==nil){
            cell = (MembersRelationCell*)[[self.MembersRelationNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
//        [cell setupCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        MembersBirthdayCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersBirthdayCell"];
        if(cell==nil){
            cell = (MembersBirthdayCell*)[[self.MembersBirthdayNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
//        [cell setupCell];
        cell.Birthdayfield.inputView = self.datePicker;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        MembersSexCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MembersSexCell"];
        if(cell==nil){
            cell = (MembersSexCell*)[[self.MembersSexNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
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
    return 1;
}
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
    UITextField* textfield = (UITextField*)[self.view viewWithTag:100];
    NSString* info;
    if (textfield.text.length == 0) {
        info = @"请输入宝宝生日";
    }
    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    NSIndexPath* indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
    MembersRelationCell *cell = (MembersRelationCell*)[self.tableview cellForRowAtIndexPath:indexpath];
    
    self.strBabyRelation = cell.radioButton.titleLabel.text;
    
    
    indexpath = [NSIndexPath indexPathForItem:0 inSection:2];
    MembersSexCell *cell1 = (MembersSexCell*)[self.tableview cellForRowAtIndexPath:indexpath];
    NSString* sex = cell1.radioButton.titleLabel.text;
    sex = [sex stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([sex isEqualToString:@"女宝宝"]) {
        sex = @"F";
    }
    else
    {
        sex = @"M";
    }
    self.strBabyGender = sex;
    
    
    
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
    UITextField* textfield = (UITextField*)[self.view viewWithTag:100];
    textfield.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    
    
    self.strBabyBirthday = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}
-(void)httpCreateCustomer
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiCreateCustomer] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.strCustMobile forKey:@"custMobile"];
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [param setObject:self.strCustName forKey:@"custName"];
    [param setObject:self.strBabyBirthday forKey:@"babyBirthday"];
    [param setObject:self.strBabyRelation forKey:@"babyRelation"];
    [param setObject:self.strBabyGender forKey:@"babyGender"];
    [param setObject:self.strCheckCode forKey:@"checkCode"];
    
    DLog(@"param = %@",param);
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@",data);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            SuccessRegisterViewController* SuccessRegisterView = [[SuccessRegisterViewController alloc] initWithNibName:@"SuccessRegisterViewController" bundle:nil];
            [self.navigationController pushViewController:SuccessRegisterView animated:YES];
        }
        
        
    } failureBlock:^(NSString *description) {
        
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}
@end
