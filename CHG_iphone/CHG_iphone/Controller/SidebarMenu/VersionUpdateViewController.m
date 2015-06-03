//
//  VersionUpdateViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "VersionUpdateViewController.h"
#import "UpdateVersionViCell.h"
@interface VersionUpdateViewController ()
@property UINib* UpdateVersionNib;
@end

@implementation VersionUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"版本更新";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.tableview.backgroundColor = [UIColor lightGrayColor];
    self.UpdateVersionNib = [UINib nibWithNibName:@"UpdateVersionViCell" bundle:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateVersionViCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UpdateVersionViCell"];
    if(cell==nil){
        cell = (UpdateVersionViCell*)[[self.UpdateVersionNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }
    cell.image.image = [UIImage imageNamed:@"image1.jpg"];
    cell.VersionNum.text = [NSString stringWithFormat:@"版本号:%@",[ConfigManager sharedInstance].sysVersion];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SCREEN_WIDTH - 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 60)];
//    v_footer.backgroundColor = [UIColor lightGrayColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    titlelab.text = @"新特性";
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.textColor = [UIColor grayColor];
    [v_footer addSubview:titlelab];
    
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 120)];
    image.image = [UIImage imageNamed:@"image1.jpg"];
    [v_footer addSubview:image];
    return v_footer;
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
