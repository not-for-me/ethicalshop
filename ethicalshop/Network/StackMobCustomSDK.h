//
//  StackMobCustomSDK.h
//  ethicalshop
//
//  Created by Woojin Joe on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackMob.h"
#import "UserData.h"

@interface StackMobCustomSDK : NSObject

+ (void)checkDailyPointUp:(NSString *)shop_id;
+ (void)checkDailyCheckInUp:(NSString *)shop_id;
@end
