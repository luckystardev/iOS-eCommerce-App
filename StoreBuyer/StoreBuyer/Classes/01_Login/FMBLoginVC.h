//
//  FMBLoginVC.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBSignupVC.h"
#import "FMBUserUtil.h"
#import "FMBBackgroundUtil.h"

// ----------------------------------------------------------------------------------
// FMBLoginVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMBLoginVCDelegate <NSObject>

- (void)loginVCDidCancel;
- (void)loginVCDidCreateUserAccount;
- (void)loginVCDidLogin;

@end

// ----------------------------------------------------------------------------------
// FMBLoginVC Class
// ----------------------------------------------------------------------------------
@interface FMBLoginVC : UITableViewController<UITextFieldDelegate, FMBSignupVCDelegate, FMBFacebookUtilDelegate, FMBBackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBLoginVCDelegate> delegate;

@property (strong, nonatomic) MBProgressHUD *hud;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
