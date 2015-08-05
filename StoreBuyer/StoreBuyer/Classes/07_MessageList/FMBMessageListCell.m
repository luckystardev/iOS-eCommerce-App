//
//  FMBMessageListCell.m
//  StoreBuyer
//
//  Created by Matti on 9/8/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBMessageListCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"

@implementation FMBMessageListCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBMessageListCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
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
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [FMBThemeManager makeCircleWithView:_imageviewManager
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
    
    [FMBThemeManager setBorderToView:_imageviewItem
                               width:COMMON_WIDTH_FOR_CIRCLE_BORDER
                               Color:[UIColor whiteColor]];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
