//
//  AppDelegate.m
//  StoreBuyer
//
//  Created by Matti on 9/5/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "AppDelegate.h"
#import "FMBData.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBConstants.h"
#import "FMBBackgroundSetting.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugAppDelegate) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initApp
{
    [self printLogWith:@"initApp"];
    
    [FMBThemeManager initAppTheme];
    
    // Set up Parse Application ID and Client Key
    [Parse setApplicationId:[FMBUtil parseApplicationID] clientKey:[FMBUtil parseClientKey]];
    
    // Register for remote notifications
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge|
                                                                  UIUserNotificationTypeSound|
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication]
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Integrate Facebook
    [PFFacebookUtils initializeFacebook];

    // Start LocationController
    _coreLocationController          = [[FMBCoreLocationController alloc] init];
    _coreLocationController.delegate = self;
    [_coreLocationController startUpdateLocation];
    
    // Configure backgrounds
    [[FMBBackgroundSetting sharedInstance] configureBlurImages];
    
    [PFImageView class];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Application LifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self printLogWith:@"application: didFinishLaunchingWithOptions"];
    
    [self initApp];
    
    [self setupSceneOnAppLaunch];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self printLogWith:@"applicationWillResignActive"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self printLogWith:@"applicationDidEnterBackground"];
    
    [_coreLocationController stopUptateLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self printLogWith:@"applicationWillEnterForeground"];
    
    [_coreLocationController startUpdateLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self printLogWith:@"applicationDidBecomeActive"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self printLogWith:@"applicationWillTerminate"];
    
    [_coreLocationController stopUptateLocation];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Push Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [self printLogWith:@"application: didRegisterForRemoteNotificationsWithDeviceToken"];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setDeviceTokenFromData:devToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [self printLogWith:@"application: didFailToRegisterForRemoteNotificationsWithError"];
    [self printLogWith:[err localizedDescription]];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [self printLogWith:@"application: didRegisterUserNotificationSettings"];
    
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [self printLogWith:@"application: handleActionWithIdentifier:"];
    
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self printLogWith:@"application didReceiveRemoteNotification"];
    
    if ([userInfo[kFMPushPayloadTypeKey] isEqualToString:kFMPushPayloadTypeM2M])
    {
        if ([FMBUtil isObjectEmpty:_currentMessageVC] ||
            ![[FMBUtil classNameFromObject:_currentMessageVC] isEqualToString:@"FMBEmployeeMessageVC"] ||
            ([[FMBUtil classNameFromObject:_currentMessageVC] isEqualToString:@"FMBEmployeeMessageVC"] &&
             ![[(FMBEmployeeMessageVC *)_currentMessageVC other].objectId isEqualToString:userInfo[kFMPushPayloadFromUserIDKey]]))
        {
            NSString *alertMessage = userInfo[kAPNSAPSKey][kAPNSAlertKey];
            
            [[FMBUtil generalAlertWithTitle:@"" message:alertMessage delegate:self] show];
        }
    }
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - View Controllers Functions
- (void)setupSceneOnAppLaunch
{
    [self printLogWith:@"setupSceneOnAppLaunch"];
    
    if ([PFUser currentUser])
    {
        [self setupSceneOnLoggedIn];
    }
}

- (void)setupSceneOnLoggedIn
{
    [self printLogWith:@"setupSceneOnLoggedIn"];
    
    self.window.rootViewController = self.menuContainerVC;
}

- (void)setupSceneOnLoggedOut
{
    [self printLogWith:@"setupSceneOnLoggedOut"];
    
    self.menuContainerVC = nil;
    
    self.window.rootViewController = [FMBUtil instantiateViewControllerBySBID:SBID_FMBLOGIN_VC];
}

- (void)logOut
{
    [self printLogWith:@"logOut"];
    
    [FMBUserUtil doOnLogout];
    
    [self setupSceneOnLoggedOut];
}

// -----------------------------------------------------------------------------------------------------------------------
// Getter of View Controllers
// -----------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (TWTSideMenuViewController *)menuContainerVC
{
    [self printLogWith:@"menuContainerVC"];
    
    if (!_menuContainerVC)
    {
        _menuContainerVC = [[TWTSideMenuViewController alloc] initWithMenuViewController:[self sideMenuNC]
                                                                      mainViewController:[self browseNC]];
        _menuContainerVC.edgeOffset = (UIOffset) { 160 };
        _menuContainerVC.zoomScale = 1;
        _menuContainerVC.delegate = self;
        [_menuContainerVC setAnimationType:TWTSideMenuAnimationTypeFadeIn];
    }
    
    return _menuContainerVC;
}

- (UINavigationController *)sideMenuNC
{
    if (!_sideMenuNC)
    {
        _sideMenuNC = [FMBUtil instantiateViewControllerBySBID:SBID_FMBSIDEMENU_NC];
        _sideMenuVC = [_sideMenuNC viewControllers][0];
        
        _sideMenuVC.delegate = self;
    }
    return _sideMenuNC;
}

- (UINavigationController *)browseNC
{
    if (!_browseNC)
    {
        _browseNC = [FMBUtil instantiateViewControllerBySBID:SBID_FMBBROWSE_NC];
        _browseVC = [_browseNC viewControllers][0];
    }
    return _browseNC;
}

- (UINavigationController *)profileNC
{
    if (!_profileNC)
    {
        _profileNC = [FMBUtil instantiateViewControllerBySBID:SBID_FMBPROFILE_NC];
        _profileVC = [_profileNC viewControllers][0];
    }
    return _profileNC;
}

- (UINavigationController *)messageListNC
{
    if (!_messageListNC)
    {
        _messageListNC = [FMBUtil instantiateViewControllerBySBID:SBID_FMBMESSAGELIST_NC];
        _messageListVC = [_messageListNC viewControllers][0];
    }
    return _messageListNC;
}

- (UINavigationController *)dealsNC
{
    if (!_dealsNC)
    {
        _dealsNC = [FMBUtil instantiateViewControllerBySBID:SBID_FMBDEALS_NC];
        _dealsVC = [_dealsNC viewControllers][0];
    }
    return _dealsNC;
}

// -----------------------------------------------------------------------------------------------------------------------
// FMBSideMenuVCDelegate
// -----------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void)sideMenuVCDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"sideMenuVCDidSelectRowAtIndexPath"];
    
    if (indexPath.row == 0)
    {
        [self logOut];
        
        return;
    }
    
    UINavigationController *nc;
    if (indexPath.row == 1)
    {
        nc = self.browseNC;
    }
    else if (indexPath.row == 2)
    {
        nc = self.profileNC;
    }
    else if (indexPath.row == 3)
    {
//        nc = self.messageListNC;
        nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBMESSAGEEMPLOYEES_NC];
    }
    else if (indexPath.row == 4)
    {
        UINavigationController *nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBSHOPPINGCART_NC];
        [self.menuContainerVC.mainViewController presentViewController:nc animated:YES completion:^{
//            [self.menuContainerVC closeMenuAnimated:NO completion:nil];
        }];
        return;
    }
    else if (indexPath.row == 5)
    {
        UINavigationController *nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBSCAN_NC];
        [self.menuContainerVC.mainViewController presentViewController:nc animated:YES completion:^{
//            [self.menuContainerVC closeMenuAnimated:NO completion:nil];
        }];
        return;
    }
    else if (indexPath.row == 6)
    {
        nc = self.dealsNC;
    }
    else if (indexPath.row == 7)
    {
        nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBABOUT_NC];;
    }
    else if (indexPath.row == 8)
    {
        nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBPREVIOUSORDERS2_NC];
    }
    else
    {
        nc = self.browseNC;
    }
    
    if (nc != self.menuContainerVC.mainViewController)
    {
        [self.menuContainerVC setMainViewController:nc animated:YES closeMenu:YES];
    }
    else
    {
        [self.menuContainerVC closeMenuAnimated:YES completion:nil];
    }
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBCoreLocationControllerDelegate
- (void)locationUpdateWithGeoPoint:(PFGeoPoint *)geoPoint
{
    [self printLogWith:@"locationUpdateWithGeoPoint"];
    
    [FMBUserUtil updateUserLocationWithGeoPoint:geoPoint];
}

- (void)locationError:(NSError *)error
{
    [self printLogWith:@"locationError"];
    [self printLogWith:[error localizedDescription]];
}

@end
