//
//  FMBEmployeeMessageUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMBEmployeeMessageUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMBEmployeeMessageUtilDelegate<NSObject>

- (void)requestGetMessagesInEmployeeMessagePageWithFilterParamsDidRespondWithMessages:(NSArray *)messages;

- (void)requestGetLatestMessagesInEmployeeMessagePageWithFilterParamsDidRespondWithMessages:(NSArray *)messages;

@end

// -----------------------------------------------------------------------------------------
// FMBEmployeeMessageUtil Class
// -----------------------------------------------------------------------------------------
@interface FMBEmployeeMessageUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)otherUserObjectIDFromMessage:(PFObject *)message;
+ (NSString *)senderIDFromMessage:(PFObject *)message;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetMessagesInEmployeeMessagePageWithFilterParams:(NSInteger)skip
                                                          other:(PFUser *)other
                                                       delegate:(id<FMBEmployeeMessageUtilDelegate>)delegate;
+ (void)requestGetLatestMessagesInEmployeeMessagePageWithFilterParams:(NSDate *)lastDate
                                                                other:(PFUser *)other
                                                             delegate:(id<FMBEmployeeMessageUtilDelegate>)delegate;

@end
