//
//  ShopAnnotation.m
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopAnnotation.h"


@implementation ShopAnnotation

@synthesize coordinate;
@synthesize Title;
@synthesize subTitle;

- (void)dealloc
{
    [Title release];
	[subTitle release];
    [super dealloc];
}

@end

