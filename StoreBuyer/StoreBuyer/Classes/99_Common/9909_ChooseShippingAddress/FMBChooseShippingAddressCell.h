//
//  FMBChooseShippingAddressCell.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBShippingAddress.h"

@interface FMBChooseShippingAddressCell : UITableViewCell

// ---------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIView    *viewBack;

@property (weak, nonatomic) IBOutlet UILabel    *labelName;
@property (weak, nonatomic) IBOutlet UILabel    *labelStreetAddress;
@property (weak, nonatomic) IBOutlet UILabel    *labelUnit;
@property (weak, nonatomic) IBOutlet UILabel    *labelLabel;
@property (weak, nonatomic) IBOutlet UILabel    *labelCity;
@property (weak, nonatomic) IBOutlet UILabel    *labelState;
@property (weak, nonatomic) IBOutlet UILabel    *labelZip;
@property (weak, nonatomic) IBOutlet UILabel    *labelCountry;
@property (weak, nonatomic) IBOutlet UILabel    *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel    *labelEmail;

// ---------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;


@end
