//
//  StoresDetailsViewController.m
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import "StoresDetailsViewController.h"
#import "LMContainsLMComboxScrollView.h"
#import "AddressInfo.h"
#define kDropDownListTag 1000
@interface StoresDetailsViewController ()
{
//    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;   //地址选择字典
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
}
@property(nonatomic,weak)IBOutlet LMContainsLMComboxScrollView *bgScrollView;
@end

@implementation StoresDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"门店详情";
    
    
//    _locService = [[BMKLocationService alloc]init];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    _mapView.zoomEnabled = YES;
//    _mapView.zoomEnabledWithTap = YES;
//    _mapView.scrollEnabled = YES;
    [_mapView setZoomLevel:14];
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.storeNamelab.text = [ConfigManager sharedInstance].strStoreName;
    [self ParsingAddress];
    
    [self setUpBgScrollView];
    
//    [self httpAddressCode];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
//    _mapView.delegate = nil; // 不用时，置nil
//    _locService.delegate = nil;
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.locationField resignFirstResponder];
}
-(void)ParsingAddress
{
    //解析全国省市区信息
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
//    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
////    areaDic = [NSObject dictionaryWithJsonString:[ConfigManager sharedInstance].strAddressCode];
//    NSArray *components = [areaDic allKeys];
//    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
//        
//        if ([obj1 integerValue] > [obj2 integerValue]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        
//        if ([obj1 integerValue] < [obj2 integerValue]) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    }];
//    
//    NSMutableArray *provinceTmp = [NSMutableArray array];
//    for (int i=0; i<[sortedArray count]; i++) {
//        NSString *index = [sortedArray objectAtIndex:i];
//        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
//        [provinceTmp addObject: [tmp objectAtIndex:0]];
//    }
    
    province = [[SQLiteManager sharedInstance] getProvinceCodeData];
    AddressInfo* address = [[AddressInfo alloc] initWithDictionary:self.storesDict[@"address"]];
    
//    NSMutableArray* provinceList = [NSMutableArray array];
//    for (int i = 0; i < [province count]; i++) {
//        ProvinceInfo* info = [[ProvinceInfo alloc] init];
//        info = province[i];
//        [provinceList addObject:info.strProvince ];
//    }
//
//    province  = [provinceList mutableCopy];
    
//    NSString *index = [sortedArray objectAtIndex:0];
//    NSString *selected = [province objectAtIndex:0];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
//    
//    NSArray *cityArray = [dic allKeys];
//    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[SQLiteManager sharedInstance] getCityCodeDataByFatherID:address.strprovinceCode];
    
//    NSMutableArray* cityList = [NSMutableArray array];
//    for (int i = 0; i < [city count]; i++) {
//        CityInfo* info = [[CityInfo alloc] init];
//        info = city[i];
//        [cityList addObject:info.strCityName ];
//    }
//
//    city  = [cityList mutableCopy];
    
    
    
//    DLog(@"address = %@",areaDic);
    
    district = [[SQLiteManager sharedInstance] getAreaCodeDataByFatherID:address.strCityCode];
    
//    NSMutableArray* districtList = [NSMutableArray array];
//    for (int i = 0; i < [district count]; i++) {
//        AreaInfo* info = [[AreaInfo alloc] init];
//        info = district[i];
//        [districtList addObject:info.strAreaName ];
//    }
//    
//    district  = [districtList mutableCopy];
    
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   province,@"province",
                   city,@"city",
                   district,@"area",nil];
    
    ProvinceInfo* provinceinfo = [[SQLiteManager sharedInstance] getProvinceNameByProvinceID:address.strprovinceCode];
    selectedProvince = provinceinfo.strProvince;
    DLog(@"selectedProvince = %@",selectedProvince);
    
    
    CityInfo* Cityinfo = [[SQLiteManager sharedInstance] getCityNameByCityID:address.strCityCode];
    selectedCity = Cityinfo.strCityName;
    DLog(@"selectedProvince = %@",selectedProvince);
    
    AreaInfo* areainfo = [[SQLiteManager sharedInstance] getAreaNameByAreaID:address.strdistrictCode];
    selectedArea = areainfo.strAreaName;
    
    
    self.locationField.text = address.strAddress;
}
-(void)setUpBgScrollView
{
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    NSArray *defaultName = [NSArray arrayWithObjects:selectedProvince,selectedCity,selectedArea, nil];
//    NSArray* defName = [NSArray arrayWithObjects:selectedProvince,selectedCity,selectedArea, nil];
    for(NSInteger i=0;i<[keys count];i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(80+((SCREEN_WIDTH - 123)/3)*i, 0, (SCREEN_WIDTH - 123)/3, 40)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        
        NSMutableArray* items = [NSMutableArray array];
        for (int j = 0; j < [itemsArray count]; j++) {
            if (i == 0 ) {
                ProvinceInfo* info = [[ProvinceInfo alloc] init];
                info = itemsArray[j];
                [items addObject:info.strProvince ];

            }
            else if (i == 1)
            {
                CityInfo* info = [[CityInfo alloc] init];
                info = itemsArray[j];
                [items addObject:info.strCityName ];


            }
            else
            {
                AreaInfo* info = [[AreaInfo alloc] init];
                info = itemsArray[j];
                [items addObject:info.strAreaName ];
            }
            
        }

        comBox.defaultIndex = [items indexOfObject:defaultName[i]];
        comBox.titlesList = items;
        comBox.delegate = self;
        comBox.supView = self.bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [self.bgScrollView addSubview:comBox];
    }
    [self searchCityByCityName];
}

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    self.locationField.text = @"";
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            ProvinceInfo* proinfo = [[addressDict objectForKey:@"province"]objectAtIndex:index];
            selectedProvince = proinfo.strProvince ;
            //字典操作
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%d", index]]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
//            NSArray *cityArray = [dic allKeys];
//            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;//递减
//                }
//                
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;//上升
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//            
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for (int i=0; i<[sortedArray count]; i++) {
//                NSString *index = [sortedArray objectAtIndex:i];
//                NSArray *temp = [[dic objectForKey: index] allKeys];
//                [array addObject: [temp objectAtIndex:0]];
//            }
//            city = [NSArray arrayWithArray:array];
            city = [[SQLiteManager sharedInstance] getCityCodeDataByFatherID:proinfo.strProvinceID];
            
            CityInfo* cityinfo = [city objectAtIndex:0];
            NSString* FatherID = cityinfo.strCityID;
//            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [[SQLiteManager sharedInstance] getAreaCodeDataByFatherID:FatherID];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[self.bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            
            
            
            NSMutableArray* Cityitems = [NSMutableArray array];
            for (int j = 0; j < [[addressDict objectForKey:@"city"] count]; j++) {
                CityInfo* info = [[CityInfo alloc] init];
                info = [addressDict objectForKey:@"city"][j];
                [Cityitems addObject:info.strCityName ];
  
            }

            
            cityCombox.titlesList = Cityitems;
            [cityCombox reloadData];
            LMComBoxView *areaCombox = (LMComBoxView *)[self.bgScrollView viewWithTag:tag + 2 + kDropDownListTag];
            NSMutableArray* Areaitems = [NSMutableArray array];
            for (int j = 0; j < [[addressDict objectForKey:@"area"] count]; j++) {
                AreaInfo* info = [[AreaInfo alloc] init];
                info = [addressDict objectForKey:@"area"][j];
                [Areaitems addObject:info.strAreaName ];
                
            }
            
            
            areaCombox.titlesList = Areaitems;
//            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedCity = [Cityitems objectAtIndex:0];
            selectedArea = [Areaitems objectAtIndex:0];
            break;
        }
        case 1:
        {
            CityInfo* cityinfo = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            selectedCity = cityinfo.strCityName;
            
//            NSString *provinceIndex = [NSString stringWithFormat: @"%d", [province indexOfObject: selectedProvince]];
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
//            NSArray *dicKeyArray = [dic allKeys];
//            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//            
//            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
//            NSArray *cityKeyArray = [cityDic allKeys];
//            district = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            district = [[SQLiteManager sharedInstance] getAreaCodeDataByFatherID:cityinfo.strCityID];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[self.bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            
            NSMutableArray* Areaitems = [NSMutableArray array];
            for (int j = 0; j < [[addressDict objectForKey:@"area"] count]; j++) {
                AreaInfo* info = [[AreaInfo alloc] init];
                info = [addressDict objectForKey:@"area"][j];
                [Areaitems addObject:info.strAreaName ];
                
            }
            areaCombox.titlesList = Areaitems;
            [areaCombox reloadData];
            
            selectedArea = [district objectAtIndex:0];
            break;
        }
        case 2:
        {
            AreaInfo* Areainfo = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            selectedArea = Areainfo.strAreaName;
            break;
        }
        default:
            break;
    }
    NSLog(@"===%@===%@===%@",selectedProvince,selectedCity,selectedArea);
}
-(IBAction)locationAddress:(UIButton*)sender
{
    DLog(@"定位地置");

    
    [self searchCityByCityName];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

-(void)searchCityByCityName
{
    _geocodeSearchOption.city= selectedProvince;
    _geocodeSearchOption.address = [NSString stringWithFormat:@"%@%@%@",selectedCity,selectedArea,self.locationField.text];
    BOOL flag = [_geocodesearch geoCode:_geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

-(void)httpAddressCode
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:[ConfigManager sharedInstance].access_token forKey:@"access_token"];
    NSString *url = [NSObject URLWithBaseString:[APIAddress ApiAddressCode] parameters:parameter];
    
    //    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    //    [MMProgressHUD showWithTitle:@"" status:@""];
    [HttpClient asynchronousRequestWithProgress:url parameters:nil successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (success) {
            DLog(@"data = %@",data);
//            if (![ConfigManager sharedInstance].strAddressCode) {
                self.addcode = [data objectForKey:@"datas"];
//            }
        }
        else
        {
            [MMProgressHUD dismissWithError:msg];
            //            [SGInfoAlert showInfo:msg
            //                          bgColor:[[UIColor darkGrayColor] CGColor]
            //                           inView:self.view
            //                         vertical:0.7];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD dismissWithError:description];
    } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
    }];
}

@end
