//
//  FMBChooseCardVC.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"
#import "PKCard.h"
#import "FMBBackgroundUtil.h"

@class FMBChooseCardVC;
// --------------------------------------------------------------------------------
// FMBChooseCardVCDelegate Protocol
// --------------------------------------------------------------------------------
@protocol FMBChooseCardVCDelegate <NSObject>

- (void)chooseCardVC:(FMBChooseCardVC *)controller didSelectCard:(PKCard *)card;

@end

// --------------------------------------------------------------------------------
// FMBChooseCardVC Class
// --------------------------------------------------------------------------------
@interface FMBChooseCardVC : UITableViewController<CardIOPaymentViewControllerDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong, 	nonatomic) NSString    *backgroundName;

// --------------------------------------------------------------------------------
@property (weak,      nonatomic)   id<FMBChooseCardVCDelegate> delegate;

@end
