//
//  FMBFilterCategoryVC.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class FMBFilterCategoryVC;
// ----------------------------------------------------------------------------------------
// FMBFilterCategoryVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMBFilterCategoryVCDelegate <NSObject>

- (void)filterCategoryVCDidCancel;
- (void)filterCategoryVCDidSearch;

@end

// ----------------------------------------------------------------------------------------
// FMBFilterCategoryVC Class
// ----------------------------------------------------------------------------------------
@interface FMBFilterCategoryVC : UIViewController

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMBFilterCategoryVCDelegate> delegate;

@property (strong,  nonatomic) MBProgressHUD               *hud;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UIButton           *btnCheckAll;
@property (weak,    nonatomic) IBOutlet UICollectionView   *collectionview;
@end
