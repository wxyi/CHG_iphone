//
//  HelpCenterCollCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "HelpCenterCollCell.h"

@implementation HelpCenterCollCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setupTableview:(NSArray*)items
{
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.bounces = NO;
    self.items = items;
    
    if (self.selectBtn) {
        self.selectBtn(self.indexPath);
    }
    [self.tableview reloadData];
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
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] ;
    }
    cell.backgroundColor = UIColorFromRGB(0xf0f0f0);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    DLog(@"title = %@", [[self.items objectAtIndex:indexPath.row] objectForKeySafe:@"title"]);
    cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] objectForKeySafe:@"title"];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    v_header.backgroundColor = UIColorFromRGB(0xdddddd);
    UILabel* label = [[UILabel alloc] initWithFrame:v_header.frame];
    label.font = FONT(15);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"常见问题";
    [v_header addSubview:label];
    return v_header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"url = %@",[[self.items objectAtIndex:indexPath.row] objectForKeySafe:@"url"]);
    if (self.skipweb) {
        self.skipweb([self.items objectAtIndex:indexPath.row]);
    }
}
@end
