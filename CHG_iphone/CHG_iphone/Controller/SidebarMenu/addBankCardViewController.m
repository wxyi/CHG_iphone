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
@interface addBankCardViewController ()
@property UINib* AddShoppersNib;
@property UINib* SelectBankCardNib;
@end

@implementation addBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.items = [NSArray arrayWithObjects:@"持卡人",@"银行卡号",@"开户银行", nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
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
    if (indexPath.row == 0 || indexPath.row == 1) {
        AddShoppersCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AddShoppersCell"];
        if(cell==nil){
            cell = (AddShoppersCell*)[[self.AddShoppersNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.namelab.text = [self.items objectAtIndex:indexPath.row];
        cell.namelab.textAlignment = NSTextAlignmentRight;
        cell.nametext.placeholder = [self.items objectAtIndex:indexPath.row];
        cell.nametext.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 1) {
            cell.nametext.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        cell.nametext.tag = [[NSString stringWithFormat:@"101%d",indexPath.row] intValue];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

    }
    else
    {
        SelectBankCardCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectBankCardCell"];
        if(cell==nil){
            cell = (SelectBankCardCell*)[[self.SelectBankCardNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.namelab.text = [self.items objectAtIndex:indexPath.row];
        cell.selectBank.text = @"请选择银行";
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
    promptlabel.tag = 103;
    
    promptlabel.textLabel.text = @"";
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        DLog(@"请选择银行");
    }
}
-(void)Confirm
{
    UITextField* name = (UITextField*)[self.view viewWithTag:1010];
    UITextField* Card = (UITextField*)[self.view viewWithTag:1011];
    NSString* info;
    if (name.text.length == 0) {
        info = @"请输入姓名";
    }
    else if(Card.text.length == 0)
    {
        info = @"请输入银行卡";
    }
//    else if ([IdentifierValidator isValid:IdentifierTypeCreditNumber value:Card.text]) {
//        JTImageLabel *promptlabel = (JTImageLabel*)[self.view viewWithTag:103];
//        promptlabel.imageView.image = [UIImage imageNamed:@"icon_tips_big.png"];
//        promptlabel.textLabel.text = @"银行卡号不正确";
//        Card.text = @"";
//    }

    if (info.length != 0) {
        
        [SGInfoAlert showInfo:info
                      bgColor:[[UIColor darkGrayColor] CGColor]
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
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiAddBankCard] parameters:parameter];
    NSMutableDictionary *bankpar = [NSMutableDictionary dictionary];
    
    [bankpar setObject:@"CCB" forKey:@"bankCode"];
    [bankpar setObject:Card.text forKey:@"cardNumber"];
    [bankpar setObject:name.text forKey:@"accountName"];
    [bankpar setObject:@"建设银卡" forKey:@"bankCard"];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousCommonJsonRequestWithProgress:url parameters:bankpar successBlock:^(BOOL success, id data, NSString *msg) {
        if([data objectForKey:@"code"] &&[[data objectForKey:@"code"]  intValue]==200){
            [MMProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismissWithError:description];
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

@end
