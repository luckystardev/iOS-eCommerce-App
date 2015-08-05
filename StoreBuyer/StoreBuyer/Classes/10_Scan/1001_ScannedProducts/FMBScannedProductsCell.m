//
//  FMBScannedProductsCell.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBScannedProductsCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBrowseUtil.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation FMBScannedProductsCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBScannedProductsCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)setSelected:(BOOL)selected
{
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data
{
    [self printLogWith:@"configureCellWithData"];
    
    [self initTheme];
    
    PFObject *product = (PFObject *)data;
    
    _labelTitle.text = product[kFMProductTitleKey];
    _labelPrice.text = [NSString stringWithFormat:@"$%.2f", [product[kFMProductPriceKey] floatValue]];
    
    _imageviewProduct.image = nil;
    _imageviewProduct.file = [product[kFMProductImagesKey] objectAtIndex:0];
    [_imageviewProduct loadInBackground];
    
    if (!timeFormatter)
    {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    _labelPostedPeriod.text = [NSString stringWithFormat:@"posted: %@",
                               [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt]];
}

- (void)initTheme
{
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnAddToCart:(id)sender
{
    [self printLogWith:@"onBtnAddToCart"];
    
    [self.delegate scannedProductsCellDidClickAddToCart:self];
}

@end
