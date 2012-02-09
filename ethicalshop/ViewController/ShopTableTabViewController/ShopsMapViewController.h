//
//  ShopsMapViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ShopsMapViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate>
{
	CLLocationManager	*locationManager;
	CLLocation *startPoint;		
    NSArray *resultArray;
    NSMutableArray *shopLocations;
    MKMapView *myMapView;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startPoint;
@property (nonatomic, retain) NSArray *resultArray;
@property (nonatomic, retain) NSMutableArray *shopLocations;
@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@end
