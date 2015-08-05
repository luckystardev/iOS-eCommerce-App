//
//  FMBScanVC.h
//  StoreBuyer
//
//  Created by Matti on 9/8/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMScannerView.h"
#import "FMBScanUtil.h"
#import "FMBScannedProductsVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBScanVC : UIViewController<RMScannerViewDelegate, UIAlertViewDelegate, FMBScanUtilDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet     UIView          *viewTopBar;
@property (weak,    nonatomic) IBOutlet     UIView          *viewTop1;
@property (weak,    nonatomic) IBOutlet     UIView          *viewTop2;
@property (weak,    nonatomic) IBOutlet     UIView          *viewBottomBar;
@property (weak,    nonatomic) IBOutlet     UIView          *viewMiddleBar;
@property (strong,  nonatomic) IBOutlet     RMScannerView   *scannerView;
@property (weak,    nonatomic) IBOutlet     UILabel         *statusText;
@property (strong,  nonatomic) IBOutlet     UIButton        *btnScan;

@property (weak,    nonatomic) IBOutlet     UILabel         *labelItemsCount;
@property (weak,    nonatomic) IBOutlet     UILabel         *labelTotalPrice;

@end
