//
//  FMBUtil.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "WYPopoverController.h"
#import "ACVRangeSelector.h"
#import "RatingView.h"

@interface FMBUtil : NSObject

// ----------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (id)infoDictionaryValueByKey:(NSString *)key;
+ (NSString *)classNameFromObject:(id)aObj;

// ----------------------------------------------------------------------------------------
#pragma mark - App Framework Functions
+ (AppDelegate *)appDelegate;

// ----------------------------------------------------------------------------------------
// Parse Application ID and Client Key, Stripe Publishable Key, CardIO App Token
// ----------------------------------------------------------------------------------------
+ (NSString *)parseApplicationID;
+ (NSString *)parseClientKey;
+ (NSString *)stripePublishableKey;
+ (NSString *)cardIOAppToken;

// ----------------------------------------------------------------------------------------
// Storyboard Functions
// ----------------------------------------------------------------------------------------
+ (UIStoryboard *)mainStoryboard;
+ (id)instantiateViewControllerBySBID:(NSString *)storyBoardID;
+ (id)vcFromSegue:(UIStoryboardSegue *)segue;

// ----------------------------------------------------------------------------------------
#pragma mark -
+ (void)setAppSettingValue:(id)obj ByKey:(NSString *)key;
+ (id)appSettingValueByKey:(NSString *)key;
+ (BOOL)checkKeyExistInAppSettings:(NSString *)key;

// ---------------------------------------------------------------------------------------
#pragma mark - Device Utility Functions
+ (BOOL)isRetina4;
+ (CGRect)screenRect;

// ---------------------------------------------------------------------------------------
#pragma mark - Alert Functions
+ (UIAlertView *)generalAlertWithTitle:(NSString *)title message:(NSString *)message
                              delegate:(id)delegate;
+ (UIAlertView *)okCancelAlertWithTitle:(NSString *)title message:(NSString *)message
                                OkTitle:(NSString *)okTitle CancelTitle:(NSString *)cancelTitle
                               delegate:(id)delegate;

// --------------------------------------------------------------------------------------
#pragma mark - UI Utility Functions
+ (void)addChildVC:(UIViewController *)childVC toParentVC:(UIViewController *)parentVC inContainerView:(UIView *)containerView;
+ (void)setupInputAccessoryViewWithPrevNextHideButtonsForTextControls:(NSArray *)textControls target:(id)target
                                            selectorForPreviousButton:(SEL)selectorPreviousButton
                                                selectorForNextButton:(SEL)selectorNextButton
                                                selectorForDoneButton:(SEL)selectorDoneButton;

+ (void)onBtnPrevInInputAccessoryViewForTextControls:(NSArray *)textControls activeField:(id)activeField;
+ (void)onBtnNextInInputAccessoryViewForTextControls:(NSArray *)textControls activeField:(UITextField *)activeField;
+ (void)setupInputAccessoryViewWithHideButtonForControl:(id)textControl;
+ (void)setupInputAccessoryViewWithPrevNextHideButtonsForControl:(id)textControl withTarget:(id)target
                                       selectorForPreviousButton:(SEL)selectorPreviousButton
                                           selectorForNextButton:(SEL)selectorNextButton
                                           selectorForDoneButton:(SEL)selectorDoneButton;
+ (void)setupInputAccessoryViewWithButtonTitle:(NSString *)buttonTitle
                                      selector:(SEL)selector target:(id)target forControl:(id)textControl;

+ (void)setupInputAccessoryViewWithSetCancelButtonsForControl:(id)textControl withTarget:(id)target
                                         selectorForSetButton:(SEL)selectorSetButton
                                      selectorForCancelButton:(SEL)selectorCancelButton;

// ---------------------------------------------------------------------------------------
#pragma mark - DatePicker Input Accessory View
+ (UIDatePicker *)setupDatePickerInputViewByDatePickerMode:(UIDatePickerMode)datePickerMode
                                               textControl:(UITextField *)textControl
                                                withTarget:(id)target
                              selectorForDatePickerChanged:(SEL)selectorDatePickerChanged
                                         selectorForCancel:(SEL)selectorCancel
                                           selectorForDone:(SEL)selectorDone;

// ---------------------------------------------------------------------------------------
#pragma mark - Object Functions
+ (BOOL)isObjectEmpty:(id)obj;
+ (BOOL)isObjectNotEmpty:(id)obj;
+ (NSUInteger)indexOfPFObject:(PFObject *)object InObjects:(NSArray *)objects;

// ---------------------------------------------------------------------------------------
#pragma mark - String Functions
+ (BOOL)isStringEmpty:(NSString *)string;
+ (BOOL)isStringNotEmpty:(NSString *)string;
+ (NSString *)stringFromObject:(id)object;
+ (BOOL)stringContainsString:(NSString *)hayStack Needle:(NSString *)needle;
+ (NSString *)makeFirstLetterUpperCaseInString:(NSString *)input;

// --------------------------------------------------------------------------------------
// Validation Functions
// --------------------------------------------------------------------------------------
#pragma mark -
+ (BOOL)checkAllFieldsExist:(NSArray *)infoFields;
+ (int)checkValidUsername:(NSString *)checkString;
+ (BOOL)checkValidEmail:(NSString *)checkString;
+ (int)checkValidPassword:(NSString *)checkString;
+ (BOOL)checkValidPhoneNumberLength:(NSString *)checkString;
+ (BOOL)checkValidZipCode:(NSString *)checkString;
+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern;

// --------------------------------------------------------------------------------------
// Phone Number Functions
// --------------------------------------------------------------------------------------
#pragma mark -
+ (BOOL)doCallPhoneNumber:(NSString *)phoneNumber;
+ (BOOL)checkAndFormatPhoneNumberField:(UITextField *)textField
         shouldChangeCharactersInRange:(NSRange)range
                     replacementString:(NSString *)string;

// --------------------------------------------------------------------------------------
// Decimal Number Validation for TextField
// --------------------------------------------------------------------------------------
#pragma mark -
+ (BOOL)checkAndFormatDecimalNumberField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

// --------------------------------------------------------------------------------------
#pragma mark - Date Functions
+ (NSNumber *)ageFromDate:(NSDate *)dateOfBirth;
+ (NSNumber *)ageFromString:(NSString *)strBirthday;
+ (NSString *)stringFromDate:(NSDate *)date WithFormat:(NSString *)formatString;
+ (NSDate *)dateFromString:(NSString *)dateString WithFormat:(NSString *)formatString;

// --------------------------------------------------------------------------------------
#pragma mark - Image Functions
+ (UIImage *)resizeImage:(UIImage *)image bySize:(CGSize)size;
+ (NSData *)dataFromImage:(UIImage *)image;
+ (void)setImageNamed:(NSString *)imageName toButton:(UIButton *)button;

// --------------------------------------------------------------------------------------
#pragma mark - MBProgressHUD Functions
+ (MBProgressHUD *)initHUDWithView:(UIView *)view;
+ (void)showHUD:(MBProgressHUD *)hud withText:(NSString *)text;
+ (void)hideHUD:(MBProgressHUD *)hud withText:(NSString *)text;

// --------------------------------------------------------------------------------------
#pragma mark - Parse Error Handling Functions
+ (NSString *)errorStringFromParseError:(NSError *)error WithCode:(BOOL)bWithCodeInfo;
+ (UIAlertView *)alertByParseError:(NSError *)error delegate:(id)delegate;

// --------------------------------------------------------------------------------------
#pragma mark - PopoverController Functions
+ (WYPopoverController *)showPOFromSender:(id)sender
                           contentVC_SBID:(NSString *)contentVC_SBID
                        contentVCDelegate:(id)contentVCDelegate
                        popOverVCDelegate:(id)popOverVCDelegate
                            contentVCRect:(CGRect)contentViewRect
                            fromBarButton:(BOOL)bFromBarButton;

+ (void)initTheme4PO:(WYPopoverController *)po;
+ (UIBarButtonItem *)barButtonItemFromView:(UIView *)view;

// ---------------------------------------------------------------------------------------
#pragma mark - Range Slider Functions
+ (void)setupRangeSlider:(ACVRangeSelector *)target
                minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;
+ (void)setupSlider:(UISlider *)traget;

// ---------------------------------------------------------------------------------------
#pragma mark - Rating View Functions
+ (RatingView *)initRatingViewWithFrame:(CGRect)frame;

@end
