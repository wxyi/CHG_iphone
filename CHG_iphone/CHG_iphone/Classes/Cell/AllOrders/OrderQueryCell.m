//
//  OrderQueryCell.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/6.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "OrderQueryCell.h"

@implementation OrderQueryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupCell
{
    QRadioButton *radio1;
    NSArray* items = [NSArray arrayWithObjects:@"全部订单",@"卖货订单",@"预定订单", nil];
    for (int i = 0 ; i < items.count; i++) {
        
        radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:[NSString stringWithFormat:@"groupId%D",1]];
        radio1.isButton = YES;
        radio1.tag = [[NSString stringWithFormat:@"11%d",i] intValue];
        radio1.frame = CGRectMake(70+i*62, 0, 62, 35);
        [radio1 setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        radio1.titleLabel.font = FONT(14);
        radio1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [radio1 setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        
        if (i == 0) {
            [radio1 setChecked:YES];
        }
        [self addSubview:radio1];
        
    }
}
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
    if (self.selectQradio) {
        self.selectQradio(radio.titleLabel.text);
    }
    
}
-(IBAction)QueryOrderBtn:(UIButton*)sender
{
    DLog(@"查询")
    if (self.queryOrder) {
        self.queryOrder(sender.tag);
    }
}
@end
