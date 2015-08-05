//
//  FMBPreviousOrdersCVCell.m
//  StoreBuyer
//
//  Created by Matti on 10/19/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBPreviousOrdersCVCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBPreviousOrdersUtil.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation FMBPreviousOrdersCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBPreviousOrdersCVCell) return;
    
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
    
    PFObject *order = (PFObject *)data;
    
    [FMBPreviousOrdersUtil setFirstProductImageFromOrder:order toImageView:_imageview];
    [FMBPreviousOrdersUtil setProductTitlesFromOrder:order toLabel:_labelProductTitles];
    [FMBPreviousOrdersUtil setOrderStatusFromOrder:order toLabel:_labelStatus];
    
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%.2f", [order[kFMOrderTotalPriceKey] floatValue]];
    
    if (!timeFormatter)
    {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    if ([_delegate previousOrdersCVCellCheckViewModeGrid])
    {
        _labelOrderedPeriod.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:order.createdAt];
    }
    else
    {
        _labelOrderedPeriod.text = [NSString stringWithFormat:@"ordered: %@",
                                    [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:order.createdAt]];
    }
}

- (void)initTheme
{
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
    _imageview.clipsToBounds = YES;
}

@end
