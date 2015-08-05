//
//  FMBShareUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/29/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

// ------------------------------------------------------------------------------
// FMBShareUtilDelegate Protocol
// ------------------------------------------------------------------------------
@protocol FMBShareUtilDelegate<NSObject>

- (void)shareUtilDelegateDidCompleteShare;

@end

// ------------------------------------------------------------------------------
// FMBShareUtil Class
// ------------------------------------------------------------------------------
@interface FMBShareUtil : NSObject

// ------------------------------------------------------------------------------
#pragma mark - Facebook Share Functions
+ (void)shareViaFacebookWithProduct:(PFObject *)product
                           delegate:(id<FMBShareUtilDelegate>)delegate;

// ------------------------------------------------------------------------------
#pragma mark - Email Share Functions
+ (MFMailComposeViewController *)shareViaEmailWithProduct:(PFObject *)product delegate:(id)delgate;

@end
