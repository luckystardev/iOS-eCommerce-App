//
//  FMBUserUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBUserUtil.h"
#import "FMBUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBThemeManager.h"
#import "UIImage+Alpha.h"
#import "UIImage+ResizeAdditions.h"

@implementation FMBUserUtil

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBUserUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Functions on Log-in and Log-out
+ (void)doOnLogin
{
    [self printLogWith:@"doOnLogin"];
    
    [FMBUserUtil connectCurrentUserToInstallation];
}

+ (void)doOnLogout
{
    [self printLogWith:@"doOnLogout"];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Logout
    [PFUser logOut];
    
    [self deconnectCurrentUserFromInstallation];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Installation Functions
+ (void)connectCurrentUserToInstallation
{
    [self printLogWith:@"connectCurrentUserToInstallation"];
    
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kFMInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
}

+ (void)deconnectCurrentUserFromInstallation
{
    [self printLogWith:@"deconnectCurrentUserFromInstallation"];
    
    [[PFInstallation currentInstallation] removeObjectForKey:kFMInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Location Functions
+ (void)updateUserLocationWithGeoPoint:(PFGeoPoint *)geoPoint
{
    [self printLogWith:@"updateUserLocationWithGeoPoint"];
    
    if (![PFUser currentUser]) return;
    
    PFUser *user = [PFUser currentUser];
    
    user[kFMUserLocationKey] = geoPoint;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             [self printLogWith:@": User location updated successfully"];
         }
     }];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Facebook Functions
+ (NSArray *)facebookPersmissions
{
    NSArray *permissions = @[@"user_about_me", @"read_friendlists", @"user_birthday", @"email", @"public_profile"];
    //@"email", @"public_profile", @"user_friends", @"user_photos",
    
    return permissions;
}

+ (void)linkFacebookWithDelegate:(id<FMBFacebookUtilDelegate>)delegate
{
    PFUser *user = [PFUser currentUser];
    
    [PFFacebookUtils linkUser:user permissions:[FMBUserUtil facebookPersmissions] block:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [delegate facebookUtilError:error];
         }
         else
         {
             [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
              {
                  if (!error)
                  {
                      // Save facebookId
                      user[kFMUserFacebookIDKey] = result[kFMFacebookResultIDKey];
                      [user saveInBackground];
                      
                      [delegate facebookLinkDone];
                  }
                  else
                  {
                      [delegate facebookRequestMeError:error];
                  }
              }];
         }
     }];
}

+ (void)unlinkFacebookWithDelegate:(id<FMBFacebookUtilDelegate>)delegate
{
    PFUser *user = [PFUser currentUser];
    
    [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [delegate facebookUtilError:error];
         }
         else
         {
             // Remove facebookId
             [user removeObjectForKey:kFMUserFacebookIDKey];
             [user saveInBackground];
             
             [delegate facebookUnlinkDone];
         }
     }];
}

+ (void)startFacebookRequestMeWithDelegate:(id<FMBFacebookUtilDelegate>)delegate
{
    [self printLogWith:@"startFacebookRequestMe"];
    
    // Start facebook request for me
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             [delegate facebookRequestMeDidLoadWithResult:result];
         }
         else
         {
             [delegate facebookRequestMeError:error];
         }
     }];
}

@end
