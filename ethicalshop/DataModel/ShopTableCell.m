//
//  ShopTableCell.m
//  EthicalShop
//
//  Created by Woojin Joe on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopTableCell.h"

@implementation ShopTableCell

@synthesize shopNameLabel;
@synthesize shopContentsLabel;
@synthesize shopCategoryImageView;
@synthesize shopMarkImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
