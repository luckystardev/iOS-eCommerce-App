//
//  FMBShippingAddress.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMBShippingAddress : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *streeAddress;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipCode;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;

// ----------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (NSData *)dataArchived;
+ (FMBShippingAddress *)objectUnarchivedFromData:(NSData *)data;

// ----------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)formattedText1;

@end
