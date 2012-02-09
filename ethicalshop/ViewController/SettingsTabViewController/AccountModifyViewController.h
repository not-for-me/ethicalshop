//
//  AccountModifyViewController.h
//  ethicalshop
//
//  Created by Woojin Joe on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface AccountModifyViewController : UIViewController
{
    UITextField *modifyInputTextField;
}
@property (retain, nonatomic) IBOutlet UITextField *modifyInputTextField;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)pressedConfirmButton:(id)sender;

//-(BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
