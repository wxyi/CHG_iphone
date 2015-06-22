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
@interface StoresDetailsViewController : UIViewController<LMComBoxViewDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    IBOutlet BMKMapView* _mapView;
//    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    BMKGeoCodeSearchOption *_geocodeSearchOption;
}
@property(nonatomic,weak)IBOutlet UILabel* storeNamelab;
@property(nonatomic,weak)IBOutlet UITextField* locationField;
@property(nonatomic,strong)NSDictionary* storesDict;

@property(nonatomic,strong)NSDictionary* addcode;
-(IBAction)locationAddress:(UIButton*)sender;
@end
