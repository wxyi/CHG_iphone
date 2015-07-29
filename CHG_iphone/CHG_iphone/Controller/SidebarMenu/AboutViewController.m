//
//  AboutViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "AboutViewController.h"
#import "NIAttributedLabel.h"
@interface AboutViewController ()<NIAttributedLabelDelegate>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"关于我们";
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:(CHGNavigationController *)self.navigationController action:@selector(gobacktoSuccess) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
//    CGRect rect = self.tableview.frame;
//    
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = NO;
    [NSObject setExtraCellLineHidden:self.tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //初始化label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    //设置自动行数与字符换行
    [label setNumberOfLines:0];
    label.font = FONT(15);
    label.lineBreakMode = NSLineBreakByClipping;
    //UILineBreakModeWordWrap;
    // 测试字串
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    NSString *text = @"    “晨冠珍爱宝贝”是一款门店管理专用APP，旨在为门店建立会员信息数据库，快速扩大门店会员规模。\r\n    晨冠 ，凝聚爱的力量！";
//    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize size = [text boundingRectWithSize:CGSizeMake(300, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;//    [label setFrame:CGRectMake:(0,0, labelsize.width, labelsize.height)];
    label.frame = CGRectMake(10, 20, size.width, size.height);
    label.text = text;
    [cell.contentView addSubview:label];
//    [cell.contentView setBackgroundColor:[UIColor clearColor]] ;
//    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -270)]; //初始化大小并自动释放
//    
//    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
//    
//    textView.font = [UIFont fontWithName:@"Arial" size:17.0];//设置字体名字和字体大小
//    
////    self.textView.delegate = self;//设置它的委托方法
//    
//    textView.backgroundColor = UIColorFromRGB(0xdddddd);//设置它的背景颜色
    
    
    
//    textView.text = @"    “晨冠珍爱宝贝”是一款门店管理专用APP，旨在为门店建立会员信息数据库，快速扩大门店会员规模。\r\n    晨冠 ，凝聚爱的力量！";//设置它显示的内容
//    
////    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
////    
////    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
//    
//    textView.scrollEnabled = NO;//是否可以拖动
//    textView.editable = NO;
//    
//    
//    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    
    
//    [cell.contentView addSubview:textView];//加入到整个页面中
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT -270 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 135;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 135;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    
    
    UIImageView* logoimage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 10, 80, 80)];
//    logoimage.layer.masksToBounds =YES;
    
//    logoimage.layer.cornerRadius =40;
    logoimage.image = [UIImage imageNamed:@"about_us_icon.png"];
    [v_header addSubview:logoimage];
    

    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 35)];
    title.text = [NSString stringWithFormat:@"当前版本:%@",[ConfigManager sharedInstance].sysVersion];
    title.textColor = UIColorFromRGB(0x323232);
    title.textAlignment = NSTextAlignmentCenter;
    [v_header addSubview:title];
    return v_header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v_footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH-40, 30)];
    title.text = @"客服热线:400-8008-404";
    title.textColor = UIColorFromRGB(0x878787);
    title.textAlignment = NSTextAlignmentLeft;
    [v_footer addSubview:title];
    
//    UILabel* title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH-40, 30)];
//    title1.text = @"官方网站:www.chgry.com";
//    title1.textColor = UIColorFromRGB(0x878787);
//    title1.textAlignment = NSTextAlignmentLeft;
//    [v_footer addSubview:title1];
//    
//    
//    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 30)];
//    title2.text = @"版权所有:上海晨冠乳业有限公司";
//    title2.textColor = UIColorFromRGB(0x878787);
//    title2.textAlignment = NSTextAlignmentLeft;
//    [v_footer addSubview:title2];
    
    NIAttributedLabel* label = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    label.frame = CGRectInset(self.view.bounds, 20, 70);
    label.font = [UIFont fontWithName:@"Optima-Regular" size:17];
    label.textColor = UIColorFromRGB(0x878787);
    label.delegate = self;
//    label.autoDetectLinks = YES;
    
    // Turn on all available data detectors. This includes phone numbers, email addresses, and
    // addresses.
    label.dataDetectorTypes = NSTextCheckingAllSystemTypes;
    
    label.text = @"官方网站:www.chgry.com"
    @"\n版权所有:上海晨冠乳业有限公司";
    
    [v_footer addSubview:label];
    return v_footer;
}

#pragma mark - NIAttributedLabelDelegate

- (void)attributedLabel:(NIAttributedLabel*)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    NSURL* url = nil;
    
//    // We can receive many different types of data types now, so we have to handle each one a little
//    // differently.
//    if (NSTextCheckingTypePhoneNumber == result.resultType) {
//        // Opens the phone app if it exists.
//        url = [NSURL URLWithString:[@"tel://" stringByAppendingString:result.phoneNumber]];
//        
//    } else if (NSTextCheckingTypeLink == result.resultType) {
//        // Simply open the URL that was tapped. emails count as URLs as well and are automatically
//        // prefixed with @"mailto:".
//        url = result.URL;
//        
//    } else if (NSTextCheckingTypeAddress == result.resultType) {
//        // Open the Maps application or Safari if the maps application isn't installed.
//        url = [NSURL URLWithString:[@"http://maps.google.com/maps?q=" stringByAppendingString:[[result.addressComponents objectForKey:NSTextCheckingStreetKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    }
//    
//    if (nil != url) {
//        if (![[UIApplication sharedApplication] openURL:url]) {
//            
//        }
//        
//    } else {
//        NSLog(@"Unsupported data type");
//    }
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
