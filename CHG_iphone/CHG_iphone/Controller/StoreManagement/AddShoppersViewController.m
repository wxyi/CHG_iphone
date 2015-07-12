//
//  AddShoppersViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/2.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AddShoppersViewController.h"
#import "JTImageLabel.h"
#import "AddShoppersCell.h"
@interface AddShoppersViewController ()<UITextFieldDelegate>
@property UINib* AddShoppersNib;
@end

@implementation AddShoppersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.PersonnerType == StorePersonnelTypeManager)
        self.title = @"添加店长";
    else
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
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.AddShoppersNib = [UINib nibWithNibName:@"AddShoppersCell" bundle:nil];
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
    AddShoppersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AddShoppersCell"];
    if(cell==nil){
        cell = (AddShoppersCell*)[[self.AddShoppersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    cell.namelab.text = [self.items objectAtIndex:indexPath.row];
    cell.nametext.placeholder = @"必填";
    cell.nametext.delegate = self;
//    [cell.nametext addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cell.nametext.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
    
    if (indexPath.row == 1) {
        cell.nametext.keyboardType = UIKeyboardTypeNumberPad;
    }
//    cell.nametext.text = @"345立水火火";
/*    if (indexPath.row == 1) {
        cell.nametext.enabled = YES;
    }
    else
    {
        cell.nametext.enabled = NO;
    }
 */
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
    shopName.text = @"职务";
    [v_header addSubview:shopName];
    
    UILabel* bossName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    if (self.PersonnerType == StorePersonnelTypeManager)
        bossName.text = @"店长";
    else
        bossName.text = @"导购";
    
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
    
    JTImageLabel *promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    promptlabel.tag = 103333;
    promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
    promptlabel.textLabel.text = @"确认添加后信息不可修改";
    promptlabel.textLabel.font = FONT(12);
    promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
    promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
//    promptlabel.backgroundColor = UIColorFromRGB(0xdddddd);
    [v_footer addSubview:promptlabel];
    UIButton* Confirmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Confirmbtn.backgroundColor = UIColorFromRGB(0x171c61);
    [Confirmbtn.layer setMasksToBounds:YES];
    [Confirmbtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    //    [loginout.layer setBorderWidth:1.0]; //边框
    Confirmbtn.frame = CGRectMake(5, 40, SCREEN_WIDTH-10 , 40);
    [Confirmbtn setTitle:@"确认添加" forState:UIControlStateNormal];
    [Confirmbtn setTitleColor:UIColorFromRGB(0xf0f0f0) forState:UIControlStateNormal];
    [Confirmbtn addTarget:self action:@selector(Confirm) forControlEvents:UIControlEventTouchUpInside];
    [v_footer addSubview:Confirmbtn];
    
    return v_footer;
}
-(void)Confirm
{
    DLog(@"确认添加");
    UITextField* textfield;
//    for (int i = 0; i < 3; i++)
    {
//        NSInteger tag = 1010
        textfield = (UITextField*)[self.view viewWithTag:1010];
        NSString *name = textfield.text;
        [textfield resignFirstResponder];
        textfield = (UITextField*)[self.view viewWithTag:1011];
        NSString *iphone = textfield.text;
        [textfield resignFirstResponder];
        textfield = (UITextField*)[self.view viewWithTag:1012];
        NSString *cardNum = textfield.text;
        
        [textfield resignFirstResponder];
        
        
        NSString * info = @"";
        if (name.length == 0) {
            info = @"请输入姓名";
        }
        else if (iphone.length == 0)
        {
            info = @"请输入手机号";
        }
        else if (![IdentifierValidator isValid:IdentifierTypePhone value:iphone ])
        {
            info = @"手机格式不正确";
        }
        else if (cardNum.length == 0)
        {
            info = @"请输入身份证号";
        }
        else if (cardNum.length != 18)
        {
            DLog(@"%d",cardNum.length);
            info = @"身份证格式不正确";
        }
        else if([Utils checkUserIdCard:cardNum])
        {
            info = @"身份证格式不正确";
        }
        if (info.length != 0) {
            [SGInfoAlert showInfo:info
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            return;

        }
    }
    [self httpUpdateSeller];
}
-(void)httpUpdateSeller
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];

    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiUpdateSeller] parameters:parameter];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    {"shopId":"1",
//        "personType":"0",

//        "sellerName":"MsellerName",
//        "sellerMobile":"15912345678",
//        "idCardNumber":"667778899"}
    [param setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    NSString* personType;
    if (self.PersonnerType == StorePersonnelTypeManager) {
        personType = @"1";
    }
    else
    {
        personType = @"0";
    }
    [param setObject:personType forKey:@"personType"];
    //姓名
    
    NSArray* array =  @[@"sellerName", @"sellerMobile", @"idCardNumber"];
    UITextField* textfield;
    for (int i = 0; i < array.count; i++) {
        NSInteger tag = [[NSString stringWithFormat:@"101%d",i] intValue];
        textfield = (UITextField*)[self.view viewWithTag:tag];
        [param setObject:textfield.text forKey:[array objectAtIndex:i]];
    }
    DLog(@"param = %@",param);
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:param successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",data,[data objectForKey:@"msg"]);
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200)
        {
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKey:@"msg"]
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
//- (void) textFieldDidChange:(UITextField*) field {
//
//    NSString* info;
//    if (field.tag == 1010) {
//        if (field.text.length > 32) {
//            field.text = [field.text substringToIndex:32];
////            [field resignFirstResponder];
//            info = @"姓名不能大于32位";
//        }
//    }
//    else if(field.tag == 1011)
//    {
//        if (field.text.length > 11) {
//            info = @"手机号不能大于11位";
//        }
//        else if ((field.text.length == 11&&[[field.text substringToIndex:1] intValue] != 1)) {
//            field.text = [field.text substringToIndex:11];
////            [field resignFirstResponder];
//            info = @"手机号格式不正确";
//        }
//        field.text = [field.text substringToIndex:11];
//    }
//    else if(field.tag == 1012)
//    {
//        if (field.text.length > 18 ) {
//            field.text = [field.text substringToIndex:18];
////            [field resignFirstResponder];
//            info = @"身份证号不能大于18位";
//        }
//    }
//    
//    if (info.length > 0) {
//        JTImageLabel* imagelabel = (JTImageLabel*)[self.view viewWithTag:103333];
//        imagelabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//        imagelabel.textLabel.text = info;
//        [imagelabel layoutSubviews];
//    }
//    else
//    {
//        JTImageLabel* imagelabel = (JTImageLabel*)[self.view viewWithTag:103333];
//        imagelabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//        imagelabel.textLabel.text = @"确认添加后信息不可修改";
//        [imagelabel layoutSubviews];
//    }
//    
//    
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1010) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 32) {
            return NO;
        }
    }
    else if (textField.tag == 1011) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    else
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
    }
    return YES;
}
@end
