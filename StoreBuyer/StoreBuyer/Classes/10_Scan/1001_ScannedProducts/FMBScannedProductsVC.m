//
//  FMBScannedProductsVC.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBScannedProductsVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

#define CELLID                          @"ScannedProductsCell"

#define SEGID_PRODUCTDETAILS            @"SEGID_ProductDetails"

#define EMPTY_LABEL_TEXT                @"No Product(s)"

@interface FMBScannedProductsVC ()

@end

@implementation FMBScannedProductsVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBScannedProductsVC) return;
    
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
    [self layoutEmptyLabel];
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
    
    [self initViewBackground];

    [self.tableView.backgroundView addSubview:self.labelEmpty];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
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
#pragma mark - Empty Label Functions
- (UILabel *)labelEmpty
{
    [self printLogWith:@"emptyLabel"];
    
    if (!_labelEmpty)
    {
        UILabel *label = [[UILabel alloc] init];
        
        CGRect rect = self.tableView.frame;
        rect.origin = CGPointMake(0.f, 0.f);
        label.frame = rect;
        label.text  = EMPTY_LABEL_TEXT;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font          = COMMON_FONT_FOR_EMPTY_LISTVIEW_LABEL;
        label.textColor     = COMMON_COLOR_FOR_EMPTY_LISTVIEW_LABEL;
        
        _labelEmpty = label;
    }
    
    return _labelEmpty;
}

- (void)layoutEmptyLabel
{
    [self printLogWith:@"layoutEmptyLabel"];
    
    if ([_products count] > 0)
    {
        self.labelEmpty.text = @"";
    }
    else
    {
        self.labelEmpty.text = EMPTY_LABEL_TEXT;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_PRODUCTDETAILS])
    {
        FMBProductsDetailsVC *vc = [FMBUtil vcFromSegue:segue];
        vc.product               = sender;
        vc.backgroundName        = kFMBackgroundNameSettings;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBScannedProductsCellDelegate
- (void)scannedProductsCellDidClickAddToCart:(FMBScannedProductsCell *)cell
{
    [self printLogWith:@"scannedProductsCellDidClickAddToCart"];
    
    self.addToCartPO = [FMBUtil showPOFromSender:[FMBUtil barButtonItemFromView:cell.btnAddToCart]
                                  contentVC_SBID:SBID_FMBADDTOCART_VC
                               contentVCDelegate:self
                               popOverVCDelegate:self
                                   contentVCRect:kAddToCartPORect
                                   fromBarButton:YES];
    
    FMBAddToCartVC *vc = (FMBAddToCartVC *)_addToCartPO.contentViewController;
    vc.product         = [self objectAtIndexPath:[self.tableView indexPathForCell:cell]];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBAddToCartVCDelegate
- (void)addToCartVCDidClickAddButton
{
    [self printLogWith:@"addToCartVCDidClickAddButton"];
    
    [self.addToCartPO dismissPopoverAnimated:YES];
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Functions
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_products objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMBScannedProductsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    
    [cell configureCellWithData:[self objectAtIndexPath:indexPath]];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PFObject *product = [self objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:SEGID_PRODUCTDETAILS sender:product];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
