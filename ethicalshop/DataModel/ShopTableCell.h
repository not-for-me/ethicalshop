//
//  ShopTableCell.h
//  EthicalShop
//
//  Created by Woojin Joe on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableCell : UITableViewCell
{
    UILabel *shopNameLabel;    
    UILabel *shopContentsLabel;  
    UIImageView *shopCategoryImageView;
    UIImageView *shopMarkImageView;    
}

@property (nonatomic, retain) IBOutlet UILabel *shopNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *shopContentsLabel;  
@property (nonatomic, retain) IBOutlet UIImageView *shopCategoryImageView;
@property (nonatomic, retain) IBOutlet UIImageView *shopMarkImageView;

@end