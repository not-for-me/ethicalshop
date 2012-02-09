//
//  CollectionViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController
{
    UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (void)layoutScrollImages;
@end
