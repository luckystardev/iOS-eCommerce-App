//
//  FMBDeliveryMethodsCVCell.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBDeliveryMethodsCVCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"

#define COLOR_SELECTED          RGBHEX(0x9fff9d, .6f)
#define COLOR_NORMAL            RGBHEX(0xffffff, .3f)

@implementation FMBDeliveryMethodsCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBDeliveryMethodsCVCell) return;
    
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
    
    if (data)
    {
        _labelTitle.text = data[kFMDeliveryMethodNameKey];
    }
}

- (void)initTheme
{
    _labelTitle.backgroundColor = COLOR_NORMAL;
    
    [FMBThemeManager makeCircleWithView:_labelTitle
                            borderColor:nil
                            borderWidth:0.f];
}

- (void)changeColorWithSelected:(BOOL)bSelected
{
    [self printLogWith:@"changeColorWithSelected"];
    
    if (bSelected)
    {
        _labelTitle.backgroundColor = COLOR_SELECTED;
    }
    else
    {
        _labelTitle.backgroundColor = COLOR_NORMAL;
    }
}

@end
