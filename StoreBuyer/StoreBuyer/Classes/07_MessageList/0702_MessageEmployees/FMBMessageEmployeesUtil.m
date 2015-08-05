//
//  FMBMessageEmployeesUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBMessageEmployeesUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"

@implementation FMBMessageEmployeesUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBMessageEmployeesUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance withUser:(PFUser *)other
{
    PFUser *user = [PFUser currentUser];
    
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
        if (error)
        {
            [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            PFGeoPoint *otherLocation = other[kFMUserLocationKey];
            
            if ([FMBUtil isObjectEmpty:otherLocation]) return;
            
            PFGeoPoint *userLocation = user[kFMUserLocationKey];
            
            if ([FMBUtil isObjectEmpty:userLocation]) return;
            
            CGFloat distance = [userLocation distanceInMilesTo:otherLocation];
            
            labelDistance.text = [NSString stringWithFormat:@"%.1fmi", distance];
        }
    }];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetEmployeesInMessageEmployeesPageWithFilterParams:(NSInteger)skip
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip]                 forKey:@"skip"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetEmployeesInMessageEmployeesPageWithFilterParams:(NSInteger)skip
                                                         delegate:(id<FMBMessageEmployeesUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetEmployeesInMessageEmployeesPageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetEmployeesInMessageEmployeesPageWithFilterParams:skip];
    
    [PFCloud callFunctionInBackground:@"getEmployeesInMessageEmployeesPageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetEmployeesInMessageEmployeesPageWithFilterParamsDidRespondWithEmployees:object];
     }];
}

@end
