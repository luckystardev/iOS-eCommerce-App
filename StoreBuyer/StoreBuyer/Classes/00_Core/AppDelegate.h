//
//  AppDelegate.h
//  StoreBuyer
//
//  Created by Matti on 9/5/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "TWTSideMenuViewController.h"
#import "FMBSideMenuVC.h"
#import "FMBBrowseVC.h"
#import "FMBLoginVC.h"
#import "FMBProfileVC.h"
#import "FMBMessageListVC.h"
#import "FMBDealsVC.h"
#import "FMBCoreLocationController.h"
#import "FMBEmployeeMessageVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TWTSideMenuViewControllerDelegate, FMBSideMenuVCDelegate, FMBCoreLocationControllerDelegate>

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) TWTSideMenuViewController *menuContainerVC;
@property (strong, nonatomic) FMBSideMenuVC             *sideMenuVC;

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) FMBCoreLocationController *coreLocationController;

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) FMBBrowseVC               *browseVC;
@property (strong, nonatomic) FMBProfileVC              *profileVC;
@property (strong, nonatomic) FMBMessageListVC          *messageListVC;
@property (strong, nonatomic) FMBDealsVC                *dealsVC;

@property (strong, nonatomic) UINavigationController    *sideMenuNC;
@property (strong, nonatomic) UINavigationController    *browseNC;
@property (strong, nonatomic) UINavigationController    *profileNC;
@property (strong, nonatomic) UINavigationController    *messageListNC;
@property (strong, nonatomic) UINavigationController    *dealsNC;

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) id currentMessageVC;

// -------------------------------------------------------------------------------------------
#pragma mark - View Controllers Functions
- (void)setupSceneOnLoggedIn;
- (void)logOut;


@end

