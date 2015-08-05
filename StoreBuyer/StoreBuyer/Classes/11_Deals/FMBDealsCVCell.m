//
//  FMBDealsCVCell.m
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBDealsCVCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBDealsUtil.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation FMBDealsCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBDealsCVCell) return;
    
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
    _imageviewProduct.file = [product[kFMProductImagesKey] objectAtIndex:0];
    [_imageviewProduct loadInBackground];
    
    if (!timeFormatter)
    {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    if ([_delegate dealsCVCellCheckViewModeGrid])
    {
        _labelPostedPeriod.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt];
    }
    else
    {
        _labelPostedPeriod.text = [NSString stringWithFormat:@"posted: %@",
                                   [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt]];
    }
    
    [FMBDealsUtil setDistanceLabel:_labelDistance inViewModeGrid:[_delegate dealsCVCellCheckViewModeGrid] forProduct:product];
}

- (void)initTheme
{
}

@end
