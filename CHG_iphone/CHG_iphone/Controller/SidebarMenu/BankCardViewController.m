//
//  BankCardViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BankCardViewController.h"
#import "BanKCardCell.h"
//#import "AddBankCardTableViewController.h"
#import "BankCardDetailsViewController.h"
#import "addBankCardViewController.h"
@interface BankCardViewController ()
@property UINib* BanKCardNib;
@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    
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
    
    
    NSInteger count =  [[[SQLiteManager sharedInstance] getBankCodeDatas] count];
    if (count == 0) {
        [[SUHelper sharedInstance] GetBankCodeInfo];
    }
    
    self.items = [[NSMutableArray alloc] init];
    
    self.title = @"银行卡";
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled= NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.BanKCardNib = [UINib nibWithNibName:@"BanKCardCell" bundle:nil];
    
    
    // Example four
    [self.addbtn createTitle:@"添加银行卡" withIcon:[UIImage imageNamed:@"btn_add.png"] font:[UIFont systemFontOfSize:17] iconHeight:JTImageButtonIconHeightDefault iconOffsetY:JTImageButtonIconOffsetYNone];
    self.addbtn.titleColor = [UIColor whiteColor];
    self.addbtn.iconColor = [UIColor whiteColor];
    self.addbtn.padding = JTImageButtonPaddingSmall;
    self.addbtn.bgColor = UIColorFromRGB(0x171c61);
    self.addbtn.borderWidth = 0;
    self.addbtn.iconSide = JTImageButtonIconSideLeft;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self httpGetBankCardList];
}
-(IBAction)addBankCard:(id)sender{
    DLog(@"填加银行卡");
    
    addBankCardViewController* AddBankCardView = [[addBankCardViewController alloc] initWithNibName:@"addBankCardViewController" bundle:nil];
    [self.navigationController pushViewController:AddBankCardView animated:YES];
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
    BanKCardCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BanKCardCell"];
    if(cell==nil){
        cell = (BanKCardCell*)[[self.BanKCardNib instantiateWithOwner:self options:nil] objectAtIndexSafe:0];
        
        UserConfig* config = [[SUHelper sharedInstance] currentUserConfig];
        if ( config.nRoleType != 1)
        {
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor whiteColor]
                                                         icon:[UIImage imageNamed:@"left_slide_delete.png"]];
            [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
            cell.delegate = self;
        }
   
    }
    cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
    NSDictionary* dict = [self.items objectAtIndexSafe:indexPath.row];
//    [cell.BankImage setImageWithURL:[NSURL URLWithString:dict[@"cardPicturePath"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    cell.BankImage.image = [UIImage imageNamed:@"icon.png"];
    BanKCode* code = [[BanKCode alloc] init];
//    DLog(@"[textField.text substringToIndex:6] = %@",[textField.text substringToIndex:6]);
    code = [[SQLiteManager sharedInstance] getBankCodeDataByCardCode:dict[@"bankCode"]];
    cell.BankNameLab.text = code.bankName;
    cell.CardTypeLab.text = [dict objectForKeySafe: @"cardType"];
    
    NSString* numlab = [dict objectForKeySafe:@"cardNumber"];
    cell.tailNumLab.text = [numlab substringFromIndex:numlab.length - 4];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardDetailsViewController* BankCardDetailsView = [[BankCardDetailsViewController alloc] initWithNibName:@"BankCardDetailsViewController" bundle:nil];
    BankCardDetailsView.items = [self.items objectAtIndexSafe:indexPath.row];
    [self.navigationController pushViewController:BankCardDetailsView animated:YES];
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
//            [cell hideUtilityButtonsAnimated:YES];
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否确认解绑绑定?" message:@"" cancelButtonTitle:@"是" otherButtonTitle:@"否" cancelButtonBlock:^{
                DLog(@"否");
                
                [self httpDeleteBankCard];
            } otherButtonBlock:^{
                DLog(@"是");
                
                // Delete button was pressed
                
                
            }];
            
            [self.stAlertView show];
            
            
            break;
        }
        default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

-(void)httpGetBankCardList
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetBankCardList] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@,msg = %@",data,msg);
        
        if (success) {
//            [MMProgressHUD dismiss];
            if ([[data allKeys] count] == 0) {
                self.tableview.hidden = YES;
                self.addbtn.hidden = NO;
            }
            else
            {
//                [self.items removeAllObjects];
                if ([self.items count] != 0) {
                    [self.items removeAllObjects];
                }
                [self.items addObjectSafe:data];
                self.tableview.hidden = NO;
                self.addbtn.hidden = YES;
                [self.tableview reloadData];
            }
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
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
        [self httpGetBankCardList];
    }];
}

-(void)httpDeleteBankCard
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObjectSafe:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObjectSafe:[NSString stringWithFormat:@"%d",[[[self.items objectAtIndexSafe:0] objectForKeySafe: @"bankId"] intValue]] forKey:@"bankId"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiDeleteBankCard] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (success) {
//            [MMProgressHUD dismiss];
            [self httpGetBankCardList];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
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
        [self httpDeleteBankCard];
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
