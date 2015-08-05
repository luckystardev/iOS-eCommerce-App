//
//  FMBProfileVC.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FMBCardListView.h"
#import "FMBAddCardVC.h"
#import "FMBShippingAddressListView.h"
#import "FMBAddShippingAddressVC.h"
#import "FMBEditProfileVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBProfileVC : UIViewController<FMBCardListViewDelegate, FMBAddCardVCDelegate, FMBShippingAddressListViewDelegate, FMBAddShippingAddressVCDelegate, FMBEditProfileVCDelegate,FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UIView           *viewBack1;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    PFImageView                 *imageviewAvatar;
@property (weak,    nonatomic)      IBOutlet    UILabel                     *labelName;
@property (weak,    nonatomic)      IBOutlet    FMBCardListView             *cardListView;
@property (weak,    nonatomic)      IBOutlet    FMBShippingAddressListView  *shippingAddressListView;

@end
