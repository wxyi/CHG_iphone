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
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    
    self.items = [[NSMutableArray alloc] init];
    
    self.title = @"银行卡";
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled= NO;
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
        cell = (BanKCardCell*)[[self.BanKCardNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor whiteColor]
                                                 icon:[UIImage imageNamed:@"left_slide_delete.png"]];
        [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
        cell.delegate = self;

        
    }
    
    NSDictionary* dict = [self.items objectAtIndex:indexPath.row];
    [cell.BankImage setImageWithURL:[NSURL URLWithString:dict[@"cardPicturePath"]] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
    cell.BankNameLab.text = dict[@"bankCode"];
    cell.CardTypeLab.text = dict[@"cardType"];
    
    NSString* numlab = dict[@"cardNumber"];
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
    [self.navigationController pushViewController:BankCardDetailsView animated:YES];
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
//            [cell hideUtilityButtonsAnimated:YES];
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否删除此银行卡" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
                
                
            } otherButtonBlock:^{
                DLog(@"是");
                
                // Delete button was pressed
                [self httpDeleteBankCard];
                
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
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
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
                [self.items addObject:data];
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
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.5];
        }
        

    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.5];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

-(void)httpDeleteBankCard
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[NSString stringWithFormat:@"%d",[self.items[0][@"bankId"] intValue]] forKey:@"bankId"];
    
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
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.5];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor darkGrayColor] CGColor]
                       inView:self.view
                     vertical:0.5];
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
