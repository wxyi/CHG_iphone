//
//  StoresDetailsViewController.h
//  CHG_iphone
//
//  Created by wuxinyi on 15/6/1.
//  Copyright (c) 2015年 wuxinyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import <BaiduMapAPI/BMapKit.h>
#import "AddressInfo.h"
@interface StoresDetailsViewController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    IBOutlet BMKMapView* _mapView;
//    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    BMKGeoCodeSearchOption *_geocodeSearchOption;
}
@property(nonatomic,weak)IBOutlet UILabel* storeNamelab;
@property(nonatomic,strong)IBOutlet UILabel* locationField;
@property(nonatomic,strong)NSDictionary* storesDict;
@property(nonatomic,strong)AddressInfo* address;
@property(nonatomic,strong)NSDictionary* addcode;
-(IBAction)locationAddress:(UIButton*)sender;
@end
