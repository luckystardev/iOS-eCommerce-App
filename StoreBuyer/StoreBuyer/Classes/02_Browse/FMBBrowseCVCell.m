//
//  FMBBrowseCVCell.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBBrowseCVCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBrowseUtil.h"
#import "TTTTimeIntervalFormatter.h"
#import "FMBUserSetting.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation FMBBrowseCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBBrowseCVCell) return;
    
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
    
    _textviewTitle.text = product[kFMProductTitleKey];
    _labelTitle.text = product[kFMProductTitleKey];
    _labelPrice.text = [NSString stringWithFormat:@"$%.2f", [product[kFMProductPriceKey] floatValue]];
    
    if ([FMBUtil isObjectEmpty:product[kFMProductShippingRate]] ||
        [product[kFMProductShippingRate] floatValue] == 0.f)
    {
        _labelShippingRate.text = @"FREE";
    }
    else
    {
        _labelShippingRate.text = [NSString stringWithFormat:@"+$%.2f", [product[kFMProductShippingRate] floatValue]];
    }

    _imageviewProduct.image = nil;
    _imageviewProduct.file  = [product[kFMProductImagesKey] objectAtIndex:0];
    [_imageviewProduct loadInBackground];
    
    if (!timeFormatter)
    {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    FMBUserSetting *settings = [FMBUserSetting sharedInstance];
    
    if (settings.browseMode == FMB_BROWSE_MODE_GRID ||
        settings.browseMode == FMB_BROWSE_MODE_LINE)
    {
        _labelPostedPeriod.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt];
    }
    else
    {
        _labelPostedPeriod.text = [NSString stringWithFormat:@"posted: %@",
                                   [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt]];
    }
    
    [FMBBrowseUtil setDistanceLabel:_labelDistance inViewModeGrid:settings.browseMode forProduct:product];
}

- (void)initTheme
{
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnShare:(id)sender
{
    [self printLogWith:@"onBtnShare"];
    
    [self.delegate browseCVCellDidClickShare:self];
}

- (IBAction)onBtnCart:(id)sender
{
    [self printLogWith:@"onBtnCart"];
    
    [self.delegate browseCVCellDidClickCart:self];
}

@end
