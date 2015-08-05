//
//  FMBAddCardVC.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stripe.h"
#import "PKCard.h"
#import "PKCardNumber.h"
#import "PKCardExpiry.h"
#import "PKCardCVC.h"
#import "PKAddressZip.h"
#import "PKUSAddressZip.h"
#import "PKTextField.h"
#import "CardIO.h"
#import "FMBBackgroundUtil.h"

@class FMBAddCardVC;
// ----------------------------------------------------------------------------------
// FMBAddCardVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMBAddCardVCDelegate <NSObject>

- (void)addCardVC:(FMBAddCardVC *)controller didSaveCard:(PKCard *)card;

@end

// ----------------------------------------------------------------------------------
// FBAddCardVC Class
// ----------------------------------------------------------------------------------
@interface FMBAddCardVC : UITableViewController<UITextFieldDelegate, PKTextFieldDelegate, CardIOPaymentViewControllerDelegate, FMBBackgroundUtilDelegate>
{
    UITextField *activeField;
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
    BOOL        isUSAddress;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong, 	nonatomic) NSString    *backgroundName;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)   id<FMBAddCardVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet PKTextField  *txtCardNumber;
@property (weak,    nonatomic) IBOutlet PKTextField  *txtExpDate;
@property (weak,    nonatomic) IBOutlet PKTextField  *txtCVC;
@property (weak,    nonatomic) IBOutlet PKTextField  *txtZip;

@end
