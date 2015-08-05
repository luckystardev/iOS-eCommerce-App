//
//  FMBBrowseVC.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "WYPopoverController.h"
#import "FMBSocialShareVC.h"
#import "FMBShareUtil.h"
#import "FMBBrowseCVCell.h"
#import "FMBPriceRangeVC.h"
#import "FMBFilterCategoryVC.h"
#import "FMBSignupVC.h"
#import "FMBBrowseUtil.h"
#import "FMBProductsDetailsVC.h"
#import "FMBAddToCartVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBBrowseVC : UIViewController<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, WYPopoverControllerDelegate, FMBSocialShareVCDelegate, FMBBrowseCVCellDelegate, FMBPriceRangeVCDelegate, FMBFilterCategoryVCDelegate, FMBBrowseUtilDelegate, FMBAddToCartVCDelegate, FMBShareUtilDelegate, MFMailComposeViewControllerDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong,  nonatomic) NSTimer     *timerBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) MBProgressHUD *hud;
@property (strong,  nonatomic) UILabel       *labelEmpty;

@property (strong,  nonatomic)          UISearchBar         *searchBar;
@property (weak,    nonatomic) IBOutlet UIBarButtonItem     *barBtnViewMode;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UICollectionView    *collectionview;
@property (weak,    nonatomic) IBOutlet UIToolbar           *toolbar;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) WYPopoverController       *socialSharePO;
@property (strong,  nonatomic) WYPopoverController       *priceRangePO;
@property (strong,  nonatomic) WYPopoverController       *filterCategoryPO;
@property (strong,  nonatomic) WYPopoverController       *addToCartPO;

@end
