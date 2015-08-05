//
//  FMBCardListCVCell.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBCardListCVCell : UICollectionViewCell

// -------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel    *labelCardType;
@property (weak, nonatomic) IBOutlet UILabel    *labelCardNumber;
@property (weak, nonatomic) IBOutlet UIButton   *btnRemove;

// -------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data isEditMode:(BOOL)bEdit;

@end
