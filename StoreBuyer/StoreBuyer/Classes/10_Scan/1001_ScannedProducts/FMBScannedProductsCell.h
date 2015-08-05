//
//  FMBScannedProductsCell.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FMBScannedProductsCell;
// -----------------------------------------------------------------------------------
// FMBScannedProductsCellDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMBScannedProductsCellDelegate <NSObject>

- (void)scannedProductsCellDidClickAddToCart:(FMBScannedProductsCell *)cell;

@end

// -----------------------------------------------------------------------------------
// FMBScannedProductsCell Class
// -----------------------------------------------------------------------------------
@interface FMBScannedProductsCell : UITableViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBScannedProductsCellDelegate> delegate;

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel        *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel        *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel        *labelPostedPeriod;
@property (weak, nonatomic) IBOutlet PFImageView    *imageviewProduct;
@property (weak, nonatomic) IBOutlet UIButton       *btnAddToCart;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;


@end
