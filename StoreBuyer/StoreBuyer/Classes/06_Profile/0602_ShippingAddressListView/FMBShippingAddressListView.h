//
//  FMBShippingAddressListView.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBShippingAddress.h"

@class FMBShippingAddressListView;
// -------------------------------------------------------------------------------------
// FMBShippingAddressListViewDelegate Protocol
// -------------------------------------------------------------------------------------
@protocol FMBShippingAddressListViewDelegate <NSObject>

- (void)shippingAddressListViewDidClickAddButton;

@end

// -------------------------------------------------------------------------------------
// FMBCardListView Class
// -------------------------------------------------------------------------------------
@interface FMBShippingAddressListView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

// -------------------------------------------------------------------------------------
@property (weak,    nonatomic)      id<FMBShippingAddressListViewDelegate> delegate;
@property (nonatomic)               BOOL                        bEdit;
@property (strong,  nonatomic)      UILabel                     *labelEmpty;

// -------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UICollectionView        *collectionview;

// -------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)addShippingAddress:(FMBShippingAddress *)address;

@end
