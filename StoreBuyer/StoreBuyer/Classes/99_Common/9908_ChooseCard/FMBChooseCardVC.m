//
//  FMBChooseCardVC.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBChooseCardVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBProfileUtil.h"
#import "FMBChooseCardCell.h"
#import "FMBBackgroundSetting.h"

#define CELLID_SCAN          @"ScanCell"
#define CELLID_CARD          @"CardCell"

@interface FMBChooseCardVC ()

@end

@implementation FMBChooseCardVC
{
    NSArray *dataSource;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBChooseCardVC) return;
    
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
    [self initDataSource];
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

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    dataSource = [FMBProfileUtil cardList];
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
    
    PKCard *card    = [[PKCard alloc] init];
    card.number     = info.cardNumber;
    card.cvc        = info.cvv;
    card.expMonth   = info.expiryMonth;
    card.expYear    = info.expiryYear;
    card.addressZip = info.postalCode;
    
    [_delegate chooseCardVC:self didSelectCard:card];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Delegate Functions
- (PKCard *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 50.f;
    }
    
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *res;
    
    if (indexPath.section == 0)
    {
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_SCAN];
    }
    else
    {
        FMBChooseCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID_CARD];
        PKCard            *card = [self objectAtIndexPath:indexPath];
        
        [cell configureCellWithData:card];
        
        res = cell;
    }
    
    res.backgroundColor = [UIColor clearColor];
    
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView didSelectRowAtIndexPath"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        [self onBtnScan:nil];
    }
    else
    {
        PKCard *selectedCard = [self objectAtIndexPath:indexPath];
        [self.delegate chooseCardVC:self didSelectCard:selectedCard];
    }
}

@end
