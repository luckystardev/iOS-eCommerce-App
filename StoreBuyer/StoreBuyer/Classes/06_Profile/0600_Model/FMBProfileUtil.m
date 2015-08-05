//
//  FMBProfileUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBProfileUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"

@implementation FMBProfileUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBProfileUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - App Setting Functions For Credit Card
+ (void)storeCreditCard:(PKCard *)card
{
    [self printLogWith:@"storeCreditCard"];
    
    NSMutableArray *cardDataList = [self getCreditCardDataListFromAppSettings];
    
    [cardDataList addObject:[card dataArchived]];
    
    [FMBUtil setAppSettingValue:cardDataList ByKey:APP_SETTING_KEY_CREDIT_CARDS];
}

+ (void)deleteCreditCardByIndex:(NSInteger)index
{
    [self printLogWith:@"deleteCreditCardByIndex"];
    
    NSMutableArray *cardDataList = [self getCreditCardDataListFromAppSettings];
    
    if (index < [cardDataList count])
    {
        [cardDataList removeObjectAtIndex:index];
    }
    
    [FMBUtil setAppSettingValue:cardDataList ByKey:APP_SETTING_KEY_CREDIT_CARDS];
}

+ (NSMutableArray *)getCreditCardDataListFromAppSettings
{
    [self printLogWith:@"getCreditCardDataListFromAppSettings"];
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    if ([FMBUtil checkKeyExistInAppSettings:APP_SETTING_KEY_CREDIT_CARDS])
    {
        [res addObjectsFromArray:[FMBUtil appSettingValueByKey:APP_SETTING_KEY_CREDIT_CARDS]];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - App Setting Functions For Shipping Addresses
+ (void)storeShippingAddress:(FMBShippingAddress *)shippingAddress
{
    NSMutableArray *addrDataList = [self getShippingAddressDataListFromAppSettings];
    
    [addrDataList addObject:[shippingAddress dataArchived]];
    
    [FMBUtil setAppSettingValue:addrDataList ByKey:APP_SETTING_KEY_SHIPPING_ADDRESSES];
}

+ (void)deleteShippingAddressByIndex:(NSInteger)index
{
    [self printLogWith:@"deleteShippingAddressByIndex"];
    
    NSMutableArray *addrDataList = [self getShippingAddressDataListFromAppSettings];
    
    if (index < [addrDataList count])
    {
        [addrDataList removeObjectAtIndex:index];
    }
    
    [FMBUtil setAppSettingValue:addrDataList ByKey:APP_SETTING_KEY_SHIPPING_ADDRESSES];
}

+ (NSMutableArray *)getShippingAddressDataListFromAppSettings
{
    [self printLogWith:@"getShippingAddressDataListFromAppSettings"];
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    if ([FMBUtil checkKeyExistInAppSettings:APP_SETTING_KEY_SHIPPING_ADDRESSES])
    {
        [res addObjectsFromArray:[FMBUtil appSettingValueByKey:APP_SETTING_KEY_SHIPPING_ADDRESSES]];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSMutableArray *)cardList
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [self getCreditCardDataListFromAppSettings];
    
    for (NSData *data in dataList)
    {
        PKCard *card = [PKCard objectUnarchivedFromData:data];
        
        [res addObject:card];
    }
    
    return res;
}

+ (NSMutableArray *)shippingAddressList
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [self getShippingAddressDataListFromAppSettings];
    
    for (NSData *data in dataList)
    {
        FMBShippingAddress *addr = [FMBShippingAddress objectUnarchivedFromData:data];
        
        [res addObject:addr];
    }
    
    return res;
}

@end
