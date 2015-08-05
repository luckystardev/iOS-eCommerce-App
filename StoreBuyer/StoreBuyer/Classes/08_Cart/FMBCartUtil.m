//
//  FMBCartUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBCartUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"

@implementation FMBCartUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBCartUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (CGFloat)subTotalPriceFromCart:(NSArray *)cart
{
    [self printLogWith:@"subTotalPriceFromCart"];
    
    CGFloat res = 0.f;
    
    for (NSDictionary *tt in cart)
    {
        int n         = [tt[kFMCartQuantityKey] intValue];
        CGFloat price = [[tt[kFMCartProductKey] objectForKey:kFMProductPriceKey] floatValue];
        
        res = res + n * price;
    }
    
    return res;
}

+ (CGFloat)salesTaxFromCart:(NSArray *)cart
{
    [self printLogWith:@"salesTaxFromCart"];
    
    return [self subTotalPriceFromCart:cart] * 0.024;
}

+ (CGFloat)shippingRateFromObject:(PFObject *)deliveryMethod
{
    if ([FMBUtil isObjectEmpty:deliveryMethod])
    {
        return 0.f;
    }
    return [deliveryMethod[kFMDeliveryMethodRateKey] floatValue];
}

+ (CGFloat)grandTotalPriceFromCart:(NSArray *)cart withDeliveryMethod:(PFObject *)deliveryMethod
{
    [self printLogWith:@"grandTotalPriceFromCart"];
    
    CGFloat shippingRate = [self shippingRateFromObject:deliveryMethod];
    CGFloat grandTotal  = [self subTotalPriceFromCart:cart] + shippingRate + [self salesTaxFromCart:cart];
    
    return grandTotal;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Param Functions
+ (NSArray *)cartRequestParamFromCart:(NSArray *)cart
{
    [self printLogWith:@"cartRequestParamFromCart"];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (id cc in cart)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        PFObject *product = cc[kFMCartProductKey];
        
        [dic setObject:product.objectId         forKey:kFMCartProductKey];
        [dic setObject:cc[kFMCartQuantityKey]   forKey:kFMCartQuantityKey];
        
        [res addObject:dic];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForAddToCart:(PFObject *)product quantity:(NSInteger)quantity
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:product.objectId                      forKey:@"productId"];
    [params setObject:[NSNumber numberWithInteger:quantity] forKey:@"quantity"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestAddToCart:(PFObject *)product quantity:(NSInteger)quantity delegate:(id<FMBCartUtilDelegate>)delegate
{
    [self printLogWith:@"requestAddToCart"];
    
    NSDictionary *params = [self requestParamsForAddToCart:product quantity:quantity];
    
    [PFCloud callFunctionInBackground:@"addToCart"
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
             [delegate requestAddToCartDidRespondSuccessfully];
         }
     }];
}

@end
