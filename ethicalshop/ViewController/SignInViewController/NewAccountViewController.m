//
//  NewAccountViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewAccountViewController.h"
#import "SignInViewController.h"
#import "SettingsViewController.h"
#import "StackMob.h"

@implementation NewAccountViewController

@synthesize nickNameTextField;
@synthesize eMailTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize spinner;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"회원가입";
        
        UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStylePlain target:self action:@selector(pressedCancle)];
        self.navigationItem.LeftBarButtonItem = cancleButton;
        
        UIBarButtonItem *signUpButton = [[UIBarButtonItem alloc] initWithTitle:@"가입" style:UIBarButtonItemStylePlain target:self action:@selector(pressedSignUp)];
        self.navigationItem.rightBarButtonItem = signUpButton;
        [signUpButton release];
        [cancleButton release];
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nickNameTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setNickNameTextField:nil];
    [self setEMailTextField:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPasswordTextField:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [nickNameTextField release];
    [eMailTextField release];
    [passwordTextField release];
    [confirmPasswordTextField release];
    [spinner release];
    [super dealloc];
}

#pragma mark - Button Methods

- (void)pressedSignUp
{    
    if ( [passwordTextField.text isEqualToString:confirmPasswordTextField.text] ) {
        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:nickNameTextField.text, @"nickname", eMailTextField.text, @"email", passwordTextField.text, @"password", nil];
        [spinner startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[StackMob stackmob] post:@"user" withArguments:args andCallback:^(BOOL success, id result) {
            if (success) {
                [UserObject updateAll:nickNameTextField.text eMail:eMailTextField.text password:passwordTextField.text];
                [UserObject writeUserDataToFile];
                [spinner stopAnimating];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"가입 완료" message:@"착한 가게 정상적으로 가입이 완료되었습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;                
                [self dismissModalViewControllerAnimated:YES];
                
            } else {
                [spinner stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정보 저장 오류" message:@"사용자 정보를 아이폰에 업데이트 하지 못하였습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"비밀번호 오류" message:@"비밀번호가 일치하지 않습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        self.passwordTextField.text = @"";
        self.confirmPasswordTextField.text = @"";
        [alert release];
    }   
    
}

- (void)pressedCancle
{
    [self.navigationController popViewControllerAnimated:YES];
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField == nickNameTextField) 
        [eMailTextField becomeFirstResponder]; 
    else if (textField == eMailTextField)
        [passwordTextField becomeFirstResponder];
    else if (textField == passwordTextField)
        [confirmPasswordTextField becomeFirstResponder];
    else if(textField == confirmPasswordTextField)
        [confirmPasswordTextField resignFirstResponder];
    
    return YES;
}
@end
