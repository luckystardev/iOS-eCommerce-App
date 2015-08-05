//
//  FMBDealsCVCell.h
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FMBDealsCVCell;
// -----------------------------------------------------------------------------------
// FMBDealsCVCellDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMBDealsCVCellDelegate <NSObject>

- (BOOL)dealsCVCellCheckViewModeGrid;

@end

// -----------------------------------------------------------------------------------
// FMBDealsCVCell Class
// -----------------------------------------------------------------------------------
@interface FMBDealsCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBDealsCVCellDelegate> delegate;

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel        *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel        *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel        *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel        *labelPostedPeriod;
@property (weak, nonatomic) IBOutlet UILabel        *labelShippingRate;
@property (weak, nonatomic) IBOutlet PFImageView    *imageviewProduct;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
