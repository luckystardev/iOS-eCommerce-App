//
//  FMBCardListCVCell.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBCardListCVCell.h"
#import "FMBData.h"
#import "FMBUtil.h"
#import "PKCard.h"

@implementation FMBCardListCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBCardListCVCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data isEditMode:(BOOL)bEdit
{
    [self printLogWith:@"configureCellWithData"];
    
    PKCard *card = (PKCard *)data;
    
    self.labelCardNumber.text = [card displayCardNumber];
    self.labelCardType.text   = [card displayCardType];
    
    [self setEditMode:bEdit];
}

- (void)setEditMode:(BOOL)bEdit
{
    [self printLogWith:@"setEditMode"];
    
    self.btnRemove.hidden = !bEdit;
}

@end
