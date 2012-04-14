//
//  StackMobCustomSDK.m
//  ethicalshop
//
//  Created by Woojin Joe on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StackMobCustomSDK.h"

@implementation StackMobCustomSDK

+ (void)checkDailyPointUp:(NSString *)shop_id
{
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateFormat stringFromDate:[NSDate date]];
    
    StackMobQuery *q = [StackMobQuery query];
    [q field:@"date" mustEqualValue:todayDate];
    [q field:@"shop_id" mustEqualValue:shop_id];
    [q field:@"user" mustEqualValue:[[UserObject sharedUserData] eMail]];
    
    // perform the query and handle the results
    // check whether the point is added or not
    [[StackMob stackmob] get:@"history" withQuery:q andCallback:^(BOOL success, id result) {
        if (success) {
            NSArray *rs = (NSArray *)result;
            if([rs count] == 0) {                
                StackMobQuery *q = [StackMobQuery query];
                [q setSelectionToFields:[NSArray arrayWithObjects:@"point", @"totalpoint", nil]];
                
                [[StackMob stackmob] get:[NSString stringWithFormat:@"user/%@", [[UserObject sharedUserData] eMail]] withQuery:q  andCallback:^(BOOL success, id result){
                    if(success) {                    
                        NSDictionary *dic = (NSDictionary *) result;
                        NSInteger point = [[dic objectForKey:@"point"] intValue]; point++;
                        NSInteger totalPoint = [[dic objectForKey:@"totalpoint"] intValue]; totalPoint++;
                        
                        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:point], @"point", [NSNumber numberWithInteger:totalPoint], @"totalpoint", nil];
                        
                        [[StackMob stackmob] put:@"user" withId:[[UserObject sharedUserData] eMail] andArguments:args andCallback:^(BOOL success, id result) {
                            if (success) {
                                
                          } 
                            else {
                                
                            }
                        }];            
                        
                        NSDictionary *args1 = [NSDictionary dictionaryWithObjectsAndKeys:todayDate, @"date", shop_id, @"shop_id", @"point", @"type", [[UserObject sharedUserData] eMail], @"user",  nil];
                        
                        [[StackMob stackmob] post:@"user" withId:[[UserObject sharedUserData] eMail] andField:@"point_history" andArguments:args1 andCallback:^(BOOL success, id result) {                            
                            if (success) {
                                
                            } 
                            else {
                                
                            }
                        }];
                        
                    }
                    else {
                        
                    }
                }];
                
                
            }
            // Already point was up
            else {
                
            }
            
        }
        
        //Fail to load history data
        else {
            
        }       
    }];
}

+ (void)checkDailyCheckInUp:(NSString *)shop_id
{
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateFormat stringFromDate:[NSDate date]];
    
    StackMobQuery *q = [StackMobQuery query];
    [q field:@"date" mustEqualValue:todayDate];
    [q field:@"shop_id" mustEqualValue:shop_id];
    [q field:@"user" mustEqualValue:[[UserObject sharedUserData] eMail]];
    
    // perform the query and handle the results
    // check whether the point is added or not
    [[StackMob stackmob] get:@"history" withQuery:q andCallback:^(BOOL success, id result) {
        if (success) {
            NSArray *rs = (NSArray *)result;
            
            
            if([rs count] == 0) {                
                StackMobQuery *q = [StackMobQuery query];
                [q setSelectionToFields:[NSArray arrayWithObjects:@"checkin", @"totalpoint", nil]];
                
                [[StackMob stackmob] get:[NSString stringWithFormat:@"user/%@", [[UserObject sharedUserData] eMail]] withQuery:q  andCallback:^(BOOL success, id result){
                    if(success) {                    
                        NSDictionary *dic = (NSDictionary *) result;
                        NSInteger checkin = [[dic objectForKey:@"checkin"] intValue]; checkin++;
                        NSInteger totalPoint = [[dic objectForKey:@"totalpoint"] intValue]; 
                        totalPoint+= 20;
                        
                        NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:checkin], @"checkin", [NSNumber numberWithInteger:totalPoint], @"totalpoint", nil];
                        
                        [[StackMob stackmob] put:@"user" withId:[[UserObject sharedUserData] eMail] andArguments:args andCallback:^(BOOL success, id result) {
                            if (success) {
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"체크인 확인" message:@"방문해 주셔서 감사합니다." delegate:self cancelButtonTitle:@"포인트 20 획득" otherButtonTitles:nil];
                                [alert show];
                                [alert release];                                
                            } 
                            else {
                                
                            }
                        }];            
                        
                        NSDictionary *args1 = [NSDictionary dictionaryWithObjectsAndKeys:todayDate, @"date", shop_id, @"shop_id", @"checkin", @"type", [[UserObject sharedUserData] eMail], @"user", nil];
                        
                        [[StackMob stackmob] post:@"user" withId:[[UserObject sharedUserData] eMail] andField:@"point_history" andArguments:args1 andCallback:^(BOOL success, id result) {                            
                            if (success) {

                            } 
                            else {
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정보 저장 오류" message:@"사용자 정보를 아이폰에 업데이트 하지 못하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                                [alert show];
                                [alert release];
                            }
                        }];
                        
                    }
                    else {
                        
                    }
                }];
                
                
            }
            
            // Already point was up
            else {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"체크인 확인" message:@"이미 체크인 하셨습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            
        }
        
        //Fail to load history data
        else {
            
        }       
    }];
}

@end
