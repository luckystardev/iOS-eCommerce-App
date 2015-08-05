//
//  FMBSignupVC.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMBBackgroundUtil.h"

@class FMBSignupVC;
// ----------------------------------------------------------------------------------
// FMBSignupVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMBSignupVCDelegate <NSObject>

- (void)signupVCDidCancel;
- (void)signupVCDidCreateAccount;

@end

// ----------------------------------------------------------------------------------
// FMBSignupVC Class
// ----------------------------------------------------------------------------------
@interface FMBSignupVC : UITableViewController<UITextFieldDelegate, FMBBackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMBSignupVCDelegate> delegate;

@property (strong,  nonatomic)  MBProgressHUD   *hud;
@property (strong,  nonatomic)  NSString        *facebookId;
@property (strong,  nonatomic)  NSDictionary    *facebookResult;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end