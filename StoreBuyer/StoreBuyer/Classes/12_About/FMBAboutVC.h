//
//  FMBAboutVC.h
//  StoreBuyer
//
//  Created by Matti on 10/18/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBBackgroundUtil.h"
#import <MapKit/MapKit.h>

@interface FMBAboutVC : UITableViewController<FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UILabel     *labelCompanyName;
@property (weak,    nonatomic) IBOutlet UILabel     *labelCompanySlogan;
@property (weak,    nonatomic) IBOutlet UITextView  *textviewCompanyDescription;
@property (weak,    nonatomic) IBOutlet UILabel     *labelOpenHour;
@property (weak,    nonatomic) IBOutlet UILabel     *labelCloseHour;

@end
