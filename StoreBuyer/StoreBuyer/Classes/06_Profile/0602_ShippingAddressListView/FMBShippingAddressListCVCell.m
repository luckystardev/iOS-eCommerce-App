//
//  FMBShippingAddressListCVCell.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBShippingAddressListCVCell.h"
#import "FMBData.h"
#import "FMBUtil.h"
#import "FMBShippingAddress.h"

@implementation FMBShippingAddressListCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBShippingAddressListCVCell) return;
    
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
    
    FMBShippingAddress *addr = (FMBShippingAddress *)data;
    
    _labelStreet.text = [addr streeAddress];
    _labelCityState.text = [NSString stringWithFormat:@"%@, %@", [addr city], [addr state]];
    
    [self setEditMode:bEdit];
}

- (void)setEditMode:(BOOL)bEdit
{
    [self printLogWith:@"setEditMode"];
    
    self.btnRemove.hidden = !bEdit;
}

@end
