//
//  FMBAddShippingAddressVC.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBAddShippingAddressVC.h"
#import "FMBConstants.h"
#import "FMBData.h"
#import "FMBThemeManager.h"
#import "FMBUtil.h"
#import "FMBProfileUtil.h"
#import "FMBBackgroundSetting.h"

@interface FMBAddShippingAddressVC ()

@end

@implementation FMBAddShippingAddressVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBAddShippingAddressVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMBThemeManager relayoutTableviewForApp:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    
    [self setupInputAccessoryViews];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];

    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[self.txtName, self.txtStreetAddress, self.txtUnit, self.txtLabel, self.txtCity, self.txtState, self.txtZip,
             self.txtPhoneNumber, self.txtEmail];
}

- (void)setupInputAccessoryViews
{
    [self printLogWith:@"setupInputAccessoryViews"];
    
    [FMBUtil setupInputAccessoryViewWithPrevNextHideButtonsForTextControls:[self textControlsForInputAccessoryView]
                                                                   target:self
                                                selectorForPreviousButton:@selector(onBtnPrevInInputAccessoryView:)
                                                    selectorForNextButton:@selector(onBtnNextInInputAccessoryView:)
                                                    selectorForDoneButton:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnSave:(id)sender
{
    [self printLogWith:@"onBtnSave"];
    
    if (![self doValidationProcess])
    {
        return;
    }
    
    [self doSaveShippingAddress];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TextFields Functions
- (void)onBtnPrevInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnPrevInInputAccessoryView"];
    
    [FMBUtil onBtnPrevInInputAccessoryViewForTextControls:[self textControlsForInputAccessoryView] activeField:activeField];
}

- (void)onBtnNextInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnNextInInputAccessoryView"];
    
    [FMBUtil onBtnNextInInputAccessoryViewForTextControls:[self textControlsForInputAccessoryView] activeField:activeField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    activeField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onBtnSave:nil];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.txtPhoneNumber])
    {
        if (![FMBUtil checkAndFormatPhoneNumberField:textField shouldChangeCharactersInRange:range replacementString:string])
        {
            return NO;
        }
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMBValidationPlaceholderKey:@"Name",
                              kFMBValidationControlKey: self.txtName},
                            
                            @{kFMBValidationPlaceholderKey:@"Street Address",
                              kFMBValidationControlKey: self.txtStreetAddress},
                            
                            @{kFMBValidationPlaceholderKey:@"Unit #",
                              kFMBValidationControlKey: self.txtUnit},
                            
                            @{kFMBValidationPlaceholderKey:@"Label(Apt, Home, Business)",
                              kFMBValidationControlKey: self.txtLabel},
                            
                            @{kFMBValidationPlaceholderKey:@"City",
                              kFMBValidationControlKey: self.txtCity},
                            
                            @{kFMBValidationPlaceholderKey:@"State",
                              kFMBValidationControlKey: self.txtState},
                            
                            @{kFMBValidationPlaceholderKey:@"ZIP Code",
                              kFMBValidationControlKey: self.txtZip},
                            
                            @{kFMBValidationPlaceholderKey:@"Phone Number",
                              kFMBValidationControlKey: self.txtPhoneNumber},
                            
                            @{kFMBValidationPlaceholderKey:@"Email Address",
                              kFMBValidationControlKey: self.txtEmail},];
    
    return [FMBUtil checkAllFieldsExist:infoFields];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if (![self checkAllFieldsExist])
    {
        [[FMBUtil generalAlertWithTitle:nil message:ALERT_MSG_FIELDS_EMPTY delegate:self]show];
        return NO;
    }
    
    if (![FMBUtil checkValidZipCode:self.txtZip.text])
    {
        [[FMBUtil generalAlertWithTitle:nil message:ALERT_MSG_INVALID_ZIPCODE delegate:self] show];
        [self.txtZip becomeFirstResponder];
        
        return NO;
    }
    
    if (![FMBUtil checkValidPhoneNumberLength:self.txtPhoneNumber.text])
    {
        NSString *msg = [NSString stringWithFormat:@"The length of phone number should be %d.", VALID_PHONE_NUMBER_LENGTH];
        [[FMBUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        [self.txtPhoneNumber becomeFirstResponder];
        
        return NO;
    }
    
    if (![FMBUtil checkValidEmail:self.txtEmail.text])
    {
        [[FMBUtil generalAlertWithTitle:nil message:ALERT_MSG_INVALID_EMAIL delegate:self] show];
        [self.txtEmail becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Shipping Address Functions
- (FMBShippingAddress *)shippingAddress
{
    FMBShippingAddress *addr = [[FMBShippingAddress alloc] init];
    
    addr.name           = self.txtName.text;
    addr.streeAddress   = self.txtStreetAddress.text;
    addr.unit           = self.txtUnit.text;
    addr.label          = self.txtLabel.text;
    addr.city           = self.txtCity.text;
    addr.state          = self.txtState.text;
    addr.zipCode        = self.txtZip.text;
    addr.countryCode    = self.txtCountry.text;
    addr.phoneNumber    = self.txtPhoneNumber.text;
    addr.email          = self.txtEmail.text;
    
    return addr;
}

- (void)doSaveShippingAddress
{
    [self printLogWith:@"doSaveShippingAddress"];
    
    FMBShippingAddress *addr = [self shippingAddress];
    
    [FMBProfileUtil storeShippingAddress:addr];
    
    [self.delegate addShippingAddressVC:self didSaveShippingAddress:addr];
}

@end
