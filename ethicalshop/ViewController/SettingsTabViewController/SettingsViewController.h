//
//  SettingsViewController.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "NetworkReachability.h"
#define PRGRAMVERSION 1.0

@interface SettingsViewController : UIViewController
{
    UITableView *settingTable;    
}

@property (retain, nonatomic) IBOutlet UITableView *settingTable;

@end
