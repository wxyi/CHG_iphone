//
//  IdentificationViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/5/27.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "IdentificationViewController.h"
#import "IdentificationCell.h"
#import "RegisteredMembersViewController.h"
#import "successfulIdentifyViewController.h"
@interface IdentificationViewController ()
@property UINib* IdentificationNib;
@end

@implementation IdentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"会员识别";
    // Do any additional setup after loading the view from its nib.
    [self setupView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.ZBarReader stop];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    v_header.backgroundColor = [UIColor lightGrayColor];
    UILabel* titlelab = [[UILabel alloc] initWithFrame:v_header.frame];
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text = @"用户信息";
    titlelab.font = FONT(14);
    [v_header addSubview:titlelab];
    self.tableview.tableHeaderView = v_header;
    self.IdentificationNib = [UINib nibWithNibName:@"IdentificationCell" bundle:nil];
    
    [self loopDrawLine];
    
}


-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *codeData=[[NSString alloc]init];
    for (ZBarSymbol *sym in symbols) {
        codeData = sym.data;
        break;
    }
    
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    
}
-(void)loopDrawLine
{
    CGRect  rect = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2, 15, ZbarRead_With, 2);
    if (self.lineImage) {
        [self.lineImage removeFromSuperview];
    }
    self.lineImage = [[UIImageView alloc] initWithFrame:rect];
    self.lineImage.image = [UIImage imageNamed:@"scan_laser.png"];
    //    imageview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_laser.png"]];
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改fream的代码写在这里
                         self.lineImage.frame =CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2, 185, ZbarRead_With, 2);
                         [self.lineImage setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         if (!self.is_Anmotion) {
                             [self loopDrawLine];
                         }
                         
                     }];
    
    if (!self.is_have) {
        UIImageView *topeview=[[UIImageView alloc] init];
        topeview.backgroundColor = COLOR(0, 0, 0, 0.3);
        topeview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 15);
        
        UIImageView *lefteview=[[UIImageView alloc] init];
        lefteview.backgroundColor = COLOR(0, 0, 0, 0.3);
        lefteview.frame = CGRectMake(0, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
        
        UIImageView *righteview=[[UIImageView alloc] init];
        righteview.backgroundColor = COLOR(0, 0, 0, 0.3);
        righteview.frame = CGRectMake((SCREEN_WIDTH-ZbarRead_With)/2+ZbarRead_With, 15, (SCREEN_WIDTH-ZbarRead_With)/2, ZbarRead_With);
        
        UIImageView *bottomview=[[UIImageView alloc] init];
        bottomview.backgroundColor = COLOR(0, 0, 0, 0.3);
        bottomview.frame = CGRectMake(0, 185, SCREEN_WIDTH, 35);
        
        self.ZBarReader.tag = 101;
        
        self.ZBarReader.readerDelegate = self;
        self.ZBarReader.allowsPinchZoom = YES;//使用手势变焦
        self.ZBarReader.trackingColor = [UIColor blueColor];
        self.ZBarReader.showsFPS = NO;// 显示帧率  YES 显示  NO 不显示
        self.ZBarReader.scanCrop = CGRectMake(0, 0, 1, 1);//将被扫描的图像的区域
        
        self.ZBarReader.torchMode = 0;
        [self.ZBarReader addSubview:topeview];
        [self.ZBarReader addSubview:lefteview];
        [self.ZBarReader addSubview:righteview];
        [self.ZBarReader addSubview:bottomview];
        
        [self.ZBarReader start];
        self.is_have = YES;
    }
    [self.view addSubview:self.lineImage];
}
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IdentificationCell *cell=[tableView dequeueReusableCellWithIdentifier:@"IdentificationCell"];
    if(cell==nil){
        cell = (IdentificationCell*)[[self.IdentificationNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(IBAction)IdentificationMember:(UIButton*)sender
{
    BOOL isSuccess = NO;
    if (isSuccess) {
        
        DLog(@"识别成功");
        successfulIdentifyViewController* successfulIdentifyView = [[successfulIdentifyViewController alloc] initWithNibName:@"successfulIdentifyViewController" bundle:nil];
        
        [self.navigationController pushViewController:successfulIdentifyView animated:YES];
    }
    else
    {
        DLog(@"识别失败");
        self.stAlertView = [[STAlertView alloc] initWithTitle:@"未识别会员信息" message:@"是否注册为新会员" cancelButtonTitle:@"否" otherButtonTitle:@"是" cancelButtonBlock:^{
            DLog(@"否");
            UITextField* textfield = (UITextField*)[self.view viewWithTag:100];
            textfield.text = @"";
            
        } otherButtonBlock:^{
            DLog(@"是");
            RegisteredMembersViewController* RegisteredMembersView = [[RegisteredMembersViewController alloc] initWithNibName:@"RegisteredMembersViewController" bundle:nil];
            [self.navigationController pushViewController:RegisteredMembersView animated:YES];
        }];
        
        [self.stAlertView show];
    }
    
   
    
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
