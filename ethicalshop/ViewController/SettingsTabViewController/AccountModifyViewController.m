//
//  AccountModifyViewController.m
//  ethicalshop
//
//  Created by Woojin Joe on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountModifyViewController.h"
#import "StackMob.h"

@implementation AccountModifyViewController

@synthesize modifyInputTextField;
@synthesize spinner;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"닉네임 설정";
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modifyInputTextField.text = [[UserObject sharedUserData] nickName];
    [self.modifyInputTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setModifyInputTextField:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [modifyInputTextField release];
    [spinner release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Methods

- (IBAction)pressedConfirmButton:(id)sender 
{
    
    [UserObject updateNickName:self.modifyInputTextField.text];        
    [UserObject writeUserDataToFile];  
    
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:[[UserObject sharedUserData] nickName], @"nickname", nil];
    [spinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[StackMob stackmob] put:@"user" withId:[[UserObject sharedUserData] eMail] andArguments:args andCallback:^(BOOL success, id result) {
        if (success) {
            [spinner stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [spinner stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 저장하지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    
}

@end
