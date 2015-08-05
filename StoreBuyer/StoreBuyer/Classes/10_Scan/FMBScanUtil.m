//
//  FMBScanUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBScanUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBUserSetting.h"

@implementation FMBScanUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBScanUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (CGFloat)totalPriceFromProducts:(NSArray *)products
{
    [self printLogWith:@"totalPriceFromProducts"];
    
    CGFloat res = 0.f;
    
    for (PFObject *p in products)
    {
        res += [p[kFMProductPriceKey] floatValue];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetProductByBarcode:(NSString *)barcode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:barcode forKey:@"barcode"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetProductByBarcode:(NSString *)barcode delegate:(id<FMBScanUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetProductsInBrowsePageWithSkip"];
    
    NSDictionary *params = [self requestParamsForGetProductByBarcode:barcode];
    
    [PFCloud callFunctionInBackground:@"getProductByBarcode"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             [delegate requestGetProductByBarcodeDidRespondWithProduct:object];
         }
     }];
}

@end
