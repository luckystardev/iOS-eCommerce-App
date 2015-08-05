//
//  FMBPreviousOrdersCVCell.h
//  StoreBuyer
//
//  Created by Matti on 10/19/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FMBPreviousOrdersCVCell;
// -----------------------------------------------------------------------------------
// FMATotalOrdersCVCellDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMBPreviousOrdersCVCellDelegate <NSObject>

- (BOOL)previousOrdersCVCellCheckViewModeGrid;

@end

// -----------------------------------------------------------------------------------
// FMBPreviousOrdersCVCell Class
// -----------------------------------------------------------------------------------
@interface FMBPreviousOrdersCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBPreviousOrdersCVCellDelegate> delegate;

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet PFImageView        *imageview;
@property (weak, nonatomic) IBOutlet UILabel            *labelProductTitles;
@property (weak, nonatomic) IBOutlet UILabel            *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel            *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel            *labelOrderedPeriod;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
