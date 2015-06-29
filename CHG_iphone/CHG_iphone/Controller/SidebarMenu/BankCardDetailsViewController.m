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
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    self.items = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"武新义",@"name",@" 开户名",@"title", nil],
                                           [NSDictionary dictionaryWithObjectsAndKeys:@"6222222222222222",@"name",@"银行卡号",@"title" ,nil],
                                            [NSDictionary dictionaryWithObjectsAndKeys:@"工商银行",@"name",@"开户银行",@"title" ,nil], nil];
    
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.BankCardDetailsNib = [UINib nibWithNibName:@"BankCardDetailsCell" bundle:nil];
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
    BankCardDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BankCardDetailsCell"];
    if(cell==nil){
        cell = (BankCardDetailsCell*)[[self.BankCardDetailsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    
    }
    cell.namelab.text =[[self.items objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Detailslab.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"name"];
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
