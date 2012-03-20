//
//  QRCodeScanViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "StackMob.h"
#import "StackMobCustomSDK.h"
#import "UserData.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface QRCodeScanViewController : UIViewController
<ZBarReaderDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
{
	UIImageView *resultImage;
    UILabel *qrLabel;
    NSString *resultText;
    CLLocationManager	*locationManager;
	CLLocation *startPoint;
}


@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UILabel *qrLabel;
@property (nonatomic, retain) NSString *resultText;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startPoint;

- (IBAction) scanButtonTapped;

@end
