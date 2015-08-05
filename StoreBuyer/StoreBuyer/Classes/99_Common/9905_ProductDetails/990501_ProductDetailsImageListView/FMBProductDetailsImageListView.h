//
//  FMBProductDetailsImageListView.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMBProductDetailsImageListView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// ----------------------------------------------------------------------------------------
@property (strong,      nonatomic)  PFObject *product;

// ----------------------------------------------------------------------------------------
@property (weak,        nonatomic)  IBOutlet UICollectionView *collectionview1;
@property (weak,        nonatomic)  IBOutlet UICollectionView *collectionview2;

// ----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)configureViewWithData:(id)data;

@end
