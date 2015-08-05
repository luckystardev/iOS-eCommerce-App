//
//  FMBChooseCardCell.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBChooseCardCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBProfileUtil.h"
#import "PKCard.h"
#import "PKCardExpiry.h"

@implementation FMBChooseCardCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBChooseCardCell) return;
    
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
    
    PKCard *card = (PKCard *)data;
    
    self.labelCardNumber.text = [card displayCardNumber];
    self.labelExpDate.text    = [card displayExpiryDate];
    self.imageView.image      = [card cardTypeImage];
}

@end
