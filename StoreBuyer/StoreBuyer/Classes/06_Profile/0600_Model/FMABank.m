//
//  FMABank.m
//  StoreBuyer
//
//  Created by Matti on 8/27/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMABank.h"

#define BANK_COUNTRY_CODE_NSCODING_KEY      @"country_code"
#define BANK_ROUTING_NUMBER_NSCODING_KEY    @"routing_number"
#define BANK_ACCOUNT_NUMBER_NSCODING_KEY    @"account_number"
#define BANK_NAME_NSCODING_KEY              @"bank_name"
#define BANK_TYPE_NSCODING_KEY              @"bank_type"

@interface FMABank()
{
    NSString *last4;
    NSString *type;
}

@end

@implementation FMABank

@synthesize  countryCode, routingNumber, accountNumber, bankName, bankType, object, fingerprint, validated;
@dynamic last4;
// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.countryCode = @"US";
        self.bankName    = @"";
        self.bankType    = @"";
    }
    
    return self;
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)last4
{
    if (accountNumber.length >= 4)
    {
        return [accountNumber substringFromIndex:([accountNumber length] - 4)];
    }
    else
    {
        return nil;
    }
}

- (NSString *)displayAccountNumber
{
    NSString *res = [NSString stringWithFormat:@"x-%@", [self last4]];
    return res;
}

- (NSString *)displayTitle
{
    NSString *res = [NSString stringWithFormat:@"%@ x-%@", self.bankName, [self last4]];
    return res;
}

- (id)initWithAttributeDictionary:(NSDictionary *)attributeDictionary
{
    if (self = [self init])
    {
        bankType      = @"";
        routingNumber = @"";
        accountNumber = @"";
        
        countryCode = [attributeDictionary valueForKey:@"country"];
        bankName    = [attributeDictionary valueForKey:@"bankName"];
        last4       = attributeDictionary[@"last4"];
        validated   = [attributeDictionary[@"validated"] boolValue];
        fingerprint = attributeDictionary[@"fingerprint"];
        object      = attributeDictionary[@"object"];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.countryCode    = [aDecoder decodeObjectForKey:BANK_COUNTRY_CODE_NSCODING_KEY];
        self.routingNumber  = [aDecoder decodeObjectForKey:BANK_ROUTING_NUMBER_NSCODING_KEY];
        self.accountNumber  = [aDecoder decodeObjectForKey:BANK_ACCOUNT_NUMBER_NSCODING_KEY];
        self.bankName       = [aDecoder decodeObjectForKey:BANK_NAME_NSCODING_KEY];
        self.bankType       = [aDecoder decodeObjectForKey:BANK_TYPE_NSCODING_KEY];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.countryCode   forKey:BANK_COUNTRY_CODE_NSCODING_KEY];
    [aCoder encodeObject:self.routingNumber forKey:BANK_ROUTING_NUMBER_NSCODING_KEY];
    [aCoder encodeObject:self.accountNumber forKey:BANK_ACCOUNT_NUMBER_NSCODING_KEY];
    [aCoder encodeObject:self.bankName      forKey:BANK_NAME_NSCODING_KEY];
    [aCoder encodeObject:self.bankType      forKey:BANK_TYPE_NSCODING_KEY];
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (NSData *)dataArchived
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (FMABank *)objectUnarchivedFromData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
