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
{
    UITextField *eMailTextField;
    UITextField *passwordTextField;
    UIActivityIndicatorView *spinner;
 
}

@property (retain, nonatomic) IBOutlet UITextField *eMailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


- (IBAction)pressedLogIn:(id)sender;
- (IBAction)pressedSkipLogIn:(id)sender;
- (IBAction)newAccount:(id)sender;
- (IBAction)backgroundTab:(id)sender;


- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
