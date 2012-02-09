//
//  DonationStatusViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "NetworkReachability.h"

@interface DonationStatusViewController : UIViewController
{
    UILabel *totalBalloonLabel;
    UILabel *IDLabel;   
    UILabel *myBalloonLabel;
    NSInteger totalBalloonCount;
    NSInteger personalBalloonCount;
    UIActivityIndicatorView *spinner;
    UIImageView *puzImage1;
    UIImageView *puzImage2;
    UIImageView *puzImage3;
    UIImageView *puzImage4;
    UIImageView *puzImage5;
    UIImageView *puzImage6;
    UIImageView *puzImage7;
    UIImageView *puzImage8;
    UIImageView *puzImage9;
    UIImageView *puzImage10;
    UIImageView *puzImage11;
    UIImageView *puzImage12;
}

@property (retain, nonatomic) IBOutlet UILabel *totalBalloonLabel;
@property (retain, nonatomic) IBOutlet UILabel *IDLabel;
@property (retain, nonatomic) IBOutlet UILabel *myBalloonLabel;
@property NSInteger totalBalloonCount;
@property NSInteger personalBalloonCount;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, retain) IBOutlet UIImageView *puzImage1;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage2;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage3;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage4;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage5;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage6;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage7;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage8;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage9;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage10;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage11;
@property (nonatomic, retain) IBOutlet UIImageView *puzImage12;

- (void)pressedCollection;

@end

