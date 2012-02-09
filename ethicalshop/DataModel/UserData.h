//
//  UserData.h
//  ethicalshop
//
//  Created by Woojin Joe on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USERDATANAME @"userData.plist"

@interface UserData : NSObject
{
    NSString *nickName;
    NSString *eMail;
    NSString *password;
}

@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *eMail;
@property (nonatomic, retain) NSString *password;

+ (NSString *) dataFilePath;
@end

@interface UserObject : NSObject 

+ (UserData *)sharedUserData;
+ (void)updateNickName:(NSString *)nickName;
+ (void)updateEMail:(NSString *)eMail;
+ (void)updatePassword:(NSString *)password;
+ (void)updateAll:(NSString *)nickName eMail:(NSString *)eMail password:(NSString *)password;
+ (BOOL)userFileIsIn;
+ (void)writeUserDataToFile;

@end
