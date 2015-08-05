//
//  FMBPreviousOrdersVC.h
//  StoreBuyer
//
//  Created by Matti on 10/19/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBPreviousOrdersUtil.h"
#import "FMBPreviousOrdersCVCell.h"
#import "FMBReceiptVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBPreviousOrdersVC : UIViewController<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FMBPreviousOrdersCVCellDelegate, FMBPreviousOrdersUtilDelegate, FMBBackgroundUtilDelegate>
{
    BOOL bViewModeGrid;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UICollectionView     *collectionview;
@property (weak,    nonatomic)     IBOutlet    UISearchBar          *searchBar;
@property (weak,    nonatomic)     IBOutlet    UIButton             *btnViewMode;

@end
