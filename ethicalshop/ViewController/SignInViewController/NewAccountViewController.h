//
//  NewAccountViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface NewAccountViewController : UIViewController
<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *eMailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)pressedSignUp;
- (void)pressedCancle;

@end
