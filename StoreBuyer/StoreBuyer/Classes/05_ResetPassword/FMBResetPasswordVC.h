//
//  FMBResetPasswordVC.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMBBackgroundUtil.h"

// ----------------------------------------------------------------------------------
// FMBResetPasswordVC Class
// ----------------------------------------------------------------------------------
@interface FMBResetPasswordVC : UITableViewController<UITextFieldDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)          MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UILabel    *labelEmailContainer;
@property (weak,    nonatomic) IBOutlet UIButton   *btnImageEmail;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UITextField *txtEmail;
@property (weak,    nonatomic) IBOutlet UILabel     *labelMsg;
@property (weak,    nonatomic) IBOutlet UIButton    *btnSendRequest;

@end
