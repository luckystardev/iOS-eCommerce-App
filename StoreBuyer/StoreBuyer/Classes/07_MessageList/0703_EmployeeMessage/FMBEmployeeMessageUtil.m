//
//  FMBEmployeeMessageUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBEmployeeMessageUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"

@implementation FMBEmployeeMessageUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBEmployeeMessageUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)otherUserObjectIDFromMessage:(PFObject *)message
{
    PFUser *from = message[kFMMessageFromKey], *to = message[kFMMessageToKey];
    PFUser *user = [PFUser currentUser];
    
    if ([from.objectId isEqualToString:user.objectId])
    {
        return to.objectId;
    }
    
    return from.objectId;
}

+ (NSString *)senderIDFromMessage:(PFObject *)message
{
    PFUser *from = message[kFMMessageFromKey];
    
    return from.objectId;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetMessagesInEmployeeMessagePageWithFilterParams:(NSInteger)skip other:(PFUser *)other
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    [params setObject:other.objectId                    forKey:@"other"];
    
    return params;
}

+ (NSDictionary *)requestParamsForGetLatestMessagesInEmployeeMessagePageWithFilterParams:(NSDate *)lastDate other:(PFUser *)other
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:lastDate          forKey:@"lastDate"];
    [params setObject:other.objectId    forKey:@"other"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetMessagesInEmployeeMessagePageWithFilterParams:(NSInteger)skip
                                                          other:(PFUser *)other
                                                       delegate:(id<FMBEmployeeMessageUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetMessagesInEmployeeMessagePageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetMessagesInEmployeeMessagePageWithFilterParams:skip other:other];
    
    [PFCloud callFunctionInBackground:@"getMessagesInEmployeeMessagePageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetMessagesInEmployeeMessagePageWithFilterParamsDidRespondWithMessages:object];
     }];
}

+ (void)requestGetLatestMessagesInEmployeeMessagePageWithFilterParams:(NSDate *)lastDate
                                                                other:(PFUser *)other
                                                             delegate:(id<FMBEmployeeMessageUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetLatestMessagesInEmployeeMessagePageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetLatestMessagesInEmployeeMessagePageWithFilterParams:lastDate other:other];
    
    [PFCloud callFunctionInBackground:@"getLatestMessagesInEmployeeMessagePageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetLatestMessagesInEmployeeMessagePageWithFilterParamsDidRespondWithMessages:object];
     }];
}

@end
