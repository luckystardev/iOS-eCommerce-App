//
//  FMBPriceRangeVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBPriceRangeVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBUserSetting.h"

@interface FMBPriceRangeVC ()

@end

@implementation FMBPriceRangeVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBPriceRangeVC) return;
    
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
    
    [self updateLabels];
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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initSlider];
}

- (void)initSlider
{
    [self printLogWith:@"initSlider"];
    
    [FMBUtil setupRangeSlider:self.rangesliderPrice minValue:MIN_PRICE maxValue:MAX_PRICE];
    
    self.rangesliderPrice.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    FMBUserSetting *userSetting = [FMBUserSetting sharedInstance];
    
    _rangesliderPrice.rightValue    = userSetting.price2;
    _rangesliderPrice.leftValue     = userSetting.price1;
    
    [self updateLabels];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Range Slider Change Event
- (IBAction)onPriceRangeSliderChanged:(ACVRangeSelector *)sender
{
    [self printLogWith:@"onPriceRangeSliderChanged"];
    
    [self updateLabels];
    
    FMBUserSetting *userSetting = [FMBUserSetting sharedInstance];
    
    userSetting.price1   = _rangesliderPrice.leftValue;
    userSetting.price2   = _rangesliderPrice.rightValue;
    
    userSetting.bChanged = YES;
}

- (void)updateLabels
{
    [self printLogWith:@"updateLabels"];
    
    self.labelMin.text = [NSString stringWithFormat:@"$%.0f", self.rangesliderPrice.leftValue];
    
    if (self.rangesliderPrice.rightValue >= MAX_PRICE)
    {
        self.labelMax.text = [NSString stringWithFormat:@"$%.0f+", self.rangesliderPrice.rightValue];
    }
    else
    {
        self.labelMax.text = [NSString stringWithFormat:@"$%.0f", self.rangesliderPrice.rightValue];
    }
}

@end
