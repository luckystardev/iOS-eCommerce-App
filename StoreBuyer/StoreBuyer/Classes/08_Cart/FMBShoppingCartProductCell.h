//
//  FMBShoppingCartProductCell.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FMBShoppingCartProductCell;
// ----------------------------------------------------------------------------------------
// FMBShoppingCartProductCellDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMBShoppingCartProductCellDelegate <NSObject>

- (id)shoppingCartProductCellGetPrdouctData:(FMBShoppingCartProductCell *)cell;
- (void)shoppingCartProductCell:(FMBShoppingCartProductCell *)cell didUpdateQuantity:(int)quantity;

@end

// ----------------------------------------------------------------------------------------
// FMBShoppingCartProductCell Class
// ----------------------------------------------------------------------------------------
@interface FMBShoppingCartProductCell : UITableViewCell

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet id<FMBShoppingCartProductCellDelegate> delegate;

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UILabel     *labelUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel     *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel     *labelProductTitle;
@property (weak, nonatomic) IBOutlet PFImageView *imageviewProduct;
@property (weak, nonatomic) IBOutlet UIButton    *btnRemove;

// ----------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
