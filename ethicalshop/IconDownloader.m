//
// IconDownloader.m
// EthicalShop
//
// Created by 명철 성 on 2/3/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IconDownloader.h"
#import "ShopCellInfo.h"

#define kAppIconWidth 100
#define kAppIconHeight 80

@implementation IconDownloader

@synthesize shopInfo;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

- (void)dealloc
{
    [shopInfo release];
    [indexPathInTableView release];
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:shopInfo.photoLink]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kAppIconWidth && image.size.height != kAppIconHeight)
    {
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        self.shopInfo.photoImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        self.shopInfo.photoImage = image;
    }
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
}

@end