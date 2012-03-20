//
// DetailMapViewController.h
// EthicalShop
//
// Created by 명철 성 on 2/2/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailMapViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate>
{
    MKMapView *myMapView;
    NSDictionary *location;
    NSString *shopName;
    NSString *shopAddress;
}

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@property (nonatomic, retain) NSDictionary *location;
@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *shopAddress;

@end