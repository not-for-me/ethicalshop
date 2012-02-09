//
//  UserData.m
//  ethicalshop
//
//  Created by Woojin Joe on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"

@implementation UserData

@synthesize nickName;
@synthesize eMail;
@synthesize password;

- (id)init 
{
    self = [super init];
    NSDictionary *userData = [[NSDictionary alloc] initWithContentsOfFile:[UserData dataFilePath]];
    self.nickName = [userData objectForKey:@"nickname"];
    self.eMail = [userData objectForKey:@"email"];
    self.password = [userData objectForKey:@"password"];   
    [userData release];
    return self;
}

+ (NSString *) dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:USERDATANAME];            
}
@end


@implementation UserObject

static UserData *userData;

+ (UserData *)sharedUserData
{
    if (userData == nil) {        
        userData = [[UserData alloc] init];
    }    
    return userData;  
}

+ (void)updateNickName:(NSString *)nickName 
{
    [[UserObject sharedUserData] setNickName:nickName];
}

+ (void)updateEMail:(NSString *)eMail 
{
    [[UserObject sharedUserData] setEMail:eMail];
}

+ (void)updatePassword:(NSString *)password 
{
    [[UserObject sharedUserData] setPassword:password];
}

+ (void)updateAll:(NSString *)nickName eMail:(NSString *)eMail password:(NSString *)password
{
    [[UserObject sharedUserData] setNickName:nickName];
    [[UserObject sharedUserData] setEMail:eMail];
    [[UserObject sharedUserData] setPassword:password];
}

+ (BOOL)userFileIsIn 
{
    if ( [[NSFileManager defaultManager] fileExistsAtPath:[UserData dataFilePath]] )
        return YES;
    else
        return NO;    
}

+ (void)writeUserDataToFile 
{
    NSDictionary *writeData = [[NSDictionary alloc] initWithObjectsAndKeys:[[UserObject sharedUserData] nickName], @"nickname", [[UserObject sharedUserData] eMail], @"email", [[UserObject sharedUserData] password], @"password", nil];
    [writeData writeToFile:[UserData dataFilePath] atomically:YES]; 
    [writeData release];
}

@end
