//
// ShopTableViewController.h
// EthicalShop
//
// Created by Woojin Joe on 1/31/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "UserData.h"
#import "NetworkReachability.h"

@interface ShopTableViewController : UIViewController
<UIScrollViewDelegate, IconDownloaderDelegate, UISearchBarDelegate>
{
    NSMutableArray *listData;
    NSArray *resultSet;
    NSMutableArray *tableData;
    NSMutableDictionary *imageDownloadsInProgress; // the set of IconDownloader objects for each app
    IBOutlet UITableView *tab;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UISearchBar *searchBar;
}

@property (nonatomic, retain)NSMutableArray *listData;
@property (nonatomic, retain)NSArray *resultSet;
@property (nonatomic, retain)NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain)IBOutlet UITableView *tab;
@property (nonatomic, retain)IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain)IBOutlet UISearchBar *searchBar;

- (void)shopDataLoad;
- (void)pressedMap;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)startIconDownload:(ShopCellInfo *)shopInfo forIndexPath:(NSIndexPath *)indexPath;


@end