//
//  HelpDetailsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/8/10.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "HelpDetailsViewController.h"

@interface HelpDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HelpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 10, 50, 24)];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_hl"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton] ;
    self.title = @"帮助中心";
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  
                                  initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    
    [self.activityIndicatorView setCenter: self.view.center] ;
    
    [self.activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    
    [self.view addSubview : self.activityIndicatorView] ;
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.bounces = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] ;
    }
    
    if (!self.webview) {
        self.webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    }
    //        self.myWebView.scalesPageToFit = YES;                  //自动缩放页面以适应屏幕
    
    [self.webview setUserInteractionEnabled:NO];
    self.webview.delegate = self;
    [cell.contentView addSubview:self.webview];
    
    
    
    NSString* strhtml = [self.dict objectForKeySafe:@"url"];
    if (self.isWebViewLoad == NO && strhtml.length != 0) {
        
        NSLog(@"html = %@",strhtml);
        //            [self.myWebView loadHTMLString:strhtml baseURL:nil];
        NSURL *url =[NSURL URLWithString:strhtml];
        
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
    }

    
    
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.m_height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.dict objectForKey:@"title"];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    v_header.backgroundColor = UIColorFromRGB(0xf0f0f0);
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    titleLab.font = FONT(13);
    titleLab.textColor = UIColorFromRGB(0x646464);
    titleLab.text = [self.dict objectForKey:@"title"];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [v_header addSubview:titleLab];
    UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorFromRGB(0xf5a541);
    [v_header addSubview:line];
    return v_header;
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    [self.activityIndicatorView startAnimating] ;
}
- (void )webViewDidFinishLoad:(UIWebView *)webView //网页加载完成的时候调用
{
    NSLog(@"webViewDidFinishLoad");
    //
    [self.activityIndicatorView stopAnimating] ;
    
    
    [self setWebViewRatio:webView tag:@"img" width:SCREEN_WIDTH];
    [self setWebViewRatio:webView tag:@"table" width:SCREEN_WIDTH];
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeMake(SCREEN_WIDTH, INT16_MAX)];
    frame.size = fittingSize;
    
    //    NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    //    frame.size.height = [fitHeight floatValue];
    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height * SCREEN_WIDTH / frame.size.width);
    [webView setScalesPageToFit:YES];
    NSLog(@"~~~~~~~~~~~~~%.2f", frame.size.height * SCREEN_WIDTH / frame.size.width);
    self.m_height = frame.size.height * SCREEN_WIDTH / frame.size.width;
    self.isWebViewLoad = YES;
    
    
    [self.tableview reloadData];
}

-(void) setWebViewRatio:(UIWebView*)webView tag:(NSString*)strlabel width:(CGFloat)width
{
    NSString *labcount = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\").length",strlabel];
    labcount = [webView stringByEvaluatingJavaScriptFromString:labcount];
    for (int i = 0; i < [labcount intValue]; i++) {
        NSString *labelheight = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].height",strlabel,i];
        labelheight = [webView stringByEvaluatingJavaScriptFromString:labelheight];
        
        NSString *labelwidth = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].width",strlabel,i];
        labelwidth = [webView stringByEvaluatingJavaScriptFromString:labelwidth];
        
        NSString *labelwidth1 = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].style.width",strlabel,i];
        labelwidth1 = [webView stringByEvaluatingJavaScriptFromString:labelwidth1];
        labelwidth1 = [labelwidth1 stringByReplacingOccurrencesOfString:@"px" withString:@""];
        
        NSLog(@"labelheight = %@  labelwidth = %@",labelheight,labelwidth);
        CGFloat  ratio;
        if ([labelwidth floatValue] != 0) {
            ratio = [labelheight floatValue]/[labelwidth floatValue];
        }
        NSLog(@"ratio = %.2f",ratio);
        if ([labelwidth floatValue]> 305) {
            NSString *SetWidth = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].width =  n;",strlabel,i];
            SetWidth = [webView stringByEvaluatingJavaScriptFromString:SetWidth];
            NSString *setHeight = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].height = %.2f;",strlabel,i,305*ratio];
            setHeight = [webView stringByEvaluatingJavaScriptFromString:setHeight];
            NSLog(@"SetWidth===%@ setHeight=== %@",SetWidth,setHeight);
        }
        
        if ([labelwidth1 floatValue]>305) {
            NSString *SetWidth = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].style.width = \"305px\";", strlabel, i];
            SetWidth = [webView stringByEvaluatingJavaScriptFromString:SetWidth];
        }
        
    }
}
-(BOOL)webView:(UIWebView *)webView  shouldStartLoadWithRequest:(NSURLRequest *)request
{
    NSLog(@"开始加载");
    return YES;
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
