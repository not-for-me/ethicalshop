//
//  SignInViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"


@interface SignInViewController : UIViewController
<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *eMailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)pressedSkipLogIn;

- (IBAction)pressedLogIn:(id)sender;
- (IBAction)newAccount:(id)sender;
- (IBAction)backgroundTab:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
