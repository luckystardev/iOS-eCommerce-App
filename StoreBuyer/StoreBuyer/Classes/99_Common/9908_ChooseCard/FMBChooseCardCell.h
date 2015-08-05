//
//  FMBChooseCardCell.h
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBChooseCardCell : UITableViewCell

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIImageView *imageviewCard;
@property (weak, nonatomic) IBOutlet UILabel     *labelCardNumber;
@property (weak, nonatomic) IBOutlet UILabel     *labelExpDate;

// ----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
