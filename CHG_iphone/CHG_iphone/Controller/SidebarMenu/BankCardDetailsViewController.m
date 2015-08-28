//
//  BankCardDetailsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BankCardDetailsViewController.h"
#import "BankCardDetailsCell.h"
@interface BankCardDetailsViewController ()
@property UINib* BankCardDetailsNib;
@end

@implementation BankCardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"银行卡详情";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    if (config.nRoleType != 1)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"解绑" style:UIBarButtonItemStylePlain target:(UINavigationController*)self.navigationController action:@selector(unbundlingbankCard)];
    }
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
//    self.items = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"武新义",@"name",@" 开户名",@"title", nil],
//                                           [NSDictionary dictionaryWithObjectsAndKeys:@"6222222222222222",@"name",@"银行卡号",@"title" ,nil],
//                                            [NSDictionary dictionaryWithObjectsAndKeys:@"工商银行",@"name",@"开户银行",@"title" ,nil], nil];
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.BankCardDetailsNib = [UINib nibWithNibName:@"BankCardDetailsCell" bundle:nil];
    
    [ConfigManager sharedInstance].strBankId = [NSString stringWithFormat:@"%d",[[self.items objectForKeySafe: @"bankId"] intValue]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BankCardDetailsCell"];
    if(cell==nil){
        cell = (BankCardDetailsCell*)[[self.BankCardDetailsNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
    
    }
    cell.namelab.textAlignment = NSTextAlignmentRight;
    if (indexPath.row == 0) {
        UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
        if (config.nRoleType != 1){
            cell.namelab.text =@"持卡人";
        }
        else
        {
            cell.namelab.text =@"开户名";
        }
        
        cell.Detailslab.text = [self.items objectForKeySafe:@"accountName"];
//        cell.namelab.textAlignment = NSTextAlignmentRight;
    }
    else if (indexPath.row == 1)
    {
        cell.namelab.text =@"银行卡号";
        NSString* cardnumber = [self.items objectForKeySafe:@"cardNumber"] ;
        
        NSString* temp = @"";
        for (int i = 0; i < cardnumber.length - 4; i ++) {
           temp = [temp stringByAppendingString:@"*"];
        }
        
        cardnumber = [NSString stringWithFormat:@"%@%@",temp,[cardnumber substringFromIndex:cardnumber.length -4]];
        cell.Detailslab.text = cardnumber;
        
        
    }
    else if (indexPath.row == 3)
    {
        cell.namelab.text =@"支行信息";
      
        cell.Detailslab.text = [self.items objectForKeySafe:@"bankName"];
        
        
    }
    else
    {
        cell.namelab.text =@"开户银行";
        
        BanKCode* code = [[BanKCode alloc] init];
        //    DLog(@"[textField.text substringToIndex:6] = %@",[textField.text substringToIndex:6]);
        code = [[SQLiteManager sharedInstance] getBankCodeDataByCardCode:[self.items objectForKeySafe:@"bankCode"]];
        cell.Detailslab.text = code.bankName;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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
