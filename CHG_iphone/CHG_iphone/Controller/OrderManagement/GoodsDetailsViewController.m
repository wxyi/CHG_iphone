//
//  GoodsDetailsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/3.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "DetailsCell.h"
@interface GoodsDetailsViewController ()
@property UINib* DetailsNib;
@end

@implementation GoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    self.isWebViewLoad = NO;
//    CGRect rect = self.tableview.frame;
//    rect.size.height = SCREEN_HEIGHT ;
//    rect.size.width = SCREEN_WIDTH;
//    self.tableview.frame = rect;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [NSObject setExtraCellLineHidden:self.tableview];
    self.DetailsNib = [UINib nibWithNibName:@"DetailsCell" bundle:nil];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  
                                  initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    
    [self.activityIndicatorView setCenter: self.view.center] ;
    
    [self.activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    
    [self.view addSubview : self.activityIndicatorView] ;
    
    [self httpGetProduct ];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DetailsCell"];
        if(cell==nil){
            cell = (DetailsCell*)[[self.DetailsNib instantiateWithOwner:self options:nil] objectAtIndex:0];
            
        }
        cell.imageview.image = [UIImage imageNamed:@"default_small.png"];
        cell.titlelab.text = @"Hikid聪乐壮 金装复合益生元益生菌婴儿配方奶粉1段";
        cell.describelab.text = @"新西兰进口奶源，厂家直送";
        cell.pricelab.text = @"￥265";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"InfoCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier  ] ;
        }
        
        if (!self.myWebView) {
            self.myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        }
        //        self.myWebView.scalesPageToFit = YES;                  //自动缩放页面以适应屏幕
        
        [self.myWebView setUserInteractionEnabled:NO];
        self.myWebView.delegate = self;
        [cell.contentView addSubview:self.myWebView];
        
        
        
        NSString* strhtml = @"http://www.baidu.com";
        if (self.isWebViewLoad == NO && strhtml.length != 0) {
            
            NSLog(@"html = %@",strhtml);
//            [self.myWebView loadHTMLString:strhtml baseURL:nil];
            NSURL *url =[NSURL URLWithString:strhtml];
            
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.myWebView loadRequest:request];
        }
        
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 270;
    }
    else
    {
        return self.m_height;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error

{
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alterview show];
    
}


- (void )webViewDidStartLoad:(UIWebView  *)webView   //网页开始加载的时候调用
{
    NSLog(@"webViewDidStartLoad");
    [self.activityIndicatorView startAnimating] ;
}


- (void )webViewDidFinishLoad:(UIWebView *)webView //网页加载完成的时候调用
{
    NSLog(@"webViewDidFinishLoad");
    //
    [self.activityIndicatorView stopAnimating] ;
    
    
    [self setWebViewRatio:webView tag:@"img" width:305];
    [self setWebViewRatio:webView tag:@"table" width:305];
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeMake(320, INT16_MAX)];
    frame.size = fittingSize;
    
    //    NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    //    frame.size.height = [fitHeight floatValue];
    webView.frame = CGRectMake(0, 0, 320, frame.size.height * 320 / frame.size.width);
    [webView setScalesPageToFit:YES];
    NSLog(@"~~~~~~~~~~~~~%.2f", frame.size.height * 320 / frame.size.width);
    self.m_height = frame.size.height * 320 / frame.size.width;
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
            NSString *SetWidth = [NSString stringWithFormat:@"document.getElementsByTagName(\"%@\")[%d].width = 305;",strlabel,i];
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

-(void)httpGetProduct
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    [parameter setObject:[ConfigManager sharedInstance].shopId forKey:@"shopId"];
    [parameter setObject:self.strProductId forKey:@"productId"];
    
    DLog(@"parameter = %@",parameter);
    NSString* url = [NSObject URLWithBaseString:[APIAddress ApiGetOrderList] parameters:parameter];
    
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        DLog(@"data = %@ msg = %@",data,msg);
        if (success) {
            [MMProgressHUD dismiss];
        }
        else
        {
            [MMProgressHUD dismiss];
            [SGInfoAlert showInfo:msg
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:self.view
                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD dismissWithError:description];
        [MMProgressHUD dismiss];
        [SGInfoAlert showInfo:description
                      bgColor:[[UIColor blackColor] CGColor]
                       inView:self.view
                     vertical:0.7];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
    
    }];
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
