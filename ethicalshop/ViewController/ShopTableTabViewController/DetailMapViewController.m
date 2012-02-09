//
// DetailMapViewController.m
// EthicalShop
//
// Created by 명철 성 on 2/2/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailMapViewController.h"
#import "ShopAnnotation.h"

@implementation DetailMapViewController

@synthesize myMapView;
@synthesize location;

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
    NSDictionary *dic = [self.location objectForKey:@"location"];
    NSString *lon = [dic objectForKey:@"lon"];
    NSString *lat = [dic objectForKey:@"lat"];
    
    CLLocationCoordinate2D center;
    center.latitude = [lat doubleValue];
    center.longitude = [lon doubleValue];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    region.span = span;
    region.center = center;
    [myMapView setRegion:region animated:TRUE];
    [myMapView regionThatFits:region];
    
    ShopAnnotation *shopAnnotation = [[ShopAnnotation alloc] init];
    
    shopAnnotation.coordinate = center;
    shopAnnotation.Title = [self.location objectForKey:@"name"];
    shopAnnotation.subTitle = [self.location objectForKey:@"address"];
    [self.myMapView addAnnotation:shopAnnotation];
    [shopAnnotation release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setMyMapView:nil];
    [self setLocation:nil];
}

- (void)dealloc {
    [myMapView release];
    [location release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end