//
//  PresellCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "PresellCell.h"
#import "PresellOperation.h"
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
    _TextStepper.IsEditableTextField=NO;
}
- (IBAction)ibStepperDidStep:(id)sender {
    
    NSString* Clicktype = @"0";//0为不操作，1为减去数量，2为加上数量
    if (_TextStepper.TypeChange == TextStepperFieldChangeKindNegative) {
        _counter--;
        Clicktype = @"1";
    }
    else {
        _counter++;
        Clicktype = @"2";
    }
    if (_counter > 60) {
        _counter = 60;
        Clicktype = @"0";
//        [SGInfoAlert showInfo:@"该商量已超过销售数量限制，禁止添加商品！"
//                      bgColor:[[UIColor blackColor] CGColor]
//                       inView:self
//                     vertical:0.7];
    }
    else if(_counter < 1)
    {
        Clicktype = @"0";
        _counter = 1;
    }
    if (self.showCount) {
        self.showCount(Clicktype,self.price,self.indexPath,_counter);
    }
    PresellOperation * operation = [[PresellOperation alloc] init];
    operation.strClickType = Clicktype;
    operation.indexpath = self.indexPath;
    operation.operationPage = self.operationPage;
    [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_SINGLE_GOODS object:operation];
}
@end
