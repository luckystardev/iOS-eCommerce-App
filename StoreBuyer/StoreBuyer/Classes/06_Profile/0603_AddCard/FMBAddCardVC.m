//
//  FMBAddCardVC.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBAddCardVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBProfileUtil.h"
#import "FMBBackgroundSetting.h"

#define DarkGreyColor   RGB(0,0,0,1)
#define RedColor        RGB(253,0,17,1)

#define CHECK_ERROR_MESSAGE @"Please make sure that you have typed all fields in correct format."

@interface FMBAddCardVC ()

@end

@implementation FMBAddCardVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBAddCardVC) return;
    
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
    
    [self setupCreditCardFields];
    
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
    return @[self.txtCardNumber, self.txtExpDate, self.txtCVC, self.txtZip];
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

- (IBAction)onBtnScan:(id)sender
{
    [self printLogWith:@"onBtnScan"];
    
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [scanViewController setUseCardIOLogo:YES];
    
    [scanViewController setCollectCVV:YES];
    [scanViewController setCollectExpiry:YES];
    [scanViewController setCollectPostalCode:YES];
    
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:^{
        //[FBThemeManager setNavigationBarThemeToObject:[scanViewController navigationBar]];
    }];
}

- (IBAction)onBtnSave:(id)sender
{
    [self printLogWith:@"onBtnSave"];
    
    if (![self checkValid])
    {
        [[FMBUtil generalAlertWithTitle:nil message:CHECK_ERROR_MESSAGE delegate:self] show];
        return;
    }
    
    PKCard *card = [self card];
    
    [FMBProfileUtil storeCreditCard:card];
    
    [self.delegate addCardVC:self didSaveCard:card];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Credit Card Functions
- (PKCardNumber *)cardNumber
{
    return [PKCardNumber cardNumberWithString:self.txtCardNumber.text];
}

- (PKCardExpiry *)cardExpiry
{
    return [PKCardExpiry cardExpiryWithString:self.txtExpDate.text];
}

- (PKCardCVC *)cardCVC
{
    return [PKCardCVC cardCVCWithString:self.txtCVC.text];
}

- (PKAddressZip*)addressZip
{
    if (isUSAddress)
    {
        return [PKUSAddressZip addressZipWithString:self.txtZip.text];
    }
    else
    {
        return [PKAddressZip addressZipWithString:self.txtZip.text];
    }
}


// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void)setupCreditCardFields
{
    [self printLogWith:@"setupCreditCardFields"];
    
    isUSAddress = YES;
    
    [self setupCardNumberField];
    [self setupCardExpiryField];
    [self setupCardCVCField];
    [self setupCardZipField];
}

- (void)setupCardNumberField
{
    [self printLogWith:@"setupCardNumberField"];
    
    NSString *strPlaceholder = NSLocalizedStringFromTable(@"placeholder.card_number", @"STPaymentLocalizable", nil);
    
    [self.txtCardNumber addObserver];
    self.txtCardNumber.delegate = self;
    self.txtCardNumber.placeholder = strPlaceholder;
    self.txtCardNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.txtCardNumber.textColor = [UIColor whiteColor];
    
    [self.txtCardNumber.layer setMasksToBounds:YES];
}

- (void)setupCardExpiryField
{
    [self printLogWith:@"setupCardExpiryField"];
    
    [self.txtExpDate addObserver];
    self.txtExpDate.delegate = self;
    self.txtExpDate.placeholder = NSLocalizedStringFromTable(@"placeholder.card_expiry", @"STPaymentLocalizable", nil);
    self.txtExpDate.keyboardType = UIKeyboardTypeNumberPad;
    self.txtExpDate.textColor = [UIColor whiteColor];
    
    [self.txtExpDate.layer setMasksToBounds:YES];
}

- (void)setupCardCVCField
{
    [self printLogWith:@"setupCardCVCField"];
    
    [self.txtCVC addObserver];
    self.txtCVC.delegate = self;
    self.txtCVC.placeholder = NSLocalizedStringFromTable(@"placeholder.card_cvc", @"STPaymentLocalizable", nil);
    self.txtCVC.keyboardType = UIKeyboardTypeNumberPad;
    self.txtCVC.textColor = [UIColor whiteColor];
    
    [self.txtCVC.layer setMasksToBounds:YES];
}

- (void)setupCardZipField
{
    [self printLogWith:@"setupCardZipField"];
    
    [self.txtZip addObserver];
    self.txtZip.delegate = self;
    self.txtZip.placeholder = @"12345";NSLocalizedStringFromTable(@"placeholder.card_zip", @"STPaymentLocalizable", nil);
    self.txtZip.keyboardType = UIKeyboardTypeNumberPad;
    self.txtZip.textColor = [UIColor whiteColor];
    
    [self.txtZip.layer setMasksToBounds:YES];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Input Accessory View Functions
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

// -------------------------------------------------------------------------------------------------------------------------
// TextField Delegate
// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:self.txtCardNumber])
    {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:self.txtExpDate])
    {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:self.txtCVC])
    {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:self.txtZip])
    {
        return [self addressZipShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    return YES;
}

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PKTextField *)textField
{
    if (textField == self.txtZip)
        [self.txtCVC becomeFirstResponder];
    else if (textField == self.txtCVC)
        [self.txtExpDate becomeFirstResponder];
    else if (textField == self.txtExpDate)
        [self.txtCardNumber becomeFirstResponder];
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.txtCardNumber.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid])
        return NO;
    
    if (replacementString.length > 0) {
        self.txtCardNumber.text = [cardNumber formattedStringWithTrail];
    } else {
        self.txtCardNumber.text = [cardNumber formattedString];
    }
    
    if ([cardNumber isValid])
    {
        [self textFieldIsValid:self.txtCardNumber];
        [self.txtExpDate becomeFirstResponder];
        
    }
    else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn])
    {
        [self textFieldIsInvalid:self.txtCardNumber withErrors:YES];
    }
    else if (![cardNumber isValidLength])
    {
        [self textFieldIsInvalid:self.txtCardNumber withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.txtExpDate.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0)
    {
        self.txtExpDate.text = [cardExpiry formattedStringWithTrail];
    }
    else
    {
        self.txtExpDate.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid])
    {
        [self textFieldIsValid:self.txtExpDate];
        [self.txtCVC becomeFirstResponder];
        
    }
    else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate])
    {
        [self textFieldIsInvalid:self.txtExpDate withErrors:YES];
    }
    else if (![cardExpiry isValidLength])
    {
        [self textFieldIsInvalid:self.txtExpDate withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.txtCVC.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardCVC *cardCVC = [PKCardCVC cardCVCWithString:resultString];
    PKCardType cardType = [[PKCardNumber cardNumberWithString:self.txtCardNumber.text] cardType];
    
    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]) return NO;
    
    // Strip non-digits
    self.txtCVC.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType])
    {
        [self textFieldIsValid:self.txtCVC];
        [self.txtZip becomeFirstResponder];
    }
    else
    {
        [self textFieldIsInvalid:self.txtCVC withErrors:NO];
    }
    
    return NO;
}

- (BOOL)addressZipShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.txtZip.text stringByReplacingCharactersInRange:range withString:replacementString];
    PKAddressZip *addressZip;
    
    if (isUSAddress)
    {
        addressZip = [PKUSAddressZip addressZipWithString:resultString];
    }
    else
    {
        addressZip = [PKAddressZip addressZipWithString:resultString];
    }
    
    // Restrict length
    if ( ![addressZip isPartiallyValid] ) return NO;
    
    self.txtZip.text = [addressZip string];
    
    if ([addressZip isValid])
    {
        [self textFieldIsValid:self.txtZip];
    }
    else
    {
        [self textFieldIsInvalid:self.txtZip withErrors:NO];
    }
    
    return NO;
}

// -------------------------------------------------------------------------------------------------------------------------
// Validation
// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (BOOL)isValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid] &&
    [self.cardCVC isValidWithType:self.cardNumber.cardType] && [self.addressZip isValid];
}

- (BOOL)checkValid
{
    if ([self isValid])
    {
        [self.view endEditing:YES];
        return YES;
    }
    
    return NO;
}

- (void)textFieldIsValid:(UITextField *)textField
{
    textField.textColor = [UIColor whiteColor];
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors)
    {
        textField.textColor = RedColor;
    }
    else
    {
        textField.textColor = [UIColor whiteColor];
    }
    
    [self checkValid];
}

// -------------------------------------------------------------------------------------------------------------------------
// PKCard Create
// -------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (PKCard *)card
{
    PKCard *card    = [[PKCard alloc] init];
    card.number     = [self.cardNumber string];
    card.cvc        = [self.cardCVC string];
    card.expMonth   = [self.cardExpiry month];
    card.expYear    = [self.cardExpiry year];
    card.addressZip = [self.addressZip string];
    
    return card;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - CardIOPaymentViewControllerDelegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [self printLogWith:@"userDidCancelPaymentViewController"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [self printLogWith:@"userDidProvideCreditCardInfo"];
    
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:info.cardNumber];
    
    self.txtCardNumber.text = [cardNumber formattedString];
    self.txtCVC.text        = info.cvv;
    self.txtZip.text        = info.postalCode;
    self.txtExpDate.text    = [PKCard displayExpiryDateByMonth:info.expiryMonth year:info.expiryYear];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
