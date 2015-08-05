//
//  FMBPreviousOrders2Cell.m
//  StoreBuyer
//
//  Created by Matti on 10/20/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBPreviousOrders2Cell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"

@implementation FMBPreviousOrders2Cell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBPreviousOrders2Cell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
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
    
    _labelDate.text             = [FMBUtil stringFromDate:order.createdAt WithFormat:@"MM/dd/yy"];
    _labelNumberOfOrders.text   = [NSString stringWithFormat:@"%ld Items", (unsigned long)[order[kFMOrderProductsKey] count]];
    _labelTotalPrice.text       = [NSString stringWithFormat:@"$%.2f", [order[kFMOrderTotalPriceKey] floatValue]];
}

- (void)initTheme
{
}

@end
