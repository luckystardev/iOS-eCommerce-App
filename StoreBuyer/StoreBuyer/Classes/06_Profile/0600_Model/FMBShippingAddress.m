//
//  FMBShippingAddress.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBShippingAddress.h"

#define SHIPPING_ADDRESS_NAME_NSCODING_KEY              @"name"
#define SHIPPING_ADDRESS_STREET_ADDRESS_NSCODING_KEY    @"street_address"
#define SHIPPING_ADDRESS_UNIT_NSCODING_KEY              @"unit"
#define SHIPPING_ADDRESS_LABEL_NSCODING_KEY             @"label"
#define SHIPPING_ADDRESS_CITY_NSCODING_KEY              @"city"
#define SHIPPING_ADDRESS_STATE_NSCODING_KEY             @"state"
#define SHIPPING_ADDRESS_ZIP_CODE_NSCODING_KEY          @"zip_code"
#define SHIPPING_ADDRESS_COUNTRY_CODE_NSCODING_KEY      @"country_code"
#define SHIPPING_ADDRESS_PHONE_NUMBER_NSCODING_KEY      @"phone_number"
#define SHIPPING_ADDRESS_EMAIL_NSCODING_KEY             @"email"

@implementation FMBShippingAddress

@synthesize name, streeAddress, unit, label, city, state, zipCode, countryCode, phoneNumber, email;

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.name           = @"";
        self.streeAddress   = @"";
        self.unit           = @"";
        self.label          = @"";
        self.city           = @"";
        self.state          = @"";
        self.zipCode        = @"";
        self.countryCode    = @"US";
        self.phoneNumber    = @"";
        self.email          = @"";
    }
    
    return self;
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.name           = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_NAME_NSCODING_KEY];
        self.streeAddress   = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_STREET_ADDRESS_NSCODING_KEY];
        self.unit           = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_UNIT_NSCODING_KEY];
        self.label          = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_LABEL_NSCODING_KEY];
        self.city           = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_CITY_NSCODING_KEY];
        self.state          = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_STATE_NSCODING_KEY];
        self.zipCode        = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_ZIP_CODE_NSCODING_KEY];
        self.countryCode    = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_COUNTRY_CODE_NSCODING_KEY];
        self.phoneNumber    = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_PHONE_NUMBER_NSCODING_KEY];
        self.email          = [aDecoder decodeObjectForKey:SHIPPING_ADDRESS_EMAIL_NSCODING_KEY];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name          forKey:SHIPPING_ADDRESS_NAME_NSCODING_KEY];
    [aCoder encodeObject:self.streeAddress  forKey:SHIPPING_ADDRESS_STREET_ADDRESS_NSCODING_KEY];
    [aCoder encodeObject:self.unit          forKey:SHIPPING_ADDRESS_UNIT_NSCODING_KEY];
    [aCoder encodeObject:self.label         forKey:SHIPPING_ADDRESS_LABEL_NSCODING_KEY];
    [aCoder encodeObject:self.city          forKey:SHIPPING_ADDRESS_CITY_NSCODING_KEY];
    [aCoder encodeObject:self.state         forKey:SHIPPING_ADDRESS_STATE_NSCODING_KEY];
    [aCoder encodeObject:self.zipCode       forKey:SHIPPING_ADDRESS_ZIP_CODE_NSCODING_KEY];
    [aCoder encodeObject:self.countryCode   forKey:SHIPPING_ADDRESS_COUNTRY_CODE_NSCODING_KEY];
    [aCoder encodeObject:self.phoneNumber   forKey:SHIPPING_ADDRESS_PHONE_NUMBER_NSCODING_KEY];
    [aCoder encodeObject:self.email         forKey:SHIPPING_ADDRESS_EMAIL_NSCODING_KEY];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (NSData *)dataArchived
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (FMBShippingAddress *)objectUnarchivedFromData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)formattedText1
{
    NSString *res = [NSString stringWithFormat:@"%@, %@, %@, %@", streeAddress, city, state, zipCode];
    return res;
}

@end
