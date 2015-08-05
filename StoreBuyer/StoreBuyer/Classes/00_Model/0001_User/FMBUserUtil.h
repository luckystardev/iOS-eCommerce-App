//
//  FMBUserUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// --------------------------------------------------------------------------------------
// FMBFacebookUtilDelegate Protocol
// --------------------------------------------------------------------------------------
@protocol FMBFacebookUtilDelegate <NSObject>

@optional

// PFFacebookUtilError
- (void)facebookUtilError:(NSError *)error;

// FacebookRequestMe Functions
- (void)facebookRequestMeError:(NSError *)error;
- (void)facebookRequestMeDidLoadWithResult:(id)result;

// Facebook Link Functions
- (void)facebookLinkDone;
- (void)facebookUnlinkDone;

@end

// --------------------------------------------------------------------------------------
// FMBUserUtil Class
// --------------------------------------------------------------------------------------
@interface FMBUserUtil : NSObject

// --------------------------------------------------------------------------------------
#pragma mark - Functions on Logged-In and Logged-Out
+ (void)doOnLogin;
+ (void)doOnLogout;

// --------------------------------------------------------------------------------------
#pragma mark - Installation Functions
+ (void)connectCurrentUserToInstallation;
+ (void)deconnectCurrentUserFromInstallation;

// --------------------------------------------------------------------------------------
#pragma mark - Location Functions
+ (void)updateUserLocationWithGeoPoint:(PFGeoPoint *)geoPoint;

// --------------------------------------------------------------------------------------
#pragma mark - Facebook Functions
+ (NSArray *)facebookPersmissions;
+ (void)linkFacebookWithDelegate:(id<FMBFacebookUtilDelegate>)delegate;
+ (void)unlinkFacebookWithDelegate:(id<FMBFacebookUtilDelegate>)delegate;
+ (void)startFacebookRequestMeWithDelegate:(id<FMBFacebookUtilDelegate>)delegate;

@end
