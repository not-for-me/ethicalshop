//
// ShopCellInfo.m
// EthicalShop
//
// Created by 명철 성 on 2/3/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopCellInfo.h"

@implementation ShopCellInfo

@synthesize shops_id;
@synthesize photoImage;
@synthesize shop_name;
@synthesize photoLink;
@synthesize summary;
@synthesize shop_type;

- (void)dealloc
{
    [shops_id release];
    [photoImage release];
    [shop_name release];
    [photoLink release];    
    [summary release];

    [super dealloc];
}

@end