//
// ShopDetailInfoViewController.h
// EthicalShop
//
// Created by Woojin Joe on 1/31/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCellInfo.h"

@interface ShopDetailInfoViewController : UIViewController
{
    NSString *shop_name;
    NSString *photoLink;
    NSString *shops_id;
    NSInteger shop_type;
    NSInteger numImage;
    UIImage *photoImage;
    NSArray *resultArray;
    NSMutableArray *shopPicArray;
    
    UILabel *nameLabel;
    UIImageView *mainPhoto;
    UILabel *address;
    UILabel *number;
    
    UIImageView *basicInfoTab;
    UIImageView *MenuInfoTab;
    UIImageView *DiscountInfoTab;
    UIImageView *shopPicInfoTab;
    UIImageView *pointImg;
    UIImageView *shopCategoryImage;
    
    UIActivityIndicatorView *spinner1;
    
    UILabel *openTime;
    UILabel *closedDate;
    UILabel *budget;
    UIView *basicView;
    UIView *menuView;
    UIView *discountView;
    UIView *shopPicView;
    UIScrollView *shopPicScrollView;
    UITextView *menuInfoTextView;
    UITextView *discountTextVIew;
}


@property (nonatomic, retain) NSString *shop_name;
@property (nonatomic, retain) NSString *photoLink;
@property (nonatomic, retain) NSString *shops_id;
@property (nonatomic) NSInteger shop_type;
@property (nonatomic) NSInteger numImage;
@property (nonatomic, retain) UIImage *photoImage;
@property (nonatomic, retain) NSArray *resultArray;
@property (nonatomic, retain) NSMutableArray *shopPicArray;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *mainPhoto;
@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) IBOutlet UILabel *number;

@property (nonatomic, retain) IBOutlet UIImageView *basicInfoTab;
@property (nonatomic, retain) IBOutlet UIImageView *MenuInfoTab;
@property (nonatomic, retain) IBOutlet UIImageView *DiscountInfoTab;
@property (nonatomic, retain) IBOutlet UIImageView *shopPicInfoTab;
@property (nonatomic, retain) IBOutlet UIImageView *pointImg;
@property (nonatomic, retain) IBOutlet UIImageView *shopCategoryImage;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner1;

@property (nonatomic, retain) IBOutlet UILabel *openTime;
@property (nonatomic, retain) IBOutlet UILabel *closedDate;
@property (nonatomic, retain) IBOutlet UILabel *budget;
@property (nonatomic, retain) IBOutlet UIView *basicView;
@property (nonatomic, retain) IBOutlet UIView *menuView;
@property (nonatomic, retain) IBOutlet UIView *discountView;
@property (nonatomic, retain) IBOutlet UIView *shopPicView;
@property (nonatomic, retain) IBOutlet UIScrollView *shopPicScrollView;
@property (nonatomic, retain) IBOutlet UITextView *menuInfoTextView;
@property (nonatomic, retain) IBOutlet UITextView *discountTextVIew;


- (void)layoutScrollImages;

- (IBAction)pressedBasicBt:(id)sender;
- (IBAction)pressedMenuBt:(id)sender;
- (IBAction)pressedDiscountBt:(id)sender;
- (IBAction)pressedShopPicBt:(id)sender;
- (IBAction)pressedMap;
- (IBAction)pressedCalling;

@end