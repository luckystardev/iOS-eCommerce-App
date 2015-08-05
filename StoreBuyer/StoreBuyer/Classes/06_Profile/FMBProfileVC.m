//
//  FMBProfileVC.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBProfileVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

#define SEGID_ADDCARD                       @"SEGID_AddCard"
#define SEGID_ADDSHIPPINGADDRESS            @"SEGID_AddShippingAddress"
#define SEGID_EDITPROFILE                   @"SEGID_EditProfile"

@interface FMBProfileVC ()

@end

@implementation FMBProfileVC

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBProfileVC) return;
    
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initDataSource];
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initViewBackground];
    
    [FMBThemeManager makeCircleWithView:_imageviewAvatar
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
    
    _cardListView.delegate              = self;
    _shippingAddressListView.delegate   = self;
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameERegister toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameERegister delegate:self];
    
    _viewBack1.backgroundColor                  = [UIColor clearColor];
    
    _cardListView.backgroundColor               = [UIColor clearColor];
    _shippingAddressListView.backgroundColor    = [UIColor clearColor];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    _labelName.text = [PFUser currentUser][kFMUserFirstNameKey];
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnMenu:(id)sender
{
    [self printLogWith:@"onBtnMenu"];
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_ADDCARD])
    {
        FMBAddCardVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate      = self;
        
        vc.backgroundName = kFMBackgroundNameERegister;
    }
    
    if ([segue.identifier isEqualToString:SEGID_ADDSHIPPINGADDRESS])
    {
        FMBAddShippingAddressVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate                 = self;
        vc.backgroundName = kFMBackgroundNameERegister;
    }
    
    if ([segue.identifier isEqualToString:SEGID_EDITPROFILE])
    {
        FMBEditProfileVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate = self;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBEditProfileVCDelegate
- (void)editProfileVCDidSaveSuccessfully
{
    [self printLogWith:@"editProfileVCDidSaveSuccessfully"];
    
    [self initDataSource];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBCardListViewDelegate
- (void)cardListViewDidClickAddButton
{
    [self printLogWith:@"cardListViewDidClickAddButton"];
    
    [self performSegueWithIdentifier:SEGID_ADDCARD sender:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBAddCardVCDelegate
- (void)addCardVC:(FMBAddCardVC *)controller didSaveCard:(PKCard *)card
{
    [self printLogWith:@"addCardVC: didSaveCard"];
    
    [self.cardListView addCard:card];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBShippingAddressListViewDelegate
- (void)shippingAddressListViewDidClickAddButton
{
    [self printLogWith:@"shippingAddressListViewDidClickAddButton"];
    
    [self performSegueWithIdentifier:SEGID_ADDSHIPPINGADDRESS sender:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBAddShippingAddressVCDelegate
- (void)addShippingAddressVC:(FMBAddShippingAddressVC *)controller didSaveShippingAddress:(FMBShippingAddress *)shippingAddress
{
    [self printLogWith:@"addShippingAddressVC: didSaveShippingAddress"];
    
    [self.shippingAddressListView addShippingAddress:shippingAddress];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
