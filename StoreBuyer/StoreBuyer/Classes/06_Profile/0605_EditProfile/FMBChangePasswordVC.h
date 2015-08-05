//
//  FMBChangePasswordVC.h
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMBBackgroundUtil.h"

@interface FMBChangePasswordVC : UITableViewController<FMBBackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)          MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UILabel    *labelBack1;
@property (weak,    nonatomic) IBOutlet UILabel    *labelBack2;
@property (weak,    nonatomic) IBOutlet UILabel    *labelMessage;
@property (weak,    nonatomic) IBOutlet UIButton   *btnIconImage1;
@property (weak,    nonatomic) IBOutlet UIButton   *btnIconImage2;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak,    nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak,    nonatomic) IBOutlet UIButton    *btnChangePassword;

@end
