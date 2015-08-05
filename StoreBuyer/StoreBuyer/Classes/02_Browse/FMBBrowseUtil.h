//
//  FMBBrowseUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// --------------------------------------------------------------------------------------------
// FMBBrowseUtilDelegate Protocol
// --------------------------------------------------------------------------------------------
@protocol FMBBrowseUtilDelegate<NSObject>

- (void)requestGetProductsInBrowsePageWithFilterParamsDidRespondWithProducts:(NSArray *)products;

@end

// --------------------------------------------------------------------------------------------
// FMBBrowseUtil Class
// --------------------------------------------------------------------------------------------
@interface FMBBrowseUtil : NSObject

// --------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance inViewModeGrid:(int)viewMode forProduct:(PFObject *)object;

// --------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetProductsInBrowsePageWithFilterParams:(NSInteger)skip
                                              delegate:(id<FMBBrowseUtilDelegate>)delegate;

@end
