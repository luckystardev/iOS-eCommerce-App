//
//  FMBPreviousOrdersUtil.m
//  StoreBuyer
//
//  Created by Matti on 10/19/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBPreviousOrdersUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"

@implementation FMBPreviousOrdersUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBPreviousOrdersUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setFirstProductImageFromOrder:(PFObject *)order toImageView:(PFImageView *)imageview
{
    PFObject *p1 = [order[kFMOrderProductsKey] objectAtIndex:0];
    
    imageview.image = nil;
    imageview.file = [p1[kFMProductImagesKey] objectAtIndex:0];
    [imageview loadInBackground];
}

+ (void)setProductTitlesFromOrder:(PFObject *)order toLabel:(UILabel *)label
{
    NSArray *products = order[kFMOrderProductsKey];
    
    NSMutableString *res = [[NSMutableString alloc] init];
    for (PFObject *p in products)
    {
        if ([FMBUtil isStringEmpty:res])
        {
            [res appendString:p[kFMProductTitleKey]];
        }
        else
        {
            [res appendFormat:@", %@", p[kFMProductTitleKey]];
        }
    }
    
    label.text = res;
}

+ (void)setOrderStatusFromOrder:(PFObject *)order toLabel:(UILabel *)label
{
    PFObject *orderStatus = order[kFMOrderStatusKey];
    
    label.text = orderStatus[kFMOrderStatusNameKey];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetPreviousOrders:(NSInteger)skip searchString:(NSString *)searchString
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    [params setObject:searchString                      forKey:@"searchString"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetPreviousOrders:(NSInteger)skip searchString:(NSString *)searchString
                     delegate:(id<FMBPreviousOrdersUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetPreviousOrders"];
    
    NSDictionary *params = [self requestParamsForGetPreviousOrders:skip searchString:searchString];
    
    [PFCloud callFunctionInBackground:@"getPreviousOrders"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetPreviousOrdersDidRespondWithOrders:object];
     }];
}

@end
