//
//  FMBChooseShippingAddressCell.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBChooseShippingAddressCell.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBProfileUtil.h"

@implementation FMBChooseShippingAddressCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBChooseShippingAddressCell) return;
    
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
    
    FMBShippingAddress *addr = (FMBShippingAddress *)data;
    
    self.labelName.text             = addr.name;
    self.labelStreetAddress.text    = addr.streeAddress;
    self.labelUnit.text             = addr.unit;
    self.labelLabel.text            = addr.label;
    self.labelCity.text             = addr.city;
    self.labelZip.text              = addr.zipCode;
    self.labelState.text            = addr.state;
    self.labelCountry.text          = addr.countryCode;
    self.labelPhoneNumber.text      = addr.phoneNumber;
    self.labelEmail.text            = addr.email;
}

- (void)initTheme
{
}

@end
