//
//  NoticeViewController.m
//  ethicalshop
//
//  Created by Woojin Joe on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoticeViewController.h"
#import "StackMob.h"
#import "NoticeContentsViewController.h"

@implementation NoticeViewController

@synthesize noticeTitleDic;
@synthesize noticeArray;
@synthesize noticeTable;
@synthesize spinner;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNoticeTable:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [spinner startAnimating];
    StackMobQuery *q = [StackMobQuery query];
    [q orderByField:@"createddate" withDirection:SMOrderDescending];
    [q setSelectionToFields:[NSArray arrayWithObjects:@"createddate", @"title", @"contents",nil]]; 
    [[StackMob stackmob] get:@"notice" withQuery:q andCallback:^(BOOL success, id result) {
        if (success){
            self.noticeArray = [[[NSMutableArray alloc] initWithArray:(NSMutableArray *) result] autorelease];
            [spinner stopAnimating];
            [noticeTable reloadData];
        }
        else {            
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (noticeArray != nil )
        return [self.noticeArray count];
    else
        return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    

        if ( noticeArray != nil && indexPath.row < [self.noticeArray count]) {
            noticeTitleDic = (NSDictionary *) [noticeArray objectAtIndex:indexPath.row];            
              
            cell.textLabel.text = [noticeTitleDic objectForKey:@"title"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.numberOfLines = 2;
            return cell;
        }        
        else
            return cell;
    
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeContentsViewController *detailViewController = [[NoticeContentsViewController alloc] initWithNibName:@"NoticeContentsViewController" bundle:nil];
    noticeTitleDic = (NSDictionary *) [noticeArray objectAtIndex:indexPath.row];           
 
    detailViewController.noticeContets = [noticeTitleDic objectForKey:@"contents"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)dealloc {
    [noticeTable release];
    [spinner release];
    [super dealloc];
}
@end
