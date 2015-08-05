//
//  FMBScanVC.m
//  StoreBuyer
//
//  Created by Matti on 9/8/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBScanVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

#define SEGID_CART                          @"SEGID_Cart"
#define SEGID_SCANNEDPRODUCTS               @"SEGID_ScannedProducts"

@interface FMBScanVC ()

@end

@implementation FMBScanVC
{
    NSMutableArray *products;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBScanVC) return;
    
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
    [self setupTestModel];
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
    
    [self updateLabelsOfItemsCountAndTotalPrice];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
    [self initNavigationBar];
    [self initTopBar];
    [self initBottomBar];
    [self initScannerView];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
}

- (void)initNavigationBar
{
    [self printLogWith:@"initNavigationBar"];
    
    UIImage *blurredImage = [FMBThemeManager blurImageForMainPageNavigationBarByImage:[[FMBBackgroundSetting sharedInstance] imageForBackgroundName:kFMBackgroundNameSettings]];
    
    [self.navigationController.navigationBar setBackgroundImage:blurredImage
                                                  forBarMetrics:UIBarMetricsDefault];

    
    self.navigationController.navigationBarHidden = YES;
}

- (void)initTopBar
{
    [self printLogWith:@"initTopBar"];
    
    _viewTopBar.backgroundColor = [UIColor clearColor];
    
    [FMBThemeManager setBorderToView:_viewTop1 width:1.f Color:[UIColor lightGrayColor]];
    [FMBThemeManager setBorderToView:_viewTop2 width:1.f Color:[UIColor lightGrayColor]];
}

- (void)initBottomBar
{
    [self printLogWith:@"initBottomBar"];
    
    _viewBottomBar.backgroundColor = [UIColor clearColor];
    
    [FMBThemeManager makeCircleWithView:_btnScan borderColor:[UIColor lightGrayColor] borderWidth:1.f];
}

- (void)initScannerView
{
    [self printLogWith:@"initScannerView"];
    
    _viewMiddleBar.backgroundColor = [UIColor clearColor];
    
    [_scannerView setVerboseLogging:YES];
    [_scannerView setAnimateScanner:YES];
    [_scannerView setDisplayCodeOutline:YES];
    
    [_scannerView startCaptureSession];
    [_btnScan setSelected:YES];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
- (void)setupTestModel
{
    [self printLogWith:@"setupTestModel"];
    
    NSArray *dataSource = @[@"1PMC914LL/B", @"9780393301588", @"9000303", @"0705487181418", @"6901028137126"];
    
    for (NSString *barcode in dataSource)
    {
        [FMBScanUtil requestGetProductByBarcode:barcode delegate:self];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnCancel:(id)sender
{
    [self printLogWith:@"onBtnCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnView:(id)sender
{
    [self printLogWith:@"onBtnView"];
}

- (IBAction)onBtnScan:(id)sender
{
    [self printLogWith:@"onBtnScan"];
    
    if ([_scannerView isScanSessionInProgress])
    {
        [_scannerView stopScanSession];
        [_btnScan setSelected:NO];
    } else
    {
        [_scannerView startScanSession];
        [_btnScan setSelected:YES];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_CART])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_SCANNEDPRODUCTS])
    {
        FMBScannedProductsVC *vc = [FMBUtil vcFromSegue:segue];
        vc.products = products;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - RMScannerViewDelegate
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType
{
    [self printLogWith:@"Scanner-didScanCode"];
    
    [FMBScanUtil requestGetProductByBarcode:scannedCode delegate:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_btnScan setSelected:NO];
    });
}

- (void)errorGeneratingCaptureSession:(NSError *)error
{
    [self printLogWith:@"Scanner-errorGeneratingCaptureSession"];
    
    [_scannerView stopCaptureSession];
    
    [[FMBUtil generalAlertWithTitle:@"Unsupported Device"
                            message:@"This device does not have a camera. Run this app on an iOS device that has a camera."
                           delegate:self] show];
    
    _statusText.text = @"Unsupported Device";
    
    [_btnScan setTitle:@"Scan" forState:UIControlStateNormal];
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error
{
    [self printLogWith:@"Scanner-errorAcquiringDeviceHardwareLock"];
    
    [[FMBUtil generalAlertWithTitle:@"Focus Unavailable"
                            message:@"Tap to focus is currently unavailable. Try again in a little while."
                           delegate:nil] show];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan
{
    return YES;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBScanUtilDelegate
- (void)updateLabelsOfItemsCountAndTotalPrice
{
    [self printLogWith:@"updateLabelsOfItemsCountAndTotalPrice"];
    
    _labelItemsCount.text = [NSString stringWithFormat:@"%ld", (long)[products count]];
    _labelTotalPrice.text = [NSString stringWithFormat:@"%.2f", [FMBScanUtil totalPriceFromProducts:products]];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBScanUtilDelegate
- (void)requestGetProductByBarcodeDidRespondWithProduct:(id)product
{
    [self printLogWith:@"requestGetProductByBarcodeDidRespondWithProduct"];
    if ([FMBUtil isObjectEmpty:product]) return;
    
    if ([products count] == 0)
    {
        products = [NSMutableArray array];
    }
    
    [products addObject:product];
    
    [self updateLabelsOfItemsCountAndTotalPrice];
}

@end
