//
// ShopTableViewController.m
// EthicalShop
//
// Created by Woojin Joe on 1/31/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShopTableViewController.h"
#import "ShopTableCell.h"
#import "ShopsMapViewController.h"
#import "ShopDetailInfoViewController.h"
#import "StackMob.h"
#import "StackMobCustomSDK.h"
#import "ShopCellInfo.h"
#import <QuartzCore/QuartzCore.h> 

@implementation ShopTableViewController

@synthesize listData;
@synthesize resultSet;
@synthesize tableData;
@synthesize imageDownloadsInProgress;
@synthesize tab;
@synthesize spinner;
@synthesize searchBar;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"착한가게";
        self.navigationItem.title = @"착한가게";
        self.tabBarItem.image = [UIImage imageNamed:@"ES_all_tabicon_home"];
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(pressedMap)];
        self.navigationItem.rightBarButtonItem = mapButton;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"ES_shopTable_button_map"];
        [mapButton release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( [NetworkReachability connectedToNetwork] )
        [self shopDataLoad];  
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 접속 오류" message:@"네트워크에 연결되어 있지 않아 기능을 다 활용하지 못할 수도 있습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setListData:nil];
    [self setResultSet:nil];    
    [self setTableData:nil];
    [self setImageDownloadsInProgress:nil];
    [self setTab:nil];
    [self setSpinner:nil];
    [self setSearchBar:nil];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( [NetworkReachability connectedToNetwork] )
        [self shopDataLoad];
    
}

- (void)dealloc
{
    [super dealloc];
    [self.listData release];
    [self.resultSet release];
    [self.imageDownloadsInProgress release];
    [self.tableData release];
    [self.tab release];
    [self.spinner release];    
    [self.searchBar release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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
    // Return the number of rows in the section.
    int count = [self.tableData count];
    
    // ff there's no data yet, return enough rows to fill the screen
    if ([NetworkReachability connectedToNetwork] == 0)
        return 1;
    else if (count == 0)
        return 4;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // customize the appearance of table view cells
    //
    static NSString *CellIdentifier = @"LazyTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.tableData count];
    int listCount = [self.listData count];
    
    if(listCount == 0 && [NetworkReachability connectedToNetwork] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"네트워크 접속 필요";
        return cell;
    }
    
    
    if (nodeCount == 0 && indexPath.row == 0) {
        ShopTableCell *cell = (ShopTableCell *) [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopTableCell" owner:self options:nil];
            for( id oneObject in nib) {
                if([oneObject isKindOfClass:[ShopTableCell class]]) {
                    cell = (ShopTableCell *) oneObject;
                }
            }
        }
        
        if(listCount == 0)
            cell.shopNameLabel.text = @"Loading…";
        else
            cell.shopNameLabel.text = @"조건에 맞는 결과 없음";        
        return cell;
    }
    
    ShopTableCell *cell = (ShopTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopTableCell" owner:self options:nil];
        for( id oneObject in nib) {
            if([oneObject isKindOfClass:[ShopTableCell class]]) {
                cell = (ShopTableCell *) oneObject;
            }
        }
    }
    
    // Leave cells empty if there's no data yet
    if (nodeCount > 0) {
        // Set up the cell...
        ShopCellInfo *shopInfo = [self.tableData objectAtIndex:indexPath.row];
        
        cell.shopNameLabel.text = shopInfo.shop_name;
        cell.shopContentsLabel.text = shopInfo.summary;
        switch (shopInfo.shop_type) {
            case 1:
                cell.shopCategoryImageView.image = [UIImage imageNamed:@"ES_shopTable_icon_funnjoy"];
                break;
            case 2:
                cell.shopCategoryImageView.image = [UIImage imageNamed:@"ES_shopTable_icon_food"];
                break;
            case 3:
                cell.shopCategoryImageView.image = [UIImage imageNamed:@"ES_shopTable_icon_etc"];
                break;
            case 4:
                cell.shopCategoryImageView.image = [UIImage imageNamed:@"ES_shopTable_icon_shopping"];
                break;
            case 5:
                cell.shopCategoryImageView.image = [UIImage imageNamed:@"ES_shopTable_icon_etc"];
                break;                
            default:
                break;
        }
        
        // Making shop Image corner rounding
        cell.shopMarkImageView.layer.cornerRadius = 8;
        //cell.shopMarkImageView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
        //cell.shopMarkImageView.layer.borderWidth = 1.0f;
        cell.shopMarkImageView.layer.masksToBounds = YES;
        // Only load cached images; defer new downloads until scrolling ends
        if (!shopInfo.photoImage) {
            if (self.tab.dragging == NO && self.tab.decelerating == NO)
                [self startIconDownload:shopInfo forIndexPath:indexPath];
            
            // if a download is deferred or in progress, return a placeholder image
            cell.shopMarkImageView.image = [UIImage imageNamed:@"ES_shopTable_img_1.jpg"];
        }
        else                      
            cell.shopMarkImageView.image = shopInfo.photoImage;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - Table cell image support

- (void)startIconDownload:(ShopCellInfo *)shopInfo forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.shopInfo = shopInfo;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.tableData count] > 0) {
        NSArray *visiblePaths = [self.tab indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            ShopCellInfo *shopInfo = [self.tableData objectAtIndex:indexPath.row];
            
            if (!shopInfo.photoImage) // avoid the app icon download if the app already has an icon
                [self startIconDownload:shopInfo forIndexPath:indexPath];
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil) {
        ShopTableCell *cell = (ShopTableCell *)[self.tab cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.shopMarkImageView.image = iconDownloader.shopInfo.photoImage;
    }
}

#pragma mark - Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [tableData removeAllObjects];
    [imageDownloadsInProgress removeAllObjects];
    if([searchText isEqualToString:@""]) {
        [tableData addObjectsFromArray:self.listData];
        [self.tab reloadData];
    }
    else {
        for(ShopCellInfo *info in self.listData) {
            NSRange r = [info.shop_name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound)
                [tableData addObject:info];
        }
        [self.tab reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:self.listData];
    [self.tab reloadData];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Network Data Methods

- (void)shopDataLoad
{
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tab.rowHeight = 100;    
    [spinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    StackMobQuery *q = [StackMobQuery query];
    [q orderByField:@"shop_info_id" withDirection:SMOrderDescending];
    [q setSelectionToFields:[NSArray arrayWithObjects:@"shop_info_id", @"name", @"shoppic1", @"summary", @"type", nil]];
    // perform the query and handle the results
    [[StackMob stackmob] get:@"shop_info" withQuery:q andCallback:^(BOOL success, id result) {
        if(success) {
            [spinner stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.resultSet = (NSArray *)result;    
            self.listData = [[[NSMutableArray alloc] init] autorelease]; 
            self.tableData = [[[NSMutableArray alloc] init] autorelease];
            NSUInteger row = 0;
            for(NSDictionary *dictionary in self.resultSet) {                
                NSDictionary *dic = [self.resultSet objectAtIndex:row];
                ShopCellInfo *shopInfo = [[ShopCellInfo alloc] init];
                shopInfo.shops_id = [dic objectForKey:@"shop_info_id"];
                shopInfo.shop_name = [dic objectForKey:@"name"];
                shopInfo.photoLink = [dic objectForKey:@"shoppic1"];
                shopInfo.summary = [dic objectForKey:@"summary"];
                shopInfo.shop_type = [[dic objectForKey:@"type"] intValue];
                [self.listData addObject:shopInfo];
                row++;
                [shopInfo release];
            }
            [self.tableData addObjectsFromArray:self.listData];
            [spinner stopAnimating];
            [self.tab reloadData];
        }
        else {
            if([NetworkReachability connectedToNetwork]) {
                [spinner stopAnimating];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"네트워크 오류" message:@"네트워크 장애로 데이터를 불러오지 못했습니다." delegate:self    cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }];
}

#pragma mark - Button Methods

- (void)pressedMap
{
    [self.searchBar resignFirstResponder];
    ShopsMapViewController *detailViewController = [[ShopsMapViewController alloc] initWithNibName:@"ShopsMapViewController" bundle:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    ShopDetailInfoViewController *detailViewController = [[ShopDetailInfoViewController alloc] initWithNibName:@"ShopDetailInfoViewController" bundle:nil];
    ShopCellInfo *shopInfo = [self.tableData objectAtIndex:indexPath.row];
    detailViewController.shops_id = shopInfo.shops_id;
    detailViewController.shop_name = shopInfo.shop_name;
    detailViewController.photoLink = shopInfo.photoLink;
    detailViewController.shop_type = shopInfo.shop_type;
    if(shopInfo.photoImage != nil)
        detailViewController.photoImage = shopInfo.photoImage;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    [spinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [StackMobCustomSDK checkDailyPointUp:shopInfo.shops_id];
         
    [spinner stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [detailViewController release];
}

@end


