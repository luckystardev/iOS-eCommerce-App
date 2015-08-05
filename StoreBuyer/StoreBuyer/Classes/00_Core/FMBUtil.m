//
//  FMBUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBThemeManager.h"
#import "UIImage+ResizeAdditions.h"

@implementation FMBUtil

// --------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

+ (id)infoDictionaryValueByKey:(NSString *)key
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:key];
}

+ (NSString *)classNameFromObject:(id)aObj
{
    NSString *res = [NSString stringWithFormat:@"%@", [aObj class]];
    return res;
}

// --------------------------------------------------------------------------------------------------------------
#pragma mark - App Framework Functions
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

// --------------------------------------------------------------------------------------------------------------
// Parse Application ID and Client Key, Stripe Publishable Key, CardIO App Token
// --------------------------------------------------------------------------------------------------------------
#pragma mark -
+ (NSString *)parseApplicationID
{
    return [self infoDictionaryValueByKey:@"PARSE_APPLICATION_ID"];
}
+ (NSString *)parseClientKey
{
    return [self infoDictionaryValueByKey:@"PARSE_CLIENT_KEY"];
}
+ (NSString *)stripePublishableKey
{
    return [self infoDictionaryValueByKey:@"STRIPE_PUBLISHABLE_KEY"];
}
+ (NSString *)cardIOAppToken
{
    return [self infoDictionaryValueByKey:@"CARDIO_APP_TOKEN"];
}

// --------------------------------------------------------------------------------------------------------------
// Storyboard Functions
// --------------------------------------------------------------------------------------------------------------
#pragma mark -
+ (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}
+ (id)instantiateViewControllerBySBID:(NSString *)storyBoardID
{
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:storyBoardID];
}
+ (id)vcFromSegue:(UIStoryboardSegue *)segue
{
    id vc;
    
    if ([[self classNameFromObject:segue.destinationViewController] isEqualToString:@"UINavigationController"])
    {
        UINavigationController *nc = segue.destinationViewController;
        vc = [nc viewControllers][0];
    }
    else
    {
        vc = segue.destinationViewController;
    }
    
    return vc;
}

// --------------------------------------------------------------------------------------------------------------------------
// NSUserDefaults Functions
// --------------------------------------------------------------------------------------------------------------------------
#pragma mark -
+ (void)setAppSettingValue:(id)obj ByKey:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:obj forKey:key];
    [userDefault synchronize];
}

+ (id)appSettingValueByKey:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

+ (BOOL)checkKeyExistInAppSettings:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return !([userDefault objectForKey:key] == nil);
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Device Utility Functions
+ (BOOL)isRetina4
{
    return ([UIScreen mainScreen].bounds.size.height == 568);
}

+ (CGRect)screenRect
{
    return [[UIScreen mainScreen] bounds];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Alert Functions
+ (UIAlertView *)generalAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    if (title == nil)
    {
        title = ALERT_TITLE_WARNING;
    }
    
    if (message == nil)
    {
        message = @"";
    }
    
    NSString *okTitle = @"OK";
    
    UIAlertView *generalalert = [[UIAlertView alloc]
                                 initWithTitle:title
                                 message:message
                                 delegate:delegate
                                 cancelButtonTitle: nil
                                 otherButtonTitles: okTitle, nil];
    
    return generalalert;
}

+ (UIAlertView *)generalAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle delegate:(id)delegate
{
    if (title == nil)
    {
        title = ALERT_TITLE_WARNING;
    }
    
    if (message == nil)
    {
        message = @"";
    }
    
    if (buttonTitle == nil)
    {
        buttonTitle = @"OK";
    }
    
    UIAlertView *generalalert = [[UIAlertView alloc]
                                 initWithTitle:title
                                 message:message
                                 delegate:delegate
                                 cancelButtonTitle: nil
                                 otherButtonTitles: buttonTitle, nil];
    
    return generalalert;
}

+ (UIAlertView *)okCancelAlertWithTitle:(NSString *)title message:(NSString *)message OkTitle:(NSString *)okTitle CancelTitle:(NSString *)cancelTitle delegate:(id)delegate
{
    if (title == nil)
    {
        title = ALERT_TITLE_WARNING;
    }
    
    if (message == nil)
    {
        message = @"";
    }
    
    if (okTitle == nil)
    {
        okTitle = @"OK";
    }
    
    if (cancelTitle == nil)
    {
        cancelTitle = @"CANCEL";
    }
    
    UIAlertView *generalalert = [[UIAlertView alloc] initWithTitle:title
                                                           message:message
                                                          delegate:delegate
                                                 cancelButtonTitle: cancelTitle
                                                 otherButtonTitles: okTitle, nil];
    
    return generalalert;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Utility Functions
+ (void)addChildVC:(UIViewController *)childVC toParentVC:(UIViewController *)parentVC inContainerView:(UIView *)containerView
{
    [parentVC addChildViewController:childVC];
    [containerView addSubview:childVC.view];
    [childVC didMoveToParentViewController:parentVC];
}

+ (void)setupInputAccessoryViewWithPrevNextHideButtonsForTextControls:(NSArray *)textControls target:(id)target
                                            selectorForPreviousButton:(SEL)selectorPreviousButton
                                                selectorForNextButton:(SEL)selectorNextButton
                                                selectorForDoneButton:(SEL)selectorDoneButton
{
    int i = 0;
    for (id textControl in textControls)
    {
        
        SEL prevButtonSel = (i!=0 ? selectorPreviousButton: nil);
        SEL nextButtonSel = (i!=textControls.count-1 ? selectorNextButton: nil);
        
        [self setupInputAccessoryViewWithPrevNextHideButtonsForControl:textControl
                                                            withTarget:target
                                             selectorForPreviousButton:prevButtonSel
                                                 selectorForNextButton:nextButtonSel
                                                 selectorForDoneButton:selectorDoneButton];
        i++;
    }
}

+ (void)onBtnPrevInInputAccessoryViewForTextControls:(NSArray *)textControls activeField:(id)activeField
{
    for (NSInteger i=0; i<[textControls count]; i++)
    {
        if (activeField == textControls[i] && i > 0)
        {
            [textControls[i-1] becomeFirstResponder];
            break;
        }
    }
}

+ (void)onBtnNextInInputAccessoryViewForTextControls:(NSArray *)textControls activeField:(UITextField *)activeField
{
    for (NSInteger i=0; i<[textControls count]; i++)
    {
        if (activeField == textControls[i] && i < textControls.count-1)
        {
            [textControls[i+1] becomeFirstResponder];
            break;
        }
    }
}

+ (void)setupInputAccessoryViewWithHideButtonForControl:(id)textControl
{
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:self action:nil];
    UIBarButtonItem *barButtonHide  = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Hide" style: UIBarButtonItemStylePlain
                                       target:textControl action:@selector(resignFirstResponder)];
    
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonHide textColor:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.items = [NSArray arrayWithObjects:barButtonSpace, barButtonHide, nil];
    
    [textControl setInputAccessoryView:toolbar];
}

+ (UIBarButtonItem *)initInputAccessoryViewBarButtonByStyle:(UIBarButtonSystemItem)style target:(id)target selector:(SEL)selector forTextControl:(id)textControl
{
    if (selector)
    {
        return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style target:target action:selector];
    }
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style target:textControl action:@selector(resignFirstResponder)];
}

+ (void)setupInputAccessoryViewWithPrevNextHideButtonsForControl:(id)textControl withTarget:(id)target
                                       selectorForPreviousButton:(SEL)selectorPreviousButton
                                           selectorForNextButton:(SEL)selectorNextButton
                                           selectorForDoneButton:(SEL)selectorDoneButton
{
    
    UIBarButtonItem *barButtonPrev = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Previous" style: UIBarButtonItemStylePlain
                                      target:target action:selectorPreviousButton];
    
    UIBarButtonItem *barButtonNext = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Next" style:UIBarButtonItemStylePlain
                                      target:target action:selectorNextButton];
    
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:self action:nil];
    
    UIBarButtonItem *barButtonDone = [self initInputAccessoryViewBarButtonByStyle:UIBarButtonSystemItemDone
                                                                           target:target
                                                                         selector:selectorDoneButton
                                                                   forTextControl:textControl];
    
    
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonPrev withSelector:selectorPreviousButton];
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonNext withSelector:selectorNextButton];
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonDone textColor:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.items = [NSArray arrayWithObjects: barButtonPrev, barButtonNext, barButtonSpace, barButtonDone, nil];
    
    [textControl setInputAccessoryView:toolbar];
}

+ (void)setupInputAccessoryViewWithButtonTitle:(NSString *)buttonTitle
                                      selector:(SEL)selector target:(id)target forControl:(id)textControl
{
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:self action:nil];
    UIBarButtonItem *barButton      = [[UIBarButtonItem alloc]
                                       initWithTitle:buttonTitle style: UIBarButtonItemStylePlain
                                       target:target action:selector];
    
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButton textColor:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.items = [NSArray arrayWithObjects:barButtonSpace, barButton, nil];
    
    [textControl setInputAccessoryView:toolbar];
}

+ (void)setupInputAccessoryViewWithSetCancelButtonsForControl:(id)textControl withTarget:(id)target
                                         selectorForSetButton:(SEL)selectorSetButton
                                      selectorForCancelButton:(SEL)selectorCancelButton
{
    
    UIBarButtonItem *barButtonSet = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Set" style: UIBarButtonItemStylePlain
                                     target:target action:selectorSetButton];
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                        target:target action:selectorCancelButton];
    
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:self action:nil];
    
    
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonSet    withSelector:selectorSetButton];
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonCancel withSelector:selectorCancelButton];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.items = [NSArray arrayWithObjects: barButtonSet, barButtonSpace, barButtonCancel, nil];
    
    [textControl setInputAccessoryView:toolbar];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - DatePicker Input Accessory View
+ (UIDatePicker *)setupDatePickerInputViewByDatePickerMode:(UIDatePickerMode)datePickerMode
                                               textControl:(UITextField *)textControl
                                                withTarget:(id)target
                              selectorForDatePickerChanged:(SEL)selectorDatePickerChanged
                                         selectorForCancel:(SEL)selectorCancel
                                           selectorForDone:(SEL)selectorDone
{
    UIDatePicker *datePickerInputView  = [[UIDatePicker alloc] init];
    datePickerInputView.datePickerMode = datePickerMode;
    [datePickerInputView addTarget:target action:selectorDatePickerChanged forControlEvents:UIControlEventValueChanged];
    
    textControl.inputView = datePickerInputView;
    
    UIBarButtonItem *barButtonCancel = [self initInputAccessoryViewBarButtonByStyle:UIBarButtonSystemItemCancel
                                                                             target:target
                                                                           selector:selectorCancel
                                                                     forTextControl:textControl];
    UIBarButtonItem *barButtonSpace = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:self action:nil];
    UIBarButtonItem *barButtonDone = [self initInputAccessoryViewBarButtonByStyle:UIBarButtonSystemItemDone
                                                                           target:target
                                                                         selector:selectorDone
                                                                   forTextControl:textControl];
    
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonCancel textColor:nil];
    [FMBThemeManager decorateInputAccessoryViewBarButton:barButtonDone   textColor:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.items = [NSArray arrayWithObjects:barButtonCancel, barButtonSpace, barButtonDone, nil];
    
    textControl.inputAccessoryView = toolbar;
    
    return datePickerInputView;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Object Functions
+ (BOOL)isObjectEmpty:(id)obj
{
    if (obj == nil)
        return YES;
    if ([obj isEqual:[NSNull null]])
        return YES;
    
    return NO;
}
+ (BOOL)isObjectNotEmpty:(id)obj
{
    if (obj == nil)
        return NO;
    if ([obj isEqual:[NSNull null]])
        return NO;
    
    return YES;
}

+ (NSUInteger)indexOfPFObject:(PFObject *)object InObjects:(NSArray *)objects
{
    if ([self isObjectEmpty:object])
        return NSNotFound;
    
    int k = 0;
    for (PFObject *cc in objects)
    {
        if ([cc.objectId isEqualToString:object.objectId])
        {
            return k;
        }
        k++;
    }
    
    return NSNotFound;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - String Functions
+ (BOOL)isStringEmpty:(NSString *)string
{
    if ([self isObjectEmpty:string])
        return YES;
    
    NSString* result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [result isEqualToString:@""];
}
+ (BOOL)isStringNotEmpty:(NSString *)string
{
    if ([self isObjectEmpty:string])
        return NO;
    
    NSString* result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return ![result isEqualToString:@""];
}

+ (NSString *)stringFromObject:(id)object
{
    NSString *res = [NSString stringWithFormat:@"%@", object];
    return res;
}

+ (BOOL)stringContainsString:(NSString *)hayStack Needle:(NSString *)needle
{
    BOOL res = YES;
    
    if ([hayStack rangeOfString:needle options:NSCaseInsensitiveSearch].location == NSNotFound)
        res = NO;
    
    return res;
}

+ (NSString *)makeFirstLetterUpperCaseInString:(NSString *)input
{
    /* create a locale where diacritic marks are not considered important, e.g. US English */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    
    /* get first char */
    NSString *firstChar = [input substringToIndex:1];
    
    /* remove any diacritic mark */
    NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
    
    /* create the new string */
    NSString *result = [[folded uppercaseString] stringByAppendingString:[input substringFromIndex:1]];
    
    return result;
}

// --------------------------------------------------------------------------------------------------------------------------
// Validation Functions
// --------------------------------------------------------------------------------------------------------------------------
#pragma mark -

+ (BOOL)checkAllFieldsExist:(NSArray *)infoFields
{
    BOOL bValid = YES;
    
    int i = 0;
    for (NSDictionary *object in infoFields)
    {
        UITextField       *tf = object[kFMBValidationControlKey];
        
        if ([self isStringEmpty:tf.text])
        {
            NSString *placeholder = object[kFMBValidationPlaceholderKey];
            
            tf.text = @"";
            [FMBThemeManager setPlaceholder:placeholder toTextField:tf color:COMMON_COLOR_FOR_ERROR_TITLE];
            
            if (i == 0)
            {
                bValid = NO;
                [tf becomeFirstResponder];
            }
            else
            {
                if (bValid)
                    [tf becomeFirstResponder];
                bValid = NO;
            }
        }
        
        i++;
    }
    
    return bValid;
}

+ (int)checkValidUsername:(NSString *)checkString
{
    if ([checkString length] < SIGNUP_VALID_USERNAME_MINIMUM_LENGTH)
        return SIGNUP_INVALID_USERNAME_LENGTH;
    
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@" @"];
    NSRange r = [checkString rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound)
    {
        return SIGNUP_INVALID_USERNAME_CONTENT;
    }
    
    return SIGNUP_VALID_USERNAME_OK;
}

+ (BOOL)checkValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (int)checkValidPassword:(NSString *)checkString
{
    if([checkString length] >= SIGNUP_VALID_PASSWORD_MINIMUM_LENGTH)
    {
    }
    else
    {
        return SIGNUP_NOVALID_PASSWORD_LENGTH;
    }
    return SIGNUP_VALID_PASSWORD_OK;
}

+ (BOOL)checkValidPhoneNumberLength:(NSString *)checkString
{
    int length = [self getMobileNumberLength:checkString];
    
    return length == VALID_PHONE_NUMBER_LENGTH;
}

+ (BOOL)checkValidZipCode:(NSString *)checkString
{
    // Matches all US format ZIP code formats (e.g., "94105-0011" or "94105")
    NSString *pattern = @"^\\d{5}(-\\d{4})?$";
    
    return [self validateString:checkString withPattern:pattern];
}

+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = NO;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = YES;
    
    return didValidate;
}

// --------------------------------------------------------------------------------------------------------------------------
// Phone Number Functions
// --------------------------------------------------------------------------------------------------------------------------
#pragma mark -
+ (NSString*)formatMobileNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}

+ (NSString* )unformatMobileNumber:(NSString*)formattedNumber
{
    NSString *res = [NSString stringWithFormat:@"%@", formattedNumber];
    res = [NSString stringWithFormat:@"%@",[res stringByReplacingOccurrencesOfString:@"+" withString:@""]];
    res = [NSString stringWithFormat:@"%@",[res stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    res = [NSString stringWithFormat:@"%@",[res stringByReplacingOccurrencesOfString:@" " withString:@""]];
    res = [NSString stringWithFormat:@"%@",[res stringByReplacingOccurrencesOfString:@"(" withString:@""]];
    res = [NSString stringWithFormat:@"%@",[res stringByReplacingOccurrencesOfString:@")" withString:@""]];
    
    return res;
}

+ (int)getMobileNumberLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
}

+ (BOOL)doCallPhoneNumber:(NSString *)phoneNumber
{
    NSString *phoneNumberUrl = [NSString stringWithFormat:@"tel://%@", [self unformatMobileNumber:phoneNumber]];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://"]]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberUrl]];
        return YES;
    }
    return NO;
}

+ (BOOL)checkAndFormatPhoneNumberField:(UITextField *)textField
         shouldChangeCharactersInRange:(NSRange)range
                     replacementString:(NSString *)string
{
    int length = [self getMobileNumberLength:textField.text];
    
    if ([self checkValidPhoneNumberLength:textField.text])
    {
        if (range.length == 0)
        {
            return NO;
        }
    }
    
    if(length == 3)
    {
        NSString *num = [self formatMobileNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatMobileNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

// --------------------------------------------------------------------------------------------------------------------------
// Decimal Number Validation for TextField
// --------------------------------------------------------------------------------------------------------------------------
#pragma mark -
+ (BOOL)checkAndFormatDecimalNumberField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Make Amount field only aceept 2 after decimal when entering manually
    
    if ([string isEqualToString:@"."])
    {
        // When entered "."
        if ([FMBUtil stringContainsString:textField.text Needle:@"."] ||
            [textField.text length] == 0)
        {
            // The cases when entering XXX.XX.XX (should be avoided)
            // or currently if no string (should be avoided)
            return NO;
        }
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSArray *sep = [newString componentsSeparatedByString:@"."];
    if ([sep count] >= 2)
    {
        NSString *sepStr = [NSString stringWithFormat:@"%@", [sep objectAtIndex:1]];
        return !([sepStr length] > 2);
    }
    
    return YES;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Date Functions
+ (NSNumber *)ageFromDate:(NSDate *)dateOfBirth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    NSInteger age;
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        age = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        
    }
    else
    {
        age = [dateComponentsNow year] - [dateComponentsBirth year];
    }
    
    return [NSNumber numberWithInteger:age];
}

+ (NSNumber *)ageFromString:(NSString *)strBirthday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateOfBirth = [formatter dateFromString:strBirthday];
    
    return [self ageFromDate:dateOfBirth];
}

+ (NSString *)stringFromDate:(NSDate *)date WithFormat:(NSString *)formatString
{
    if ([self isObjectEmpty:date])
    {
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString WithFormat:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    return [formatter dateFromString:dateString];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Image Functions
+ (UIImage *)resizeImage:(UIImage *)image bySize:(CGSize)size
{
    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                        bounds:size
                                          interpolationQuality:kCGInterpolationHigh];
    
    return resizedImage;
}

+ (NSData *)dataFromImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    return imageData;
}

+ (void)setImageNamed:(NSString *)imageName toButton:(UIButton *)button
{
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - MBProgressHUD Functions
+ (MBProgressHUD *)initHUDWithView:(UIView *)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    return hud;
}

+ (void)showHUD:(MBProgressHUD *)hud withText:(NSString *)text
{
    hud.labelText = text;
    [hud show:YES];
}

+ (void)hideHUD:(MBProgressHUD *)hud withText:(NSString *)text
{
    UIImage         *image = [UIImage imageNamed:COMMON_IMAGE_HUD_CHECKMARK];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    hud.customView = imageView;
    hud.mode       = MBProgressHUDModeCustomView;
    hud.labelText  = text;
    
    [hud hide:YES afterDelay:1.f];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Parse Error Handling Functions
+ (NSString *)errorStringFromParseError:(NSError *)error WithCode:(BOOL)bWithCodeInfo
{
    NSString *res = @"";
    
    if ([self isObjectNotEmpty:error])
    {
        if (bWithCodeInfo)
        {
            res = [NSString stringWithFormat:@"ERROR CODE:%ld - %@", (long)error.code, [error userInfo][@"error"]];
        }
        else
        {
            res = [error userInfo][@"error"];
            
            res = [self makeFirstLetterUpperCaseInString:res];
        }
    }
    
    return res;
}

+ (UIAlertView *)alertByParseError:(NSError *)error delegate:(id)delegate
{
    UIAlertView *res;
    
    if ([error code] != kPFErrorConnectionFailed)
    {
        res = [self generalAlertWithTitle:ALERT_TITLE_ERROR
                                  message:[self errorStringFromParseError:error WithCode:NO]
                              buttonTitle:@"Try Again"
                                 delegate:delegate];
    }
    else
    {
        res = [self generalAlertWithTitle:@"Network Problem"
                                  message:@"Your network connection is offline or too slow. You must be connected to network to continue."
                              buttonTitle:@"Try Again"
                                 delegate:delegate];
    }
    
    return res;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - PopoverController Functions
+ (WYPopoverController *)showPOFromSender:(id)sender
                           contentVC_SBID:(NSString *)contentVC_SBID
                        contentVCDelegate:(id)contentVCDelegate
                        popOverVCDelegate:(id)popOverVCDelegate
                            contentVCRect:(CGRect)contentViewRect
                            fromBarButton:(BOOL)bFromBarButton
{
    id      contentVC = [FMBUtil instantiateViewControllerBySBID:contentVC_SBID];
    
    [contentVC setDelegate:contentVCDelegate];
    [contentVC setPreferredContentSize:contentViewRect.size];
    
    WYPopoverController *res    = [[WYPopoverController alloc] initWithContentViewController:contentVC];
    res.delegate                = popOverVCDelegate;
    [self initTheme4PO:res];
    
    if (bFromBarButton)
    {
        [res presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [res presentPopoverFromRect:contentViewRect
                             inView:[(UIViewController *)contentVC view]
           permittedArrowDirections:WYPopoverArrowDirectionNone
                           animated:YES];
    }
    
    return res;
}

+ (void)initTheme4PO:(WYPopoverController *)po
{
    po.theme.fillTopColor      = RGBHEX(0x000000, 0.8f);
    po.theme.fillBottomColor   = RGBHEX(0x000000, 0.8f);
    po.theme.outerStrokeColor  = [UIColor whiteColor];
}

+ (UIBarButtonItem *)barButtonItemFromView:(UIView *)view
{
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Slider Functions
+ (void)setupRangeSlider:(ACVRangeSelector *)target minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue
{
    target.minimumValue = minValue;
    target.maximumValue = maxValue;
    
    [target setLeftThumbImage:  [UIImage imageNamed:@"00_slider_thumb"]     forState:UIControlStateNormal];
    [target setRightThumbImage: [UIImage imageNamed:@"00_slider_thumb"]     forState:UIControlStateNormal];
    [target setMiddleThumbImage:[UIImage imageNamed:@"00_slider_thumb"]     forState:UIControlStateNormal];
    [target setConnectionImage: [UIImage imageNamed:@"00_slider_connector"] forState:UIControlStateNormal];
    [target setTrackImage:      [UIImage imageNamed:@"00_slider_track"]];
    
    target.scaleMiddleThumb = NO;
    //    target.leftPointerOffset = 17;
    //    target.rightPointerOffset = 17;
    target.connectionOffset = 0;
}

+ (void)setupSlider:(UISlider *)traget
{
    [traget setThumbImage:[UIImage imageNamed:@"00_slider_thumb"] forState:UIControlStateNormal];
    [traget setThumbImage:[UIImage imageNamed:@"00_slider_thumb"] forState:UIControlStateHighlighted];
    
    [traget setMinimumTrackImage:[UIImage imageNamed:@"00_slider_track_min"] forState:UIControlStateNormal];
    [traget setMaximumTrackImage:[UIImage imageNamed:@"00_slider_track"]     forState:UIControlStateNormal];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Rating View Functions
+ (RatingView *)initRatingViewWithFrame:(CGRect)frame
{
    RatingView *res = [[RatingView alloc] initWithFrame:frame
                                      selectedImageName:@"00_star_highlighted"
                                        unSelectedImage:@"00_star_normal"
                                               minValue:0
                                               maxValue:5
                                          intervalValue:0.1
                                             stepByStep:YES];
    
    return res;
}

@end
