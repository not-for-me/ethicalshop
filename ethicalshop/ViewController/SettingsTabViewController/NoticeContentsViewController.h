//
//  NoticeContentsViewController.h
//  ethicalshop
//
//  Created by Woojin Joe on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeContentsViewController : UIViewController
{
    NSString *noticeContets;
}

@property (nonatomic, retain) NSString *noticeContets;
@property (retain, nonatomic) IBOutlet UITextView *noticeContentsTextView;

@end
