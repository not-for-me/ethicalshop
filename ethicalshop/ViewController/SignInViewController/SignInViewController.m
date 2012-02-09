//
//  SignInViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "NewAccountViewController.h"
#import "StackMob.h"

@implementation SignInViewController

@synthesize eMailTextField;
@synthesize passwordTextField;
@synthesize spinner;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"로그인";
        UIBarButtonItem *skipLogInButton = [[UIBarButtonItem alloc] initWithTitle:@"둘러보기" style:UIBarButtonItemStylePlain target:self action:@selector(pressedSkipLogIn)];
        self.navigationItem.rightBarButtonItem = skipLogInButton;
        
        [skipLogInButton release];                  
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
}

- (void)viewDidUnload
{
    [self setEMailTextField:nil];
    [self setPasswordTextField:nil];
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
    [eMailTextField release];
    [passwordTextField release];
    [spinner release];
    [super dealloc];
}


#pragma mark - Button Methods

- (void)pressedSkipLogIn
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pressedLogIn:(id)sender
{
    if([self.eMailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"아이디와 비밀번호를 입력해주세요." delegate:self    cancelButtonTitle:@"다시 시도" otherButtonTitles:nil];
        [alert show];
        [alert release]; 
    }
    else {
        
        NSString *eMail = self.eMailTextField.text;
        NSString *password = self.passwordTextField.text;
        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:eMail, @"email", password, @"password", nil];         
        [spinner startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[StackMob stackmob] loginWithArguments:args andCallback:^(BOOL success, id result) {
            if (success) {                    
                // Login Succeeded
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 성공" message:@"환영합니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                [[StackMob stackmob] get:[NSString stringWithFormat:@"user/%@",eMail] withCallback:^(BOOL success, id result) {
                    if (success) {
                        NSDictionary *nickNameData = (NSDictionary *) result;
                        NSString *nickName = [nickNameData objectForKey:@"nickname"];                  
                        [UserObject updateAll:nickName eMail:eMail password:password];
                        [UserObject writeUserDataToFile];                        
                        [spinner stopAnimating];
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
                
            } else {
                // Login Failed
                [spinner stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그인 실패" message:@"네트워크 장애로 로그인 할 수 없습니다." delegate:self    cancelButtonTitle:@"다시 시도" otherButtonTitles:nil];
                [spinner stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [alert show];
                [alert release];
            }
        }];
        
    }
    
}

- (IBAction)newAccount:(id)sender 
{
    NewAccountViewController *newAccountViewController = [[NewAccountViewController alloc] initWithNibName:@"NewAccountViewController" bundle:nil];    
    [self.navigationController pushViewController:newAccountViewController animated:YES];
    [newAccountViewController release];    
}


- (IBAction)backgroundTab:(id)sender 
{
    [self.eMailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField == eMailTextField) 
        [passwordTextField becomeFirstResponder]; 
    else if (textField == passwordTextField)
        [passwordTextField resignFirstResponder];  
    return YES;
}

@end
