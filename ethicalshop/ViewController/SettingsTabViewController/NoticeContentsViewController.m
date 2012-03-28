//
//  NoticeContentsViewController.m
//  ethicalshop
//
//  Created by Woojin Joe on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoticeContentsViewController.h"


@implementation NoticeContentsViewController

@synthesize noticeContentsTextView;
@synthesize noticeContets;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"공지사항";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    noticeContentsTextView.text = self.noticeContets;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNoticeContentsTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [noticeContentsTextView release];
    [super dealloc];
}
@end
