//
//  FMBAddShippingAddressVC.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBBackgroundUtil.h"

@class FMBAddShippingAddressVC, FMBShippingAddress;
// ------------------------------------------------------------------------------------
// FMBAddShippingAddressVCDelegate Protocol
// ------------------------------------------------------------------------------------
@protocol FMBAddShippingAddressVCDelegate <NSObject>

- (void)addShippingAddressVC:(FMBAddShippingAddressVC *)controller didSaveShippingAddress:(FMBShippingAddress *)shippingAddress;

@end

// ------------------------------------------------------------------------------------
// FMBAddShippingAddressVC Class
// ------------------------------------------------------------------------------------
@interface FMBAddShippingAddressVC : UITableViewController<UITextFieldDelegate, FMBBackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong, 	nonatomic) NSString    *backgroundName;

// ------------------------------------------------------------------------------------
@property (weak,    nonatomic)   id<FMBAddShippingAddressVCDelegate> delegate;

// ------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UITextField  *txtName;
@property (weak,    nonatomic) IBOutlet UITextField  *txtStreetAddress;
@property (weak,    nonatomic) IBOutlet UITextField  *txtUnit;
@property (weak,    nonatomic) IBOutlet UITextField  *txtLabel;
@property (weak,    nonatomic) IBOutlet UITextField  *txtCity;
@property (weak,    nonatomic) IBOutlet UITextField  *txtState;
@property (weak,    nonatomic) IBOutlet UITextField  *txtZip;
@property (weak,    nonatomic) IBOutlet UITextField  *txtCountry;
@property (weak,    nonatomic) IBOutlet UITextField  *txtPhoneNumber;
@property (weak,    nonatomic) IBOutlet UITextField  *txtEmail;

@end
