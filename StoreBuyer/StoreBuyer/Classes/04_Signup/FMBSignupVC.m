//
//  FMBSignupVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBSignupVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBUserUtil.h"
#import "FMBBackgroundSetting.h"

@interface FMBSignupVC ()

@end

@implementation FMBSignupVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBSignupVC) return;
    
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    [self setupInputAccessoryViews];
    [self initTextFieldsPlaceholder];
    [self initContentFromFacebookResult];
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtFirstName, _txtLastName, _txtEmail, _txtPhoneNumber, self.txtPassword];
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

- (void)initTheme
{
    [self printLogWith:@"initTheme"];

    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameLogin toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameLogin delegate:self];
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMBThemeManager setPlaceholder:@"First Name"       toTextField:_txtFirstName   color:[UIColor whiteColor]];
    [FMBThemeManager setPlaceholder:@"Last Name"        toTextField:_txtLastName    color:[UIColor whiteColor]];
    [FMBThemeManager setPlaceholder:@"Email Address"    toTextField:_txtEmail       color:[UIColor whiteColor]];
    [FMBThemeManager setPlaceholder:@"Phone Number"     toTextField:_txtPhoneNumber color:[UIColor whiteColor]];
    [FMBThemeManager setPlaceholder:@"Password"         toTextField:_txtPassword    color:[UIColor whiteColor]];
}

- (void)initContentFromFacebookResult
{
    [self printLogWith:@"initContentFromFacebookResult"];
    
    if ([FMBUtil isObjectEmpty:self.facebookResult]) return;
    
    _facebookId         = _facebookResult[kFMFacebookResultIDKey];
    _txtFirstName.text  = _facebookResult[kFMFacebookResultFirstNameKey];
    _txtLastName.text   = _facebookResult[kFMFacebookResultLastNameKey];
    _txtEmail.text      = _facebookResult[kFMFacebookResultEmailKey];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameLogin toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self.delegate signupVCDidCancel];
}

- (IBAction)onBtnRegister:(id)sender
{
    [self printLogWith:@"onBtnRegister"];
    
    if ([self doValidationProcess])
    {
        [self doRegister];
    }
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
    [self.view endEditing:YES];
    
    [self onBtnRegister:nil];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.txtPhoneNumber])
    {
        if (![FMBUtil checkAndFormatPhoneNumberField:textField
                       shouldChangeCharactersInRange:range
                                   replacementString:string])
        {
            return NO;
        }
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    
    if (indexPath.row == 1)
    {
        [_txtFirstName becomeFirstResponder];
    }
    else if (indexPath.row == 2)
    {
        [_txtEmail becomeFirstResponder];
    }
    else if (indexPath.row == 3)
    {
        [_txtPhoneNumber becomeFirstResponder];
    }
    else if (indexPath.row == 4)
    {
        [_txtPassword becomeFirstResponder];
    }
    else if (indexPath.row == 6)
    {
        [self onBtnRegister:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Registration Functions
- (void)doRegister
{
    [self printLogWith:@"doRegister"];
    
    [FMBUtil showHUD:self.hud withText:@""];
    
    PFUser *user;
    
    if ([FMBUtil isObjectEmpty:self.facebookId])
    {
        user = [[PFUser alloc] init];
    }
    else
    {
        user = [PFUser currentUser];
    }
    
    user[kFMUserUsernameKey]    = [_txtEmail.text lowercaseString];
    user[kFMUserEmailKey]       = [_txtEmail.text lowercaseString];
    user[kFMUserPhoneNumberKey] = _txtPhoneNumber.text;
    user[kFMUserFirstNameKey]   = _txtFirstName.text;
    user[kFMUserLastNameKey]    = _txtLastName.text;
    user[kFMUserRoleKey]        = kFMUserRoleBuyer;
    
    [user setPassword:self.txtPassword.text];
    
    if ([FMBUtil isObjectNotEmpty:_facebookId])
    {
        user[kFMUserFacebookIDKey] = _facebookId;
    }
    
    if ([FMBUtil isObjectEmpty:self.facebookId])
    {
        [self signupWithPasswordAttachedUser:user];
    }
    else
    {
        [self signupWithoutPasswordUser:user];
    }
}

- (void)signupWithPasswordAttachedUser:(PFUser *)user
{
    [self printLogWith:@"signupWithPasswordAttachedUser"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [self signupRequestDidFailWithError:error];
             return;
         }
         else
         {
             [self printLogWith:@"User signed up successfully."];
             
             [self signupRequestSucceed];
         }
     }];
}

- (void)signupWithoutPasswordUser:(PFUser *)user
{
    [self printLogWith:@"signupWithoutPasswordUser"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self.hud hide:YES];
        
        if (error)
        {
            [self signupRequestDidFailWithError:error];
        }
        else
        {
            [self signupRequestSucceed];
        }
    }];
}

- (void)signupRequestSucceed
{
    [self printLogWith:@"signupRequestSucceed"];
    
    PFUser *user = [PFUser currentUser];
    
    [user saveInBackground];
    
    [self.delegate signupVCDidCreateAccount];
}

- (void)signupRequestDidFailWithError:(NSError *)error
{
    [self printLogWith:@"signupRequestDidFailWithError"];
    [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
    
    [[FMBUtil alertByParseError:error delegate:self] show];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMBValidationPlaceholderKey:@"First Name",       kFMBValidationControlKey: _txtFirstName},
                            @{kFMBValidationPlaceholderKey:@"Last Name",        kFMBValidationControlKey: _txtLastName},
                            @{kFMBValidationPlaceholderKey:@"Email Address",    kFMBValidationControlKey: _txtEmail},
                            @{kFMBValidationPlaceholderKey:@"Phone Number",     kFMBValidationControlKey: _txtPhoneNumber},
                            @{kFMBValidationPlaceholderKey:@"Password",         kFMBValidationControlKey: _txtPassword},];
    
    return [FMBUtil checkAllFieldsExist:infoFields];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if (![self checkAllFieldsExist])
    {
        [[FMBUtil generalAlertWithTitle:nil message:ALERT_MSG_FIELDS_EMPTY delegate:self] show];
        return NO;
    }
    
    if (![FMBUtil checkValidEmail:self.txtEmail.text])
    {
        [[FMBUtil generalAlertWithTitle:nil message:ALERT_MSG_INVALID_EMAIL delegate:self] show];
        [self.txtEmail becomeFirstResponder];
        
        return NO;
    }
    
    if (![FMBUtil checkValidPhoneNumberLength:self.txtPhoneNumber.text])
    {
        NSString *msg = [NSString stringWithFormat:@"The length of phone number should be %d.", VALID_PHONE_NUMBER_LENGTH];
        [[FMBUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        [self.txtPhoneNumber becomeFirstResponder];
        
        return NO;
    }
    
    int iPasswordValidity = [FMBUtil checkValidPassword:self.txtPassword.text];
    if (iPasswordValidity == SIGNUP_NOVALID_PASSWORD_LENGTH)
    {
        NSString *msg = [NSString stringWithFormat:@"The length of password should be %d or more character.", SIGNUP_VALID_PASSWORD_MINIMUM_LENGTH];
        [[FMBUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        [self.txtPassword becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}

@end
