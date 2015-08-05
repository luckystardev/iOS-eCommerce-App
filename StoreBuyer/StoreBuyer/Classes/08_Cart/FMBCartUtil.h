//
//  FMBCartUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// --------------------------------------------------------------------------------------------
// FMBCartUtilDelegate Protocol
// --------------------------------------------------------------------------------------------
@protocol FMBCartUtilDelegate<NSObject>

- (void)requestAddToCartDidRespondSuccessfully;

@end

// --------------------------------------------------------------------------------------------
// FMBCartUtil Class
// --------------------------------------------------------------------------------------------
@interface FMBCartUtil : NSObject

// --------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (CGFloat)subTotalPriceFromCart:(NSArray *)cart;
+ (CGFloat)salesTaxFromCart:(NSArray *)cart;
+ (CGFloat)shippingRateFromObject:(PFObject *)deliveryMethod;
+ (CGFloat)grandTotalPriceFromCart:(NSArray *)cart withDeliveryMethod:(PFObject *)deliveryMethod;

// --------------------------------------------------------------------------------------------
#pragma mark - Request Param Functions
+ (NSArray *)cartRequestParamFromCart:(NSArray *)cart;

// --------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestAddToCart:(PFObject *)product quantity:(NSInteger)quantity delegate:(id<FMBCartUtilDelegate>)delegate;

@end
