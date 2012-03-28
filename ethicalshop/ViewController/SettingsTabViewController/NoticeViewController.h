//
//  NoticeViewController.h
//  ethicalshop
//
//  Created by Woojin Joe on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController
{
    NSMutableArray *noticeArray;
    NSDictionary *noticeTitleDic;
}

@property (nonatomic, retain) NSMutableArray *noticeArray;
@property (nonatomic, retain) NSDictionary *noticeTitleDic;
@property (retain, nonatomic) IBOutlet UITableView *noticeTable;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
