//
//  BasicInfoViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/29.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "BasicInfoViewController.h"

@interface BasicInfoViewController ()

@end

@implementation BasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    [self httpGetMyProfile];
    self.title = @"基本信息";
    self.items = [NSArray arrayWithObjects:@"姓名",@"手机号码",@"身份证号", nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    title.textColor = UIColorFromRGB(0x323232);
    title.font = FONT(15);
    title.text = [self.items objectAtIndex:indexPath.row];
    [cell.contentView addSubview:title];
    
    //if (indexPath.row != 2)
    {
        UILabel* infolab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
        infolab.textColor = UIColorFromRGB(0x323232);
        infolab.font = FONT(15);
        infolab.textAlignment = NSTextAlignmentRight;
        NSString* info;
        if (indexPath.row == 0) {
            info = self.BasicInfo[@"userName"];
        }
        else if (indexPath.row == 1)
        {

            if ([self.BasicInfo[@"mobile"] length] != 0) {
                NSString* idcard = self.BasicInfo[@"mobile"];
                idcard = [NSString stringWithFormat:@"*******%@",[idcard substringFromIndex:7]];
                info = idcard;
            }
            else
            {
                info = @"";
            }
        }
        
        else if (indexPath.row == 2)
        {
            if ([self.BasicInfo[@"idcardNumber"] length] != 0) {
                NSString* idcard = self.BasicInfo[@"idcardNumber"];
                idcard = [NSString stringWithFormat:@"**************%@",[idcard substringFromIndex:14]];
                info = idcard;
            }
            else
            {
                info = @"";
            }
            
        }
        infolab.text = info;
        [cell.contentView addSubview:infolab];
    }
/*    else
    {
        UIImageView * scanImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -50, 2, 40, 40)];
        scanImage.image = [QRCodeGenerator qrImageForString:self.BasicInfo[@"dimensionalCodeUrl"] imageSize:40];
        [cell.contentView addSubview:scanImage];
    }
*/
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)httpGetMyProfile
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetMyProfile] parameters:parameter];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@,msg = %@",data,msg);
        if (success) {
//            [MMProgressHUD dismiss];
            self.BasicInfo = data;
            [self.tableview reloadData];
        }
        else
        {
//            [MMProgressHUD dismissWithError:msg];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor darkGrayColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
        
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
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
