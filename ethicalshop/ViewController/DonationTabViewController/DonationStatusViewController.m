//
//  DonationStatusViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DonationStatusViewController.h"
#import "StackMob.h"
#import "QuartzCore/QuartzCore.h"

@implementation DonationStatusViewController

@synthesize totalBalloonLabel;
@synthesize IDLabel;
@synthesize myBalloonLabel;
@synthesize totalBalloonCount;
@synthesize personalBalloonCount;
@synthesize rankingScrollView;
@synthesize rankingView;
@synthesize firstNickNameLabel;
@synthesize firstPointLabel;
@synthesize secondNickNameLabel;
@synthesize secondPointLabel;
@synthesize thirdNickNameLabel;
@synthesize thirdPointLabel;
@synthesize fourthNickNameLabel;
@synthesize fourthPointLabel;
@synthesize fifthNickNameLabel;
@synthesize fifthPointLabel;
@synthesize sixthNickNameLabel;
@synthesize sixthPointLabel;
@synthesize seventhNickNameLabel;
@synthesize seventhPointLabel;
@synthesize eighthNickNameLabel;
@synthesize eighthPointLabel;
@synthesize ninthNickNameLabel;
@synthesize ninthPointLabel;
@synthesize tenthNickNameLabel;
@synthesize tenthPointLabel;
@synthesize spinner;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"기부현황";
        self.navigationItem.title = @"기부현황";
        self.tabBarItem.image = [UIImage imageNamed:@"ES_all_tabicon_donation"];        
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
    [rankingScrollView setContentSize:CGSizeMake(280,240)];
    // Making shop Image corner rounding
    rankingView.layer.cornerRadius = 8;
    //rankingScrollView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    //rankingScrollView.layer.borderWidth = 1.0f;
    //rankingScrollView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.totalBalloonLabel setHidden:YES];
    [self.IDLabel setHidden:YES];
    [self.myBalloonLabel setHidden:YES];
    [self.firstNickNameLabel setHidden:YES];
    [self.firstPointLabel setHidden:YES];
    [self.secondNickNameLabel setHidden:YES];
    [self.secondPointLabel setHidden:YES];
    [self.thirdNickNameLabel setHidden:YES];
    [self.thirdPointLabel setHidden:YES];
    [self.fourthNickNameLabel setHidden:YES];
    [self.fourthPointLabel setHidden:YES];
    [self.fifthNickNameLabel setHidden:YES];
    [self.fifthPointLabel setHidden:YES];
    [self.sixthNickNameLabel setHidden:YES];
    [self.sixthPointLabel setHidden:YES];
    [self.seventhNickNameLabel setHidden:YES];
    [self.seventhPointLabel setHidden:YES];
    [self.eighthNickNameLabel setHidden:YES];
    [self.eighthPointLabel setHidden:YES];
    [self.ninthNickNameLabel setHidden:YES];
    [self.ninthPointLabel setHidden:YES];
    [self.tenthNickNameLabel setHidden:YES];
    [self.tenthPointLabel setHidden:YES];
    
    self.IDLabel.text = [[UserObject sharedUserData] nickName];
    self.totalBalloonCount = 0;
    if([NetworkReachability connectedToNetwork] && [UserObject userFileIsIn]) {
        [spinner startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    
        
               
        [[StackMob stackmob] get:@"shop_info" withCallback:^(BOOL success, id result) {
            if(success) {
                NSArray *resultSet = (NSArray *)result;
                int i = 0;
                for(NSDictionary *dictionary in resultSet) {                
                    NSDictionary *dic = [resultSet objectAtIndex:i];
                    NSInteger totalPoint = [[dic objectForKey:@"totalpoint"] intValue];
                    self.totalBalloonCount += totalPoint;
                    i++;
                }
                
                [[StackMob stackmob] get:[NSString stringWithFormat:@"user/%@",[[UserObject sharedUserData] eMail]] withCallback:^(BOOL success, id result){
                    if(success) {                                
                        NSDictionary *dic = (NSDictionary *) result;
                        NSInteger totalPoint = [[dic objectForKey:@"totalpoint"] intValue];
                        
                        [spinner stopAnimating];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        self.myBalloonLabel.text = [NSString stringWithFormat:@"%d", totalPoint];
                        self.totalBalloonLabel.text = [NSString stringWithFormat:@"%d", self.totalBalloonCount];
                        [self.totalBalloonLabel setHidden:NO];
                        [self.IDLabel setHidden:NO];
                        [self.myBalloonLabel setHidden:NO];
                        
                        
                        StackMobQuery *q = [StackMobQuery query];
                        [q orderByField:@"totalpoint" withDirection:SMOrderDescending];
                                                
                        // perform the query and handle the results
                        [[StackMob stackmob] get:@"user" withQuery:q andCallback:^(BOOL success, id result) {
                            if (success) {
                                NSArray *resultSet = (NSArray *)result;
                                int i = 0;
                                // cast result to NSArray and process results
                                for(NSDictionary *dictionary in resultSet) {                
                                    NSDictionary *dic = [resultSet objectAtIndex:i];
                                    NSString *nickName = [dic objectForKey:@"nickname"];
                                    NSString *point = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"totalpoint"] intValue]];
                                    switch (i) {
                                        case 0:
                                            firstNickNameLabel.text = nickName;
                                            firstPointLabel.text = point;                                                                                 
                                            break;
                                        case 1:
                                            secondNickNameLabel.text = nickName;
                                            secondPointLabel.text = point;                                                                                 
                                            break;
                                        case 2:
                                            thirdNickNameLabel.text = nickName;
                                            thirdPointLabel.text = point;                                                                                 
                                            break;
                                        case 3:
                                            fourthNickNameLabel.text = nickName;
                                            fourthPointLabel.text = point;                                                                                 
                                            break;
                                        case 4:
                                            fifthNickNameLabel.text = nickName;
                                            fifthPointLabel.text = point;                                                                                 
                                            break;
                                        case 5:
                                            sixthNickNameLabel.text = nickName;
                                            sixthPointLabel.text = point;                                                                                 
                                            break;
                                        case 6:
                                            seventhNickNameLabel.text = nickName;
                                            seventhPointLabel.text = point;                                                                                 
                                            break;
                                        case 7:
                                            eighthNickNameLabel.text = nickName;
                                            eighthPointLabel.text = point;                                                                                 
                                            break;
                                        case 8:
                                            ninthNickNameLabel.text = nickName;
                                            ninthPointLabel.text = point;                                                                                 
                                            break;
                                        case 9:
                                            tenthNickNameLabel.text = nickName;
                                            tenthPointLabel.text = point;                                                                                 
                                            break;
                                            
                                        default:
                                            break;
                                    }
                                    [self.firstNickNameLabel setHidden:NO];
                                    [self.firstPointLabel setHidden:NO];
                                    [self.secondNickNameLabel setHidden:NO];
                                    [self.secondPointLabel setHidden:NO];
                                    [self.thirdNickNameLabel setHidden:NO];
                                    [self.thirdPointLabel setHidden:NO];
                                    [self.fourthNickNameLabel setHidden:NO];
                                    [self.fourthPointLabel setHidden:NO];
                                    [self.fifthNickNameLabel setHidden:NO];
                                    [self.fifthPointLabel setHidden:NO];
                                    [self.sixthNickNameLabel setHidden:NO];
                                    [self.sixthPointLabel setHidden:NO];
                                    [self.seventhNickNameLabel setHidden:NO];
                                    [self.seventhPointLabel setHidden:NO];
                                    [self.eighthNickNameLabel setHidden:NO];
                                    [self.eighthPointLabel setHidden:NO];
                                    [self.ninthNickNameLabel setHidden:NO];
                                    [self.ninthPointLabel setHidden:NO];
                                    [self.tenthNickNameLabel setHidden:NO];
                                    [self.tenthPointLabel setHidden:NO];                                   
                                    i++;
                                }
                            } 
                            else {
                                // cast result to NSError and handle query error
                            }
                        }];                        
                        
                        
                    }
                    else {
                        [spinner stopAnimating];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 불러오지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                }];
            }
            else {
                [spinner stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 불러오지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
        }];
    }
}

- (void)viewDidUnload
{
    [self setTotalBalloonLabel:nil];
    [self setIDLabel:nil];
    [self setMyBalloonLabel:nil];
    [self setSpinner:nil];
    [self setRankingScrollView:nil];
    [self setFirstNickNameLabel:nil];
    [self setFirstPointLabel:nil];
    [self setSecondNickNameLabel:nil];
    [self setSecondPointLabel:nil];
    [self setThirdNickNameLabel:nil];
    [self setThirdPointLabel:nil];
    [self setFourthNickNameLabel:nil];
    [self setFourthPointLabel:nil];
    [self setFifthNickNameLabel:nil];
    [self setFifthPointLabel:nil];
    [self setSixthNickNameLabel:nil];
    [self setSixthPointLabel:nil];
    [self setSeventhNickNameLabel:nil];
    [self setSeventhPointLabel:nil];
    [self setEighthNickNameLabel:nil];
    [self setEighthPointLabel:nil];
    [self setNinthNickNameLabel:nil];
    [self setNinthPointLabel:nil];
    [self setTenthNickNameLabel:nil];
    [self setTenthPointLabel:nil];
    [self setRankingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [totalBalloonLabel release];
    [IDLabel release];
    [myBalloonLabel release];
    [spinner release];
    [rankingScrollView release];
    [firstNickNameLabel release];
    [firstPointLabel release];
    [secondNickNameLabel release];
    [secondPointLabel release];
    [thirdNickNameLabel release];
    [thirdPointLabel release];
    [fourthNickNameLabel release];
    [fourthPointLabel release];
    [fifthNickNameLabel release];
    [fifthPointLabel release];
    [sixthNickNameLabel release];
    [sixthPointLabel release];
    [seventhNickNameLabel release];
    [seventhPointLabel release];
    [eighthNickNameLabel release];
    [eighthPointLabel release];
    [ninthNickNameLabel release];
    [ninthPointLabel release];
    [tenthNickNameLabel release];
    [tenthPointLabel release];
    [rankingView release];
    [super dealloc];
}

@end
