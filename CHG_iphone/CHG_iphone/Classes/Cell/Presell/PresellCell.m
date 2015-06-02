//
//  PresellCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PresellCell.h"

@implementation PresellCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupCell
{
    _counter = 1;
    _TextStepper.Current = 1;
    _TextStepper.Step = 1;
    _TextStepper.Minimum=1;
    _TextStepper.Maximum = 10;
    _TextStepper.NumDecimals =0;
    _TextStepper.IsEditableTextField=YES;
}
- (IBAction)ibStepperDidStep:(id)sender {
    if (_TextStepper.TypeChange == TextStepperFieldChangeKindNegative) {
        _counter--;
    }
    else {
        _counter++;
    }
    
}
@end
