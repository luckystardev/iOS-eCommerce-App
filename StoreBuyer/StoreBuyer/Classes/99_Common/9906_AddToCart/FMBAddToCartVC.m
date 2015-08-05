//
//  FMBAddToCartVC.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBAddToCartVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"

@interface FMBAddToCartVC ()

@end

@implementation FMBAddToCartVC

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBAddToCartVC) return;
    
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

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    
    [self initTextFieldsPlaceholder];
    [self setupInputAccessoryViews];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    self.view.backgroundColor       = [UIColor clearColor];
    _labelContainer.backgroundColor = [UIColor clearColor];
    
    [FMBThemeManager setBorderToView:_labelContainer width:COMMON_WIDTH_FOR_BORDER Color:COMMON_COLOR_FOR_BORDER];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[self.txtQuantity];
}

- (void)setupInputAccessoryViews
{
    [self printLogWith:@"setupInputAccessoryViews"];
    
    [FMBUtil setupInputAccessoryViewWithButtonTitle:@"Done"
                                           selector:@selector(onBtnDoneInInputAccessoryView:)
                                             target:self
                                         forControl:_txtQuantity];
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMBThemeManager setPlaceholder:@"0"   toTextField:_txtQuantity   color:[UIColor whiteColor]];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnAddToCart:(id)sender
{
    [self printLogWith:@"onBtnAddToCart"];
    
    if (![self doValidationProcess]) return;
    
    [FMBCartUtil requestAddToCart:_product quantity:[_txtQuantity.text integerValue] delegate:self];
    
    [_delegate addToCartVCDidClickAddButton];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtQuantity resignFirstResponder];
    
    return YES;
}

- (void)onBtnDoneInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnCancelInInputAccessoryView"];
    
    [_txtQuantity resignFirstResponder];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBCartUtilDelegate
- (void)requestAddToCartDidRespondSuccessfully
{
    [self printLogWith:@"requestAddToCartDidRespondSuccessfully"];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if ([FMBUtil isStringEmpty:_txtQuantity.text])
    {
        [[FMBUtil generalAlertWithTitle:nil message:@"Please input the quantity." delegate:self] show];
        return NO;
    }
    
    if ([_txtQuantity.text integerValue] <= 0)
    {
        [[FMBUtil generalAlertWithTitle:nil message:@"The quantity should be greater than zero." delegate:self] show];
        return NO;
    }
    
    return YES;
}

@end
