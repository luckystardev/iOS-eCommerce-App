//
//  FMBResetPasswordVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBResetPasswordVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

@interface FMBResetPasswordVC ()

@end

@implementation FMBResetPasswordVC

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
    
    _hud = [FMBUtil initHUDWithView:self.view];
    
    _labelMsg.textColor = [UIColor whiteColor];
    
    [self toggleMessageView:NO];
}

- (void)setupInputAccessoryViews
{
    [self printLogWith:@"setupInputAccessoryViews"];
    
    [FMBUtil setupInputAccessoryViewWithPrevNextHideButtonsForControl:_txtEmail withTarget:self
                                            selectorForPreviousButton:nil
                                                selectorForNextButton:nil
                                                selectorForDoneButton:nil];
    
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
    
    [FMBThemeManager setPlaceholder:@"Enter your email address."   toTextField:_txtEmail   color:[UIColor whiteColor]];
}

- (void)toggleMessageView:(BOOL)bShow
{
    [self printLogWith:@"toggleMessageView"];
    
    _labelMsg.hidden            = !bShow;
    _btnSendRequest.hidden      = bShow;
    _txtEmail.hidden            = bShow;
    _labelEmailContainer.hidden = bShow;
    _btnImageEmail.hidden       = bShow;
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnSendRequest:(id)sender
{
    [self printLogWith:@"onBtnSendRequest"];
    
    if ([self doValidationProcess])
    {
        [self doSendRequest];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TextFields Functions
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [self onBtnSendRequest:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    
    if (indexPath.row == 2)
    {
        [_txtEmail becomeFirstResponder];
    }
    else if (indexPath.row == 4)
    {
        [self onBtnSendRequest:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Send Request Functions
- (void)doSendRequest
{
    [self printLogWith:@"doSendRequest"];
    
    [FMBUtil showHUD:_hud withText:@""];
    
    [PFUser requestPasswordResetForEmailInBackground:self.txtEmail.text block:^(BOOL succeeded, NSError *error)
     {
         [self printLogWith:@"PFUser requestPasswordResetForEmailInBackground"];
         [self.hud hide:YES];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
             
             [[FMBUtil alertByParseError:error delegate:self] show];
         }
         else
         {
             // Password reuqest successfully sent
             [self toggleMessageView:YES];
         }
     }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMBValidationPlaceholderKey:@"Enter your email address.",kFMBValidationControlKey: _txtEmail},
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
    
    return YES;
}

@end
