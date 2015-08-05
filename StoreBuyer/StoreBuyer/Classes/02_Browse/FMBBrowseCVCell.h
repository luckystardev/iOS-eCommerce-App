//
//  FMBBrowseCVCell.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FMBBrowseCVCell;
// -----------------------------------------------------------------------------------
// FMBBrowseCVCellDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMBBrowseCVCellDelegate <NSObject>

- (void)browseCVCellDidClickShare:(FMBBrowseCVCell *)cell;
- (void)browseCVCellDidClickCart:(FMBBrowseCVCell *)cell;

@end

// -----------------------------------------------------------------------------------
// FMBBrowseCVCell Class
// -----------------------------------------------------------------------------------
@interface FMBBrowseCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBBrowseCVCellDelegate> delegate;

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIButton       *btnShare;
@property (weak, nonatomic) IBOutlet UIButton       *btnCart;
@property (weak, nonatomic) IBOutlet UILabel        *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel        *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel        *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel        *labelPostedPeriod;
@property (weak, nonatomic) IBOutlet UILabel        *labelShippingRate;
@property (weak, nonatomic) IBOutlet PFImageView    *imageviewProduct;
@property (weak, nonatomic) IBOutlet UITextView     *textviewTitle;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
