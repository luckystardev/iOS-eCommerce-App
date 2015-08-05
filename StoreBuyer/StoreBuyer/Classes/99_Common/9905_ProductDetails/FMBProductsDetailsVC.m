//
//  FMBProductsDetailsVC.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBProductsDetailsVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "ColorUtils.h"
#import "FMBBackgroundSetting.h"

@interface FMBProductsDetailsVC ()

@end

@implementation FMBProductsDetailsVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBProductsDetailsVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
        _imagelistview.product = _product;
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
    [self initContent];
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
    [self initViewBackground];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    _textviewDescription.backgroundColor = [UIColor clearColor];
    [FMBThemeManager setBorderToView:_textviewDescription width:1.f Color:COMMON_COLOR_FOR_BORDER];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

- (void)initContent
{
    [self printLogWith:@"initContent"];
    
    [_imagelistview configureViewWithData:_product];
    
    _labelTitle.text          = _product[kFMProductTitleKey];
    _labelCategory.text       = _product[kFMProductCategoryKey][kFMCategoryNameKey];
    _labelPrice.text          = [NSString stringWithFormat:@"$%.2f", [_product[kFMProductPriceKey] floatValue]];
    _labelQuantity.text       = [NSString stringWithFormat:@"%d", [_product[kFMProductQuantityKey] intValue]];
    _textviewDescription.text = _product[kFMProductDescriptionKey];
    
    if (_product[kFMProductColorKey])
    {
        _labelColor.backgroundColor  = [UIColor colorWithString:_product[kFMProductColorKey][kFMColorValueKey]];
        _labelColor.text = @"";
    }
    else
    {
        _labelColor.text = @"N/A";
        _labelColor.backgroundColor = [UIColor clearColor];
    }
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnAddToCart:(id)sender
{
    [self printLogWith:@"onBtnAddToCart"];
    
    self.addToCartPO = [FMBUtil showPOFromSender:[FMBUtil barButtonItemFromView:sender]
                                  contentVC_SBID:SBID_FMBADDTOCART_VC
                               contentVCDelegate:self
                               popOverVCDelegate:self
                                   contentVCRect:kAddToCartPORect
                                   fromBarButton:YES];
    
    FMBAddToCartVC *vc = (FMBAddToCartVC *)_addToCartPO.contentViewController;
    vc.product         = _product;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBAddToCartVCDelegate
- (void)addToCartVCDidClickAddButton
{
    [self printLogWith:@"addToCartVCDidClickAddButton"];
    
    [self.addToCartPO dismissPopoverAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - WYPopoverControllerDelegate Functions
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController
{
    [self printLogWith:@"popoverControllerShouldDismissPopover"];
    return YES;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    [self printLogWith:@"popoverControllerShouldIgnoreKeyboardBounds"];
    return NO;
}


@end
