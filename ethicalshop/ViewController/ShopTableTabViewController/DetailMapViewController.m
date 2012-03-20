//
// DetailMapViewController.m
// EthicalShop
//
// Created by 명철 성 on 2/2/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailMapViewController.h"

@implementation DetailMapViewController

@synthesize myMapView;
@synthesize location;
@synthesize shopName;
@synthesize shopAddress;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"상점위치";    
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
           
    MKPointAnnotation *shopAnnotation = [[MKPointAnnotation alloc] init];
    
    CLLocationCoordinate2D center;
    center.latitude = [[self.location objectForKey:@"lat"] doubleValue];
    center.longitude = [[self.location objectForKey:@"lon"] doubleValue];
    
    region.span = span;
    region.center = center;
    [myMapView setRegion:region animated:TRUE];
    [myMapView regionThatFits:region];
    
    shopAnnotation.Title = self.shopName;
    shopAnnotation.subtitle = self.shopAddress;
    shopAnnotation.coordinate = center;
    [self.myMapView addAnnotation:shopAnnotation];
    [shopAnnotation release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMyMapView:nil];
    [self setLocation:nil];
    [self setShopName:nil];
    [self setShopAddress:nil];
}

- (void)dealloc {
    [myMapView release];
    [location release];
    [shopName release];
    [shopAddress release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end