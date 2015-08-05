//
//  FMBChooseShippingAddressVC.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBChooseShippingAddressVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBProfileUtil.h"
#import "FMBChooseShippingAddressCell.h"
#import "FMBBackgroundSetting.h"

#define CELLID_ADD                      @"AddCell"
#define CELLID_ADDRESS                  @"AddressCell"

#define SEGID_ADDSHIPPINGADDRESS        @"SEGID_AddShippingAddress"

@interface FMBChooseShippingAddressVC ()

@end

@implementation FMBChooseShippingAddressVC
{
    NSArray *dataSource;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBChooseShippingAddressVC) return;
    
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
    
    dataSource = [FMBProfileUtil shippingAddressList];
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

- (IBAction)onBtnAdd:(id)sender
{
    [self printLogWith:@"onBtnAdd"];
    
    [self performSegueWithIdentifier:SEGID_ADDSHIPPINGADDRESS sender:self];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_ADDSHIPPINGADDRESS])
    {
        FMBAddShippingAddressVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate = self;
        vc.backgroundName = _backgroundName;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBAddShippingAddressVCDelegate
- (void)addShippingAddressVC:(FMBAddShippingAddressVC *)controller didSaveShippingAddress:(FMBShippingAddress *)shippingAddress
{
    [self printLogWith:@"addShippingAddressVC: didSaveShippingAddress"];
    
    [_delegate chooseShippingAddressVC:self didSelectShippingAddress:shippingAddress];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Delegate Functions
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
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
    
    return 253.f;
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
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_ADD];
    }
    else
    {
        FMBChooseShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID_ADDRESS];
        
        [cell configureCellWithData:[self objectAtIndexPath:indexPath]];
        
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
        [self onBtnAdd:nil];
    }
    else
    {
        [self.delegate chooseShippingAddressVC:self didSelectShippingAddress:[self objectAtIndexPath:indexPath]];
    }
}

@end
