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
}

@property (retain, nonatomic) IBOutlet UILabel *totalBalloonLabel;
@property (retain, nonatomic) IBOutlet UILabel *IDLabel;
@property (retain, nonatomic) IBOutlet UILabel *myBalloonLabel;
@property NSInteger totalBalloonCount;
@property NSInteger personalBalloonCount;
@property (retain, nonatomic) IBOutlet UIScrollView *rankingScrollView;
@property (retain, nonatomic) IBOutlet UIView *rankingView;

@property (retain, nonatomic) IBOutlet UILabel *firstNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *firstPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *thirdNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *thirdPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *fourthNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *fourthPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *fifthNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *fifthPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *sixthNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *sixthPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *seventhNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *seventhPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *eighthNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *eighthPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *ninthNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *ninthPointLabel;
@property (retain, nonatomic) IBOutlet UILabel *tenthNickNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *tenthPointLabel;



@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

