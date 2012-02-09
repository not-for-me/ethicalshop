//
//  AppDelegate.h
//  EthicalShop
//
//  Created by Woojin Joe on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "NetworkReachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *window;
    UITabBarController *tabBarController;    
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end
