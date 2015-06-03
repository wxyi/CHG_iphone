//
//  BankCardViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BankCardViewController.h"
#import "BanKCardCell.h"
#import "AddBankCardTableViewController.h"
#import "BankCardDetailsViewController.h"
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
    self.title = @"银行卡";
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.BanKCardNib = [UINib nibWithNibName:@"BanKCardCell" bundle:nil];
    self.isEmpty = NO;
    if (self.isEmpty) {
        self.tableview.hidden = YES;
    }
}
-(IBAction)addBankCard:(id)sender{
    DLog(@"填加银行卡");
    
    AddBankCardTableViewController* AddBankCardView = [[AddBankCardTableViewController alloc] initWithNibName:@"AddBankCardTableViewController" bundle:nil];
    [self.navigationController pushViewController:AddBankCardView animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanKCardCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BanKCardCell"];
    if(cell==nil){
        cell = (BanKCardCell*)[[self.BanKCardNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 icon:[UIImage imageNamed:@"left_slide_delete.png"]];
        [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:60.0f];
        cell.delegate = self;

        
    }
    cell.BankImage.image = [UIImage imageNamed:@"image1.jpg"];
    cell.BankNameLab.text = @"工商银行";
    cell.CardTypeLab.text = @"信用卡";
    cell.tailNumLab.text = @"9527";
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
            [cell hideUtilityButtonsAnimated:YES];
            self.stAlertView = [[STAlertView alloc] initWithTitle:@"是否删除此银行卡" message:@"" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
                DLog(@"否");
                
                
            } otherButtonBlock:^{
                DLog(@"是");
                
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
