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
    DLog(@"%d",sender.tag);
    DLog(@"%@",[NSString stringWithFormat:@"Selected: %@", sender.titleLabel.text]) ;
}

-(IBAction)selectRadio:(UIButton*)sender
{
    if (sender.tag == 100) {
        RadioButton* radio = (RadioButton*)[self viewWithTag:1000];
        radio.selected = YES;
    }
    else if (sender.tag == 101) {
        RadioButton* radio = (RadioButton*)[self viewWithTag:1001];
        radio.selected = YES;
    }
    else if (sender.tag == 102) {
        RadioButton* radio = (RadioButton*)[self viewWithTag:1002];
        radio.selected = YES;
    }
        
}
@end
