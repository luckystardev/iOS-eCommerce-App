//
//  FMBImageCaptionCVCell.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBImageCaptionCVCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBThemeManager.h"
#import "FMBUtil.h"

@implementation FMBImageCaptionCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBImageCaptionCVCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)setSelected:(BOOL)selected
{
    [self printLogWith:@"setSelected"];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data
{
    [self printLogWith:@"configureCellWithData"];
    
    [self initTheme];
    
    self.labelTitle.text = [data objectForKey:kFMBCellDataTitleKey] ? data[kFMBCellDataTitleKey] : @"Title";
    
    if ([data objectForKey:kFMBCellDataImageIconKey])
    {
        [FMBUtil setImageNamed:[data objectForKey:kFMBCellDataImageIconKey] toButton:_btnImage];
    }
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [FMBThemeManager makeCircleWithView:self.btnImage
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
}

@end
