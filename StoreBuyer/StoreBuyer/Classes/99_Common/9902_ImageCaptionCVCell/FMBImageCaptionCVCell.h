//
//  FMBImageCaptionCVCell.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBImageCaptionCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel    *labelIconContainer;
@property (weak, nonatomic) IBOutlet UIButton   *btnImage;
@property (weak, nonatomic) IBOutlet UILabel    *labelTitle;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
