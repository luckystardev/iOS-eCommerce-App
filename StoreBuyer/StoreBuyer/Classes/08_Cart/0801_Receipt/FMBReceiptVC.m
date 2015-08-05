//
//  FMBReceiptVC.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBReceiptVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"

@interface FMBReceiptVC ()

@end

@implementation FMBReceiptVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBReceiptVC) return;
    
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];

    [FMBUtil setupInputAccessoryViewWithButtonTitle:@"Set"
                                           selector:@selector(onBtnSetInInputAccessoryView:)
                                             target:self
                                         forControl:_txtviewComment];
    
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%.2f", [_order[kFMOrderTotalPriceKey] floatValue]];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
    [self initRatingView];
    
    [FMBThemeManager setBorderToView:_txtviewComment width:1.f Color:[UIColor whiteColor]];
    _txtviewComment.backgroundColor = RGBHEX(0xffffff, .2f);
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

- (void)initRatingView
{
    [self printLogWith:@"initRatingView"];
    
    self.labelRatingViewBack.backgroundColor = [UIColor clearColor];
    
    self.ratingview          = [FMBUtil initRatingViewWithFrame:self.labelRatingViewBack.frame];
    self.ratingview.delegate = self;
    
    [self.labelRatingViewBack.superview addSubview:self.ratingview];
    self.ratingview.value    = 5.f;
    
    self.ratingview.userInteractionEnabled = YES;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBBackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
    }
}


// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnSend:(id)sender
{
    [self printLogWith:@"onBtnSend"];
    if (![self doValidationProcess]) return;
    
    _order[kFMOrderReviewRateKey]       = @(_ratingview.value);
    _order[kFMOrderReviewCommentKey]    = _txtviewComment.text;
    
    [_order saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - TextView Delegate
- (void)onBtnSetInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnSetInInputAccessoryView"];
    
    [_txtviewComment resignFirstResponder];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - RatingViewDelegate
- (void)rateChanged:(RatingView *)sender
{
    [self printLogWith:@"rateChanged"];
    [self printLogWith:[NSString stringWithFormat:@"%.2f", sender.value]];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if ([FMBUtil isStringEmpty:_txtviewComment.text])
    {
        NSString *msg = @"Please leave your comment.";
        [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
        
        return NO;
    }
    
    if (_ratingview.value <= 0.f)
    {
        NSString *msg = @"Please give a rate for your order.";
        [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
        
        return NO;
    }
    
    return YES;
}

@end
