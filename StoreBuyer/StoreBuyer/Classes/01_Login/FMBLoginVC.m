//
//  FMBLoginVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBLoginVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

#define SEGID_SIGNUP                    @"SEGID_Signup"
#define SEGID_RESETPASSWORD             @"SEGID_ResetPassword"

@interface FMBLoginVC ()

@end

@implementation FMBLoginVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBLoginVC) return;
    
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
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameLogin toImageView:_imageviewBackground];
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameLogin delegate:self];
    
    self.tableView.backgroundView  = _imageviewBackground;
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMBThemeManager setPlaceholder:@"Email"    toTextField:self.txtEmail    color:[UIColor whiteColor]];
    [FMBThemeManager setPlaceholder:@"Password" toTextField:self.txtPassword color:[UIColor whiteColor]];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[self.txtEmail, self.txtPassword];
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
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameLogin toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnLogin:(id)sender
{
    [self printLogWith:@"onBtnLogin"];
    
    if (![self doValidationProcess])
    {
        return;
    }
    
    [self doUserLogin];
}

- (IBAction)onBtnFacebook:(id)sender
{
    [self printLogWith:@"onBtnFacebook"];
    
    NSArray *permissions = [FMBUserUtil facebookPersmissions];
    
    [FMBUtil showHUD:self.hud withText:@""];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[error localizedDescription]];
             
             [self.hud hide:YES];
             
             [[FMBUtil generalAlertWithTitle:@""
                                     message:@"Please check your network connection."
                                    delegate:self] show];
         }
         else if (!user)
         {
             [self printLogWith:@"Uh oh. The user cancelled the Facebook login."];
         }
         else if (user.isNew)
         {
             [self printLogWith:@"User signed up and logged in through Facebook!"];
             
             [FMBUserUtil startFacebookRequestMeWithDelegate:self];
         }
         else
         {
             [self printLogWith:@"User logged in through Facebook!"];
             
             if ([FMBUtil isStringEmpty:user[kFMUserFacebookIDKey]])
             {
                 [FMBUserUtil startFacebookRequestMeWithDelegate:self];
             }
             else
             {
                 [self.hud hide:YES];
                 
                 [[FMBUtil appDelegate] setupSceneOnLoggedIn];
             }
         }
     }];
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
    [self onBtnLogin:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - User Login Functions
- (void)doUserLogin
{
    [self printLogWith:@"doUserLogin"];
    
    [FMBUtil showHUD:self.hud withText:@""];
    
    [PFUser logInWithUsernameInBackground:[_txtEmail.text lowercaseString]
                                 password:_txtPassword.text
                                    block:^(PFUser *user, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
             
             [[FMBUtil alertByParseError:error delegate:self] show];
         }
         else
         {
             // Log-in succeeed, but check if the user is not in Buyer role.
             if (![user[kFMUserRoleKey] isEqualToString:kFMUserRoleBuyer])
             {
                 [[FMBUtil generalAlertWithTitle:ALERT_TITLE_ERROR
                                         message:@"You don't have right permission." delegate:self] show];
                 [PFUser logOut];
                 return;
             }
             
             [self printLogWith:@"User logged in successfully."];
             
             [FMBUserUtil connectCurrentUserToInstallation];
             
             [[FMBUtil appDelegate] setupSceneOnLoggedIn];
         }
     }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FBFacebookUtilDelegate
- (void)facebookRequestMeDidLoadWithResult:(id)result
{
    [self printLogWith:@"facebookRequestMeDidLoadWithResult"];
    
    [_hud hide:YES];
    
    PFUser *user = [PFUser currentUser];
    
    if (user)
    {
        [self performSegueWithIdentifier:SEGID_SIGNUP sender:result];
    }
}

- (void)facebookRequestMeError:(NSError *)error
{
    [self printLogWith:@"facebookRequestMeError"];
    
    [_hud hide:YES];
    
    [self printLogWith:[error localizedDescription]];
    
    if ([PFUser currentUser])
    {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"])
        {
            [self printLogWith:@"The Facebook token was invalidated. Logging out."];
        }
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMBValidationPlaceholderKey:@"Email",  kFMBValidationControlKey: self.txtEmail},
                            @{kFMBValidationPlaceholderKey:@"Password",  kFMBValidationControlKey: self.txtPassword},];
    
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
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_SIGNUP])
    {
        FMBSignupVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate     = self;
        
        if ([[FMBUtil classNameFromObject:sender] isEqualToString:kFMFacebookResultClassNameKey])
        {
            vc.facebookResult = sender;
        }
    }
    
    if ([segue.identifier isEqualToString:SEGID_RESETPASSWORD])
    {
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBSignupVCDelegate
- (void)signupVCDidCancel
{
    [self printLogWith:@"signupVCDidCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signupVCDidCreateAccount
{
    [self printLogWith:@"signupVCDidCreateAccount"];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        [[FMBUtil appDelegate] setupSceneOnLoggedIn];
    }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Function
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if ([FMBUtil isRetina4])
            return 203.f;
        else
            return 115.f;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
