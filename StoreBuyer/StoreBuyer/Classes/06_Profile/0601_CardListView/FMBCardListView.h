//
//  FMBCardListView.h
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKCard.h"

@class FMBCardListView;
// -------------------------------------------------------------------------------------
// FMBCardListViewDelegate Protocol
// -------------------------------------------------------------------------------------
@protocol FMBCardListViewDelegate <NSObject>

- (void)cardListViewDidClickAddButton;

@end

// -------------------------------------------------------------------------------------
// FMBCardListView Class
// -------------------------------------------------------------------------------------
@interface FMBCardListView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

// -------------------------------------------------------------------------------------
@property (weak,    nonatomic)      id<FMBCardListViewDelegate> delegate;
@property (nonatomic)               BOOL                        bEdit;
@property (strong,  nonatomic)      UILabel                     *labelEmpty;

// -------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UICollectionView        *collectionview;

// -------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)addCard:(PKCard *)card;

@end
