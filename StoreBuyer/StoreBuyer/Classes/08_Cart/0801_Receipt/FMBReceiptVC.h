//
//  FMBReceiptVC.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RatingView.h"
#import "FMBBackgroundUtil.h"

@interface FMBReceiptVC : UITableViewController<RatingViewDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;
@property (strong, 	nonatomic)      NSString    *backgroundName;

// ----------------------------------------------------------------------------------------
@property (strong, nonatomic) PFObject *order;

// ----------------------------------------------------------------------------------------
@property (strong, nonatomic)          RatingView       *ratingview;
@property (weak,   nonatomic) IBOutlet UILabel          *labelTotalPrice;
@property (weak,   nonatomic) IBOutlet UILabel          *labelRatingViewBack;
@property (weak,   nonatomic) IBOutlet UITextView       *txtviewComment;

@end
