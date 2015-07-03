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
    
    
    UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
    if ([config.Roles isEqualToString:@"PARTNER"]&& config.nRoleType == 0) {
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
    [NSObject setExtraCellLineHidden:self.tableview];
    self.BankCardDetailsNib = [UINib nibWithNibName:@"BankCardDetailsCell" bundle:nil];
    
    [ConfigManager sharedInstance].strBankId = [NSString stringWithFormat:@"%d",[self.items[@"bankId"] intValue]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BankCardDetailsCell"];
    if(cell==nil){
        cell = (BankCardDetailsCell*)[[self.BankCardDetailsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    }
    if (indexPath.row == 0) {
        cell.namelab.text =@"开户名";
        cell.Detailslab.text = self.items[@"accountName"];
    }
    else if (indexPath.row == 1)
    {
        cell.namelab.text =@"银行卡号";
        cell.Detailslab.text = self.items[@"cardNumber"];
        
        
    }
    else
    {
        cell.namelab.text =@"开户银行";
        
        BanKCode* code = [[BanKCode alloc] init];
        //    DLog(@"[textField.text substringToIndex:6] = %@",[textField.text substringToIndex:6]);
        code = [[SQLiteManager sharedInstance] getBankCodeDataByCardCode:self.items[@"bankCode"]];
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
