//
//  CollectionViewController.m
//  EthicalShop
//
//  Created by Woojin Joe on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollectionViewController.h"

@implementation CollectionViewController

@synthesize scrollView;

const CGFloat kScrollObjHeight	= 367.0;
const CGFloat kScrollObjWidth	= 320.0;
const NSUInteger kNumImages		= 5;

#pragma mark - View Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"이미지 콜렉션";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
	// 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[scrollView setBackgroundColor:[UIColor clearColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	scrollView.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
	NSUInteger i;
	for (i = 1; i <= kNumImages; i++)
	{
		NSString *imageName = [NSString stringWithFormat:@"image%d.jpg", i];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		imageView.tag = i;	// tag our images for later use when we place them in serial fashion
		[scrollView addSubview:imageView];
		[imageView release];
	}
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
	
}

#pragma mark - Scroll View Load

- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews) {
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0) {
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;			
			curXLoc += (kScrollObjWidth);
		}
	}
	// set the content size so it can be scrollable
	[scrollView setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scrollView bounds].size.height)];
}

@end
