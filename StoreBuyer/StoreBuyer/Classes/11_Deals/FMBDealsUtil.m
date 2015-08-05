//
//  FMBDealsUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBDealsUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"

@implementation FMBDealsUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBDealsUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance inViewModeGrid:(BOOL)bViewModeGrid forProduct:(PFObject *)object
{
    PFUser *user = [PFUser currentUser];
    
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
        if (error)
        {
            [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            PFGeoPoint *productLocation = config[kFMConfigLocationKey];
            
            if ([FMBUtil isObjectEmpty:productLocation]) return;
            
            PFGeoPoint *userLocation = user[kFMUserLocationKey];
            
            if ([FMBUtil isObjectEmpty:userLocation]) return;
            
            CGFloat distance = [userLocation distanceInMilesTo:productLocation];
            
            if (bViewModeGrid)
            {
                labelDistance.text = [NSString stringWithFormat:@"%.1fmi", distance];
            }
            else
            {
                labelDistance.text = [NSString stringWithFormat:@"%.1f miles away", distance];
            }
        }
    }];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetProductsInDeals:(NSInteger)skip searchString:(NSString *)searchString
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    [params setObject:searchString                      forKey:@"searchString"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetProductsInDeals:(NSInteger)skip searchString:(NSString *)searchString
                     delegate:(id<FMBDealsUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetProductsInDeals"];
    
    NSDictionary *params = [self requestParamsForGetProductsInDeals:skip searchString:searchString];
    
    [PFCloud callFunctionInBackground:@"getProductsInDeals"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetProductsInDealsDidRespondWithProducts:object];
     }];
}

@end
