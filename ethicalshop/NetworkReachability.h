//
//  NetworkReachability.h
//  ethicalshop
//
//  Created by Woojin Joe on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface NetworkReachability : NSObject

+ (BOOL) connectedToNetwork;
@end
