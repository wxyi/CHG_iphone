//
//  MembersRelationCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/28.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "MembersRelationCell.h"

@implementation MembersRelationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onRadioBtn:(RadioButton*)sender
{
    DLog(@"%@",[NSString stringWithFormat:@"Selected: %@", sender.titleLabel.text]) ;
}
@end
