//
//  QRCodeScanViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "StackMob.h"
#import "UserData.h"

@interface QRCodeScanViewController : UIViewController
<ZBarReaderDelegate>
{
	UIImageView *resultImage;
    UILabel *qrLabel;
    NSString *resultText;
}


@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UILabel *qrLabel;
@property (nonatomic, retain) NSString *resultText;

- (IBAction) scanButtonTapped;

@end
