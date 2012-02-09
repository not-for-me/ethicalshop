//
//  DonationStatusViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DonationStatusViewController.h"
#import "CollectionViewController.h"
#import "StackMob.h"


@implementation DonationStatusViewController

@synthesize totalBalloonLabel;
@synthesize IDLabel;
@synthesize myBalloonLabel;
@synthesize totalBalloonCount;
@synthesize personalBalloonCount;

@synthesize spinner;

@synthesize puzImage1;
@synthesize puzImage2;
@synthesize puzImage3;
@synthesize puzImage4;
@synthesize puzImage5;
@synthesize puzImage6;
@synthesize puzImage7;
@synthesize puzImage8;
@synthesize puzImage9;
@synthesize puzImage10;
@synthesize puzImage11;
@synthesize puzImage12;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"기부현황";
        self.navigationItem.title = @"기부현황";
        self.tabBarItem.image = [UIImage imageNamed:@"ES_all_tabicon_donation"];
        UIBarButtonItem *collectionButton = [[UIBarButtonItem alloc] initWithTitle:@"이미지 콜렉션" style:UIBarButtonItemStylePlain target:self action:@selector(pressedCollection)];
        self.navigationItem.rightBarButtonItem = collectionButton;
        [collectionButton release];
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.totalBalloonLabel setHidden:YES];
    [self.IDLabel setHidden:YES];
    [self.myBalloonLabel setHidden:YES];
    
    self.IDLabel.text = [[UserObject sharedUserData] nickName];
    self.totalBalloonCount = 0;
    if([NetworkReachability connectedToNetwork] && [UserObject userFileIsIn]) {
        [spinner startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    
        [[StackMob stackmob] get:@"shops" withCallback:^(BOOL success, id result) {
            if(success) {
                NSArray *resultSet = (NSArray *)result;
                int i = 0;
                for(NSDictionary *dictionary in resultSet) {                
                    NSDictionary *dic = [resultSet objectAtIndex:i];
                    NSString *countNum = [dic objectForKey:@"count"];
                    self.totalBalloonCount += [countNum intValue];
                    i++;
                }
                
                [[StackMob stackmob] get:[NSString stringWithFormat:@"user/%@",[[UserObject sharedUserData] eMail]] withCallback:^(BOOL success, id result){
                    if(success) {                                
                        NSDictionary *dic = (NSDictionary *) result;
                        NSString *countNum = [dic objectForKey:@"count"];
                        
                        [spinner stopAnimating];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                        self.myBalloonLabel.text = countNum;
                        self.totalBalloonLabel.text = [NSString stringWithFormat:@"%d", self.totalBalloonCount];
                        [self.totalBalloonLabel setHidden:NO];
                        [self.IDLabel setHidden:NO];
                        [self.myBalloonLabel setHidden:NO];
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
    [self setPuzImage1:nil];
    [self setPuzImage2:nil];
    [self setPuzImage3:nil];
    [self setPuzImage4:nil];    
    [self setPuzImage5:nil];
    [self setPuzImage6:nil];
    [self setPuzImage7:nil];
    [self setPuzImage8:nil];
    [self setPuzImage9:nil];
    [self setPuzImage10:nil];
    [self setPuzImage11:nil];
    [self setPuzImage12:nil];
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
    [puzImage1 release];
    [puzImage2 release];
    [puzImage3 release];
    [puzImage4 release];
    [puzImage5 release];
    [puzImage6 release];
    [puzImage7 release];
    [puzImage8 release];
    [puzImage9 release];
    [puzImage10 release];
    [puzImage11 release];
    [puzImage12 release];
    [super dealloc];
}

#pragma mark - Button Methods

- (void)pressedCollection
{
    CollectionViewController *collectionViewController = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    
    [self.navigationController pushViewController:collectionViewController animated:YES];
    
    [collectionViewController release];    
}
@end
