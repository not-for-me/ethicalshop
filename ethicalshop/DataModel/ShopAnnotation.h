//
//  ShopAnnotation.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MKAnnotation.h>


@interface ShopAnnotation : NSObject<MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;
	NSString *Title;
	NSString *subTitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *subTitle;

@end
