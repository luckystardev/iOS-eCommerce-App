//
//  FMBProductsDetailsVC.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FMBProductDetailsImageListView.h"
#import "WYPopoverController.h"
#import "FMBAddToCartVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBProductsDetailsVC : UITableViewController<FMBAddToCartVCDelegate, WYPopoverControllerDelegate, FMBBackgroundUtilDelegate>

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)  PFObject        *product;

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong, 	nonatomic) NSString    *backgroundName;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)  IBOutlet FMBProductDetailsImageListView *imagelistview;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)  IBOutlet UILabel        *labelTitle;
@property (weak,    nonatomic)  IBOutlet UILabel        *labelCategory;
@property (weak,    nonatomic)  IBOutlet UILabel        *labelColor;
@property (weak,    nonatomic)  IBOutlet UILabel        *labelPrice;
@property (weak,    nonatomic)  IBOutlet UILabel        *labelQuantity;
@property (weak,    nonatomic)  IBOutlet UITextView     *textviewDescription;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) WYPopoverController       *addToCartPO;

@end
