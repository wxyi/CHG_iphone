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
    _TextStepper.Maximum = 60;
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
    if (_counter > 60) {
        _counter = 60;
        
        [SGInfoAlert showInfo:@"该商量已超过销售数量限制，禁止添加商品！"
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self
                     vertical:0.7];
    }
    else if(_counter < 0)
    {
        _counter = 0;
    }
    if (self.showCount) {
        self.showCount(_counter);
    }
}
@end
