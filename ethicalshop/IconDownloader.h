//
// IconDownloader.h
// EthicalShop
//
// Created by 명철 성 on 2/3/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class ShopCellInfo;
@class ShopTableViewController;

@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    ShopCellInfo *shopInfo;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) ShopCellInfo *shopInfo;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end


@protocol IconDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end