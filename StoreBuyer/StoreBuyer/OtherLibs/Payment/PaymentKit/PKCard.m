//
//  PKCard.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKCard.h"
#import "PKCardNumber.h"
#import "PKCardType.h"
#import "PKCardExpiry.h"

#define CREDIT_CARD_NUMBER_NSCODING_KEY @"number"
#define CREDIT_CARD_YEAR_NSCODING_KEY   @"year"
#define CREDIT_CARD_MONTH_NSCODING_KEY  @"month"
#define CREDIT_CARD_CVC_NSCODING_KEY    @"cvc"
#define CREDIT_CARD_ZIP_NSCODING_KEY    @"zip"

@implementation PKCard

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)last4
{
    if (_number.length >= 4)
    {
        return [_number substringFromIndex:([_number length] - 4)];
    }
    else
    {
        return nil;
    }
}

- (NSString *)displayCardNumber
{
    NSString *res = [NSString stringWithFormat:@"x-%@", [self last4]];
    return res;
}

- (NSString *)displayCardType
{
    NSString *res;
    
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:self.number];
    PKCardType      cardType = [cardNumber cardType];
    
    switch (cardType)
    {
        case PKCardTypeAmex:
            res = @"Amex";
            break;
        case PKCardTypeDinersClub:
            res = @"Diners";
            break;
        case PKCardTypeDiscover:
            res = @"Discover";
            break;
        case PKCardTypeJCB:
            res = @"JCB";
            break;
        case PKCardTypeMasterCard:
            res = @"Mastercard";
            break;
        case PKCardTypeVisa:
            res = @"Visa";
            break;
        default:
            res = @"";
            break;
    }

    return res;
}

- (NSString *)displayExpiryDate
{
    return [PKCard displayExpiryDateByMonth:self.expMonth year:self.expYear];
}

+ (NSString *)displayExpiryDateByMonth:(NSUInteger)month year:(NSUInteger)year
{
    PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:[NSString stringWithFormat:@"%lu/%lu",
                                                                   (unsigned long)month, (unsigned long)year]];
    
    return [cardExpiry formattedString];
}

- (UIImage *)cardTypeImage
{
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:self.number];
    PKCardType cardType = [cardNumber cardType];
    NSString *cardTypeName = @"placeholder";
    
    switch (cardType) {
        case PKCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case PKCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case PKCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case PKCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case PKCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case PKCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }
    
    return [UIImage imageNamed:cardTypeName];
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.number     = [aDecoder decodeObjectForKey:CREDIT_CARD_NUMBER_NSCODING_KEY];
        self.expYear    = [[aDecoder decodeObjectForKey:CREDIT_CARD_YEAR_NSCODING_KEY] integerValue];
        self.expMonth   = [[aDecoder decodeObjectForKey:CREDIT_CARD_MONTH_NSCODING_KEY] integerValue];
        self.cvc        = [aDecoder decodeObjectForKey:CREDIT_CARD_CVC_NSCODING_KEY];
        self.addressZip = [aDecoder decodeObjectForKey:CREDIT_CARD_ZIP_NSCODING_KEY];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.number     forKey:CREDIT_CARD_NUMBER_NSCODING_KEY];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.expYear]
                                         forKey:CREDIT_CARD_YEAR_NSCODING_KEY];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.expMonth]
                                         forKey:CREDIT_CARD_MONTH_NSCODING_KEY];
    [aCoder encodeObject:self.cvc        forKey:CREDIT_CARD_CVC_NSCODING_KEY];
    [aCoder encodeObject:self.addressZip forKey:CREDIT_CARD_ZIP_NSCODING_KEY];
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (NSData *)dataArchived
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (PKCard *)objectUnarchivedFromData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
