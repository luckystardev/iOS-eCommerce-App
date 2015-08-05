//
//  FMBEditProfileVC.h
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBBackgroundUtil.h"

@class FMBEditProfileVC;
// ----------------------------------------------------------------------------------
// FMBEditProfileVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMBEditProfileVCDelegate <NSObject>

- (void)editProfileVCDidSaveSuccessfully;

@end

// ----------------------------------------------------------------------------------
// FMBEditProfileVC Class
// ----------------------------------------------------------------------------------
@interface FMBEditProfileVC : UITableViewController<UITextFieldDelegate, FMBBackgroundUtilDelegate>
{
    UITextField *activeField;
}


// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBEditProfileVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)  MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
