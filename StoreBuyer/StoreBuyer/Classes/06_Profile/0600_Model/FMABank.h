//
//  FMABank.h
//  StoreBuyer
//
//  Created by Matti on 8/27/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMABank : NSObject<NSCoding>

@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *routingNumber;
@property (nonatomic, copy) NSString *accountNumber;

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankType;

@property (nonatomic, readonly) NSString *last4;
@property (nonatomic, assign)   BOOL     validated;
@property (nonatomic, readonly) NSString *fingerprint;
@property (nonatomic, readonly) NSString *object;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)displayAccountNumber;
- (NSString *)displayTitle;
- (id)initWithAttributeDictionary:(NSDictionary *)attributeDictionary;

// --------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (NSData *)dataArchived;
+ (FMABank *)objectUnarchivedFromData:(NSData *)data;

@end
