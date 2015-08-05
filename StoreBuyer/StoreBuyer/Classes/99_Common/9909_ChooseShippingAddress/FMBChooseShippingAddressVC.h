//
//  FMBChooseShippingAddressVC.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBShippingAddress.h"
#import "FMBAddShippingAddressVC.h"
#import "FMBBackgroundUtil.h"

@class FMBChooseShippingAddressVC;
// ----------------------------------------------------------------------------------
// FMBChooseShippingAddressVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMBChooseShippingAddressVCDelegate <NSObject>

- (void)chooseShippingAddressVC:(FMBChooseShippingAddressVC *)controller didSelectShippingAddress:(FMBShippingAddress *)shippingAddress;

@end

// ----------------------------------------------------------------------------------
// FMBChooseShippingAddressVC Class
// ----------------------------------------------------------------------------------
@interface FMBChooseShippingAddressVC : UITableViewController<FMBAddShippingAddressVCDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong, 	nonatomic) NSString    *backgroundName;

// ----------------------------------------------------------------------------------
@property (weak,      nonatomic)   id<FMBChooseShippingAddressVCDelegate> delegate;

@end
