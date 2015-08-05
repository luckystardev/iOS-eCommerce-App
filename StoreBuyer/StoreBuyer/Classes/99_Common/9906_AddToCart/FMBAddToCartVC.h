//
//  FMBAddToCartVC.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBCartUtil.h"
#import <Parse/Parse.h>

@class FMBAddToCartVC;
// ----------------------------------------------------------------------------------------
// FMBAddToCartVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMBAddToCartVCDelegate <NSObject>

- (void)addToCartVCDidClickAddButton;

@end

// ----------------------------------------------------------------------------------------
// FMBAddToCartVC Class
// ----------------------------------------------------------------------------------------
@interface FMBAddToCartVC : UIViewController<FMBCartUtilDelegate, UITextFieldDelegate>

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMBAddToCartVCDelegate> delegate;

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic) PFObject *product;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UILabel        *labelContainer;
@property (weak,    nonatomic) IBOutlet UITextField    *txtQuantity;

@end
