//
//  FMBChangePasswordVC.m
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBChangePasswordVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

@interface FMBChangePasswordVC ()

@end

@implementation FMBChangePasswordVC

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
    
    [self initViewBackground];
    [self setupInputAccessoryViews];
    
    [self initTextFieldsPlaceholder];
    [self toggleMessageView:NO];
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtNewPassword, _txtConfirmPassword];
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
    
    [FMBThemeManager setPlaceholder:@"New Password."            toTextField:_txtNewPassword       color:[UIColor whiteColor]];
    [FMBThemeManager setPlaceholder:@"Confirm New Password."    toTextField:_txtConfirmPassword   color:[UIColor whiteColor]];
}

- (void)toggleMessageView:(BOOL)bShow
{
    [self printLogWith:@"toggleMessageView"];
    
    _labelMessage.hidden        = !bShow;
    _labelBack1.hidden          = bShow;
    _labelBack2.hidden          = bShow;
    _btnChangePassword.hidden   = bShow;
    _txtNewPassword.hidden      = bShow;
    _txtConfirmPassword.hidden  = bShow;
    _btnIconImage1.hidden       = bShow;
    _btnIconImage2.hidden       = bShow;
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

- (IBAction)onBtnChangePassword:(id)sender
{
    [self printLogWith:@"onBtnChangePassword"];
    
    if ([self doValidationProcess])
    {
        [self doChangePassword];
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
    
    [self onBtnChangePassword:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    
    if (indexPath.row == 1)
    {
        [_txtNewPassword becomeFirstResponder];
    }
    else if (indexPath.row == 2)
    {
        [_txtConfirmPassword becomeFirstResponder];
    }
    else if (indexPath.row == 4)
    {
        [self onBtnChangePassword:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Send Request Functions
- (void)doChangePassword
{
    [self printLogWith:@"doChangePassword"];
    
    [self.view endEditing:YES];
    
    [FMBUtil showHUD:_hud withText:@""];
    
    PFUser *user = [PFUser currentUser];
    
    [user setPassword:_txtNewPassword.text];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        [_hud hide:YES];
        
        if (error)
        {
            [[FMBUtil alertByParseError:error delegate:self] show];
        }
        else
        {
            [self toggleMessageView:YES];
        }
    }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMBValidationPlaceholderKey:@"New Password",kFMBValidationControlKey: _txtNewPassword},
                            @{kFMBValidationPlaceholderKey:@"Confirm New Password",kFMBValidationControlKey:_txtConfirmPassword},
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
    
    int iPasswordValidity = [FMBUtil checkValidPassword:_txtNewPassword.text];
    if (iPasswordValidity == SIGNUP_NOVALID_PASSWORD_LENGTH)
    {
        NSString *msg = [NSString stringWithFormat:@"The length of password should be %d or more character.", SIGNUP_VALID_PASSWORD_MINIMUM_LENGTH];
        
        [[FMBUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        
        [_txtNewPassword becomeFirstResponder];
        
        return NO;
    }
    
    if (![_txtNewPassword.text isEqualToString:_txtConfirmPassword.text])
    {
        [[FMBUtil generalAlertWithTitle:nil message:@"The passwords don't match." delegate:self] show];
        return NO;
    }
    
    return YES;
}

@end
