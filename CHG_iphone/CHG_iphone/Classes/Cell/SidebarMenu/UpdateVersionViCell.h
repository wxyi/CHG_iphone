//
//  UpdateVersionViCell.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateVersionViCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView* image;
@property(nonatomic,weak)IBOutlet UILabel* VersionNum;
//@property(nonatomic,weak)IBOutlet UIButton* DownBtn;
-(void)setUpdateVersionCell;
//-(IBAction)DownVersion:(id)sender;
@end
