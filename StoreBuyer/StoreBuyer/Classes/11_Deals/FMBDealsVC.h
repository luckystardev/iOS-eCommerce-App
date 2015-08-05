//
//  FMBDealsVC.h
//  StoreBuyer
//
//  Created by Matti on 9/8/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBDealsUtil.h"
#import "FMBDealsCVCell.h"
#import "FMBProductsDetailsVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBDealsVC : UIViewController<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FMBDealsUtilDelegate, FMBDealsCVCellDelegate, FMBBackgroundUtilDelegate>
{
    BOOL bViewModeGrid;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UICollectionView     *collectionview;
@property (weak,    nonatomic)     IBOutlet    UISearchBar          *searchBar;
@property (weak,    nonatomic)     IBOutlet    UIButton             *btnViewMode;

@end
