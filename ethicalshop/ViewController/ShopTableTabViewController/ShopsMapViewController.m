//
//  ShopsMapViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopsMapViewController.h"
#import "StackMob.h"

@implementation ShopsMapViewController

@synthesize locationManager;
@synthesize startPoint;
@synthesize resultArray;
@synthesize shopLocations;
@synthesize myMapView;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"지도화면";
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	[locationManager startUpdatingLocation];   

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[StackMob stackmob] get:@"shop_info" withCallback:^(BOOL success, id result){
        if(success) {
            self.resultArray = (NSArray *)result;
            for(int i=0; i < [resultArray count]; i++) {
                NSDictionary *dic = [resultArray objectAtIndex:i];
                NSDictionary *locationDic =[[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"location"]];

                	
                MKPointAnnotation *shopAnnotation = [[MKPointAnnotation alloc] init];
                CLLocationCoordinate2D center;
                center.latitude = [[locationDic objectForKey:@"lat"] doubleValue];
                center.longitude = [[locationDic objectForKey:@"lon"] doubleValue];
                                               
                shopAnnotation.Title = [dic objectForKey:@"name"];
                shopAnnotation.subtitle = [dic objectForKey:@"address"];                
                shopAnnotation.coordinate = center;
                [self.myMapView addAnnotation:shopAnnotation];

                [locationDic release];
                [shopAnnotation release];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else
            NSLog(@"Failed");
    }];

    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLocationManager:nil];
    [self setStartPoint:nil];
    [self setResultArray:nil];
    [self setMyMapView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
	[locationManager release];
	[startPoint release];
    [resultArray release];
    [shopLocations release];
    [myMapView release];    
    [super dealloc];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{	
    if (startPoint == nil) {
        self.startPoint = newLocation;
    }
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500);
    [myMapView setRegion:viewRegion animated:YES];
    [locationManager stopUpdatingLocation];
}

@end
