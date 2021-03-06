//
//  addBankCardViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/5.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "addBankCardViewController.h"
#import "AddShoppersCell.h"
#import "SelectBankCardCell.h"
#import "JTImageLabel.h"
#import "UIPopoverListView.h"
@interface addBankCardViewController ()<UIPopoverListViewDataSource, UIPopoverListViewDelegate,UITextFieldDelegate>
@property UINib* AddShoppersNib;
@property UINib* SelectBankCardNib;
@end

@implementation addBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [leftButton.layer setBorderWidth:1.0]; //边框
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
    self.bankitems = [[NSMutableArray alloc] init];
    
    self.bankitems = [[SQLiteManager sharedInstance] getBankCodeDatas];
    self.items = [NSArray arrayWithObjects:@"持卡人",@"银行卡号",@"开户银行",@"支行信息", nil];
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.AddShoppersNib = [UINib nibWithNibName:@"AddShoppersCell" bundle:nil];
    self.SelectBankCardNib = [UINib nibWithNibName:@"SelectBankCardCell" bundle:nil];
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
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3) {
        AddShoppersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AddShoppersCell"];
        if(cell==nil){
            cell = (AddShoppersCell*)[[self.AddShoppersNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        cell.namelab.text = [self.items objectAtIndexSafe:indexPath.row];
        
        cell.namelab.textAlignment = NSTextAlignmentRight;
        cell.nametext.placeholder = [self.items objectAtIndexSafe:indexPath.row];
//        cell.nametext.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
        cell.nametext.delegate = self;
        [cell.nametext addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        if (indexPath.row == 0) {
            UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
            cell.nametext.text = config.strUsername;
        }
        
        cell.nametext.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 1) {
            cell.nametext.keyboardType = UIKeyboardTypeNumberPad;
//            cell.nametext.delegate = self;
            
        }
        
        cell.nametext.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

    }
    else
    {
        SelectBankCardCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectBankCardCell"];
        if(cell==nil){
            cell = (SelectBankCardCell*)[[self.SelectBankCardNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
            
        }
        cell.namelab.text = [self.items objectAtIndexSafe:indexPath.row];
        cell.selectBank.text = @"请选择银行";
        cell.selectBank.textAlignment = NSTextAlignmentRight;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 85;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    
    JTImageLabel *promptlabel = [[JTImageLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    promptlabel.tag = 103333;
    
    promptlabel.textLabel.text = @"";
    promptlabel.textLabel.font = FONT(12);
    promptlabel.textLabel.textColor = UIColorFromRGB(0x171c61);
    promptlabel.textLabel.textAlignment = NSTextAlignmentCenter;
//    promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//    promptlabel.textLabel.text = @"持卡人名称不能大于32位";
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 2) {
        DLog(@"请选择银行");
        UITextField* Card = (UITextField*)[self.view viewWithTag:1011];
        NSString* CardNum = [Card.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * info = @"";
        if (CardNum.length == 0) {
            info = @"请输入银行卡";
            
        }
        else if(CardNum.length < 16 ||CardNum.length > 19)
        {
            info = @"银行卡不能小于16位大于19位";
            
        }
        if(info.length != 0)
        {
            [SGInfoAlert showInfo:info
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            return;
        }
        [self getBankCardList];
    }
}
-(void)Confirm
{
    UITextField* name = (UITextField*)[self.view viewWithTag:1010];
    [name resignFirstResponder];
    UITextField* Card = (UITextField*)[self.view viewWithTag:1011];
    [Card resignFirstResponder];
    
    UITextField* bankname = (UITextField*)[self.view viewWithTag:1013];
    [bankname resignFirstResponder];
    
    NSString* CardNum = [Card.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    UITextField* Cardtype = (UITextField*)[self.view viewWithTag:1012];
    [Card resignFirstResponder];
    NSString* info;
    if (name.text.length == 0) {
        info = @"请输入姓名";
    }
    else if ([NSObject stringContainsEmoji:name.text]|| [Utils checkName:name.text]) {
        DLog(@"包含表情");
        info = @"名称只能输入中文、数字、字母、“_”";
        
    }
    else if (name.text.length < 2) {
        info = @"名字不能小于两位";
    }
    else if(CardNum.length == 0)
    {
        info = @"请输入银行卡";
    }
    else if(CardNum.length <16 ||CardNum.length >19)
    {
        info = @"银行卡不能小于16位大于19位";
        
    }
    else if ([Cardtype.text isEqualToString:@"请选择银行"])
    {
        info = @"请选择银行";
    }
    else if (bankname.text.length != 0 && [Utils checkChinaName:bankname.text])
    {
        info = @"支行信息只能包含中文";

    }
    
//    else if ([IdentifierValidator isValid:IdentifierTypeCreditNumber value:Card.text]) {
//        JTImageLabel *promptlabel = (JTImageLabel*)[self.view viewWithTag:103];
//        promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//        promptlabel.textLabel.text = @"银行卡号不正确";
//        Card.text = @"";
//    }

    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
        return ;
    }
    
    [self httpAddBankCard];
}

-(void)httpAddBankCard
{
    UITextField* name = (UITextField*)[self.view viewWithTag:1010];
    UITextField* Card = (UITextField*)[self.view viewWithTag:1011];
    UITextField* bankname = (UITextField*)[self.view viewWithTag:1013];
    NSString* CardNum = [Card.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiAddBankCard] parameters:parameter];
    NSMutableDictionary *bankpar = [NSMutableDictionary dictionary];
    
//    BanKCode* code = [[BanKCode alloc] init];
//    DLog(@"[textField.text substringToIndex:6] = %@",[Card.text substringToIndex:6]);
//    code = [[SQLiteManager sharedInstance] getBankCodeDataByCardCode:[Card.text substringToIndex:6]];
    
   
    [bankpar setObjectSafe:self.bank.bankCode forKey:@"bankCode"];
    [bankpar setObjectSafe:CardNum forKey:@"cardNumber"];
    [bankpar setObjectSafe:name.text forKey:@"accountName"];
    [bankpar setObjectSafe:bankname.text forKey:@"bankName"];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:bankpar successBlock:^(BOOL success, id data, NSString *msg) {
        DLog(@"data = %@ msg = %@",[data objectForKeySafe:@"datas"],[data objectForKey:@"msg"]);
        if([data objectForKeySafe:@"code"] &&[[data objectForKeySafe:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            
            [SGInfoAlert showInfo:@"添加成功"
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
//            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:[data objectForKeySafe:@"msg"]
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
//            [MMProgressHUD dismissWithError:[data objectForKey:@"msg"]];
            
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    } Refresh_tokenBlock:^(BOOL success) {
        [self httpAddBankCard];
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
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.text.length >= 6) {
//        BanKCode* code = [[BanKCode alloc] init];
//        DLog(@"[textField.text substringToIndex:6] = %@",[textField.text substringToIndex:6]);
//        code = [[SQLiteManager sharedInstance] getBankCodeDataByCardNumber:[textField.text substringToIndex:6]];
//        DLog(@"code = %@ name = %@",code.bankCode,code.bankName);
//        UILabel* textlab = (UILabel*)[self.view viewWithTag:1012];
//        
//        if (code.bankName.length != 0) {
//            textlab.text = code.bankName;
//        }
//        
//    }
////    else
////    {
////        [SGInfoAlert showInfo:@"银行卡错误"
////                      bgColor:[[UIColor blackColor] CGColor]
////                       inView:self.view
////                     vertical:0.7];
////    }
//    
//}

-(void)getBankCardList
{
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -100)/2,64,SCREEN_WIDTH-100,SCREEN_HEIGHT -40)];
    poplistview.delegate = self;
    poplistview.datasource = self;
//    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"请选择银行"];
    [poplistview show];
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
    
    BanKCode* textbank = [self.bankitems objectAtIndexSafe:indexPath.row];
    cell.textLabel.text = textbank.bankName;
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return self.bankitems.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
    
    self.bank = [self.bankitems objectAtIndexSafe:indexPath.row];
    UILabel* textlab = (UILabel*)[self.view viewWithTag:1012];
    textlab.text = self.bank.bankName;
    textlab.textAlignment = NSTextAlignmentLeft;
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void) textFieldDidChange:(UITextField*) field {
    
    UILabel* textlab = (UILabel*)[self.view viewWithTag:1012];
    NSString* info;
    if (field.tag == 1010) {
        if (field.markedTextRange == nil&& field.text.length > 15) {
            field.text = [field.text substringToIndex:15];
            info = @"持卡人姓名不能大于15位";
        }
//        if (field.text.length > 15) {
//            
//            field.text = [field.text substringToIndex:15];
////            [field resignFirstResponder];
//            info = @"持卡人姓名不能大于20位";
//        }
    }
    else if(field.tag == 1011)
    {
        NSString *text = [field.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length >= 6 && text.length <= 19) {
            BanKCode* code = [[BanKCode alloc] init];
            DLog(@"[textField.text substringToIndex:6] = %@",[text substringToIndex:6]);
            code = [[SQLiteManager sharedInstance] getBankCodeDataByCardNumber:[text substringToIndex:6]];
            DLog(@"code = %@ name = %@",code.bankCode,code.bankName);
            self.bank = code;
            
            if (code.bankName.length != 0) {
                textlab.text = code.bankName;
                textlab.textAlignment = NSTextAlignmentLeft;
            }
            else
            {
                textlab.text = @"请选择银行";
                textlab.textAlignment = NSTextAlignmentRight;
            }
            
        }
        else if(field.text.length >= 23)
        {
            field.text = [field.text substringToIndex:23];
            info = @"银行卡号不能大于19位";
//            [field resignFirstResponder];
        }
        else
        {
            textlab.textAlignment = NSTextAlignmentRight;
            textlab.text = @"请选择银行";
        }
    }
    else if (field.tag == 1013)
    {
//        NSString* lang = [[UITextInputMode currentInputMode] primaryLanguage];
//        if ([lang isEqualToString:@"zh-Hans"]) {
//            UITextRange *selectedRange = [field markedTextRange];
//            UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
//            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//            if (!position) {
//                if (field.text.length > 20) {
//                    field.text = [field.text substringToIndex:20];
//                }
//            }
//            else
//            {
//                //有高亮选择的字符串，则暂不对文字进行统计和限制
//            }
//            
//        }
//        else
//        {
//            //中文输入法以外的直接对基统计限制即可，不考虑其他的语种情况
//            if (field.text.length > 20) {
//                field.text = [field.text substringToIndex:20];
//            }
//        }
        if (field.markedTextRange == nil&& field.text.length > 20) {
            field.text = [field.text substringToIndex:20];
            info = @"支行信息不能大于20位";
        }
    }
    
    if (info.length > 0) {
        JTImageLabel* imagelabel = (JTImageLabel*)[self.view viewWithTag:103333];
        imagelabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
        imagelabel.textLabel.text = info;
        [imagelabel layoutSubviews];
    }
    else
    {
        JTImageLabel* imagelabel = (JTImageLabel*)[self.view viewWithTag:103333];
        imagelabel.imageView.image = nil;
        imagelabel.textLabel.text = @"";
        [imagelabel layoutSubviews];
    }
    

}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSString* info;
//    if (textField.tag == 1011) {
//        if (textField.text.length < 19) {
//            info
//        }
//    }
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1010) {
        if (string.length == 0) return YES;
        
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
                //        NSInteger existedLength = textField.text.length;
        //        NSInteger selectedLength = range.length;
        //        NSInteger replaceLength = string.length;
        
//        NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        if (![pred evaluateWithObject:string]) {
//            return NO;
//        }
        
        if (textField.text.length >= 15 && string.length > range.length) {
            return NO;
        }
    }
    else if (textField.tag == 1011) {
        if (string.length == 0) return YES;
        
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 23) {
            return NO;
        }
        NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length % 4 == 0 && text.length != 0 && textField.text.length % 5 != 0) {
            textField.text = [textField.text stringByAppendingString:@" "];
        }
    }
    else if (textField.tag == 1013) {
        if (string.length == 0) return YES;
        
       
        if ([NSObject stringContainsEmoji:string]) {
            return NO;
        }

        
        
        
        if (textField.text.length >= 20 && string.length > range.length) {
            return NO;
        }
    }
    return YES;
}
@end
