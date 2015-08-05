//
//  FMBProfileUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKCard.h"
#import "FMBShippingAddress.h"

@interface FMBProfileUtil : NSObject

// --------------------------------------------------------------------------------------
#pragma mark - App Setting Functions For Credit Card
+ (void)storeCreditCard:(PKCard *)card;
+ (void)deleteCreditCardByIndex:(NSInteger)index;
+ (NSMutableArray *)getCreditCardDataListFromAppSettings;

// --------------------------------------------------------------------------------------
#pragma mark - App Setting Functions For Shipping Addresses
+ (void)storeShippingAddress:(FMBShippingAddress *)shippingAddress;
+ (void)deleteShippingAddressByIndex:(NSInteger)index;
+ (NSMutableArray *)getShippingAddressDataListFromAppSettings;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSMutableArray *)cardList;
+ (NSMutableArray *)shippingAddressList;

@end
