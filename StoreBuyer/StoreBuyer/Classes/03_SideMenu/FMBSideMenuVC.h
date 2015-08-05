//
//  FMBSideMenuVC.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBBackgroundUtil.h"

@class FMBSideMenuVC;
// ----------------------------------------------------------------------------------------
// FMBSideMenuVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMBSideMenuVCDelegate <NSObject>

- (void)sideMenuVCDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

// ----------------------------------------------------------------------------------------
// FMBSideMenuVC Class
// ----------------------------------------------------------------------------------------
@interface FMBSideMenuVC : UITableViewController<FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMBSideMenuVCDelegate> delegate;

@end
