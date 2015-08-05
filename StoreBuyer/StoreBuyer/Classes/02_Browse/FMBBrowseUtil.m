//
//  FMBBrowseUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBBrowseUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBUserSetting.h"

@implementation FMBBrowseUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBBrowseUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance inViewModeGrid:(int)viewMode forProduct:(PFObject *)object
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
            
            if (viewMode == FMB_BROWSE_MODE_GRID || viewMode == FMB_BROWSE_MODE_LINE)
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
+ (NSDictionary *)requestParamsForGetProductsInBrowsePageWithFilterParams:(NSInteger)skip
{
    FMBUserSetting *userSetting = [FMBUserSetting sharedInstance];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip]                 forKey:@"skip"];
    [params setObject:[NSNumber numberWithInteger:userSetting.price1]   forKey:@"price1"];
    [params setObject:[NSNumber numberWithInteger:userSetting.price2]   forKey:@"price2"];
    [params setObject:userSetting.searchString                          forKey:@"searchString"];
    [params setObject:userSetting.checkedCategoryIdList                 forKey:@"categoryIdList"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetProductsInBrowsePageWithFilterParams:(NSInteger)skip delegate:(id<FMBBrowseUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetProductsInBrowsePageWithSkip"];
    
    NSDictionary *params = [self requestParamsForGetProductsInBrowsePageWithFilterParams:skip];
    
    [PFCloud callFunctionInBackground:@"getProductsInBrowsePageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetProductsInBrowsePageWithFilterParamsDidRespondWithProducts:object];
     }];
}

@end
