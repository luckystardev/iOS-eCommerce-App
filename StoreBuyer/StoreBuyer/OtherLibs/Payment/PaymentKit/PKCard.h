//
//  PKCard.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PKCard : NSObject<NSCoding>

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *cvc;
@property (nonatomic, copy) NSString *addressZip;
@property (nonatomic, assign) NSUInteger expMonth;
@property (nonatomic, assign) NSUInteger expYear;

@property (nonatomic, readonly) NSString *last4;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)displayCardNumber;
- (NSString *)displayCardType;
- (NSString *)displayExpiryDate;
+ (NSString *)displayExpiryDateByMonth:(NSUInteger)month year:(NSUInteger)year;
- (UIImage *)cardTypeImage;

// --------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (NSData *)dataArchived;
+ (PKCard *)objectUnarchivedFromData:(NSData *)data;

@end
