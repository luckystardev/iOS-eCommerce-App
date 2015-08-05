//
//  FMBShoppingCartVC.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBCartUtil.h"
#import "PKCard.h"
#import "FMBShippingAddress.h"
#import "FMBShoppingCartProductCell.h"
#import "FMBDeliveryMethodsView.h"
#import "FMBChooseCardVC.h"
#import "FMBChooseShippingAddressVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBShoppingCartVC : UITableViewController<UIAlertViewDelegate, FMBShoppingCartProductCellDelegate, FMBDeliveryMethodsViewDelegate, FMBChooseCardVCDelegate, FMBChooseShippingAddressVCDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD  *hud;

// ----------------------------------------------------------------------------------
@property (nonatomic)               BOOL bDeleteMode;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      PKCard              *pk_card;
@property (strong,  nonatomic)      FMBShippingAddress  *shippingAddress;
@property (strong,  nonatomic)      PFObject            *deliveryMethod;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      FMBDeliveryMethodsView   *deliveryMethodsView;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      UILabel         *labelShippingAddress;
@property (strong,  nonatomic)      UILabel         *labelCardLast4Number;
@property (strong,  nonatomic)      UIImageView     *imageviewCardIcon;
@property (strong,  nonatomic)      UILabel         *labelSubTotal;
@property (strong,  nonatomic)      UILabel         *labelDeliveryName;
@property (strong,  nonatomic)      UILabel         *labelDeliveryRate;
@property (strong,  nonatomic)      UILabel         *labelTax;
@property (strong,  nonatomic)      UILabel         *labelGrandTotal;

@end
