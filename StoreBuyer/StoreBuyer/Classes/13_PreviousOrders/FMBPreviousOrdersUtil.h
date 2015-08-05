//
//  FMBPreviousOrdersUtil.h
//  StoreBuyer
//
//  Created by Matti on 10/19/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMBPreviousOrdersUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMBPreviousOrdersUtilDelegate<NSObject>

- (void)requestGetPreviousOrdersDidRespondWithOrders:(NSArray *)orders;

@end

// -----------------------------------------------------------------------------------------
// FMBPreviousOrdersUtil Class
// -----------------------------------------------------------------------------------------
@interface FMBPreviousOrdersUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setFirstProductImageFromOrder:(PFObject *)order toImageView:(PFImageView *)imageview;
+ (void)setProductTitlesFromOrder:(PFObject *)order toLabel:(UILabel *)label;
+ (void)setOrderStatusFromOrder:(PFObject *)order toLabel:(UILabel *)label;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetPreviousOrders:(NSInteger)skip searchString:(NSString *)searchString
                     delegate:(id<FMBPreviousOrdersUtilDelegate>)delegate;

@end
