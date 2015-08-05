//
//  FMBEditProfileVC.m
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBEditProfileVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBUserUtil.h"
#import "FMBBackgroundSetting.h"

#define SEGID_CHANGEPASSWORD            @"SEGID_ChangePassword"

@interface FMBEditProfileVC ()

@end

@implementation FMBEditProfileVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBEditProfileVC) return;
    
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
    [self initDataSource];
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtFirstName, _txtLastName, _txtEmail, _txtPhoneNumber];
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
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameERegister toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameERegister delegate:self];
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

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    PFUser *user = [PFUser currentUser];
    
    _txtFirstName.text   = user[kFMUserFirstNameKey];
    _txtLastName.text    = user[kFMUserLastNameKey];
    _txtEmail.text       = user[kFMUserEmailKey];
    _txtPhoneNumber.text = user[kFMUserPhoneNumberKey];
    _txtPassword.text    = @"asdfasdf";
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameERegister toImageView:_imageviewBackground];
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
    
    if ([self doValidationProcess])
    {
        [self doSave];
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
    
    [self onBtnSave:nil];
    
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
        [self performSegueWithIdentifier:SEGID_CHANGEPASSWORD sender:self];
    }
    else if (indexPath.row == 6)
    {
        [self onBtnSave:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Registration Functions
- (void)doSave
{
    [self printLogWith:@"doSave"];
    
    [FMBUtil showHUD:self.hud withText:@""];
    
    PFUser *user = [PFUser currentUser];
    
    user[kFMUserUsernameKey]    = [_txtEmail.text lowercaseString];
    user[kFMUserEmailKey]       = [_txtEmail.text lowercaseString];
    user[kFMUserPhoneNumberKey] = _txtPhoneNumber.text;
    user[kFMUserFirstNameKey]   = _txtFirstName.text;
    user[kFMUserLastNameKey]    = _txtLastName.text;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        [_hud hide:YES];
        
        if (error)
        {
            [[FMBUtil alertByParseError:error delegate:self] show];
        }
        else
        {
            // Successfully Saved.
            [_delegate editProfileVCDidSaveSuccessfully];
        }
    }];
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
                            ];
    
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
    
    return YES;
}

@end
