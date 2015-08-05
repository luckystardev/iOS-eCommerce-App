//
//  FMBUserSetting.h
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMBUserSetting : NSObject<NSCoding>

// --------------------------------------------------------------------------------------
@property (nonatomic)           CGFloat         price1;
@property (nonatomic)           CGFloat         price2;
@property (strong,  nonatomic)  NSString        *searchString;
@property (strong,  nonatomic)  NSMutableArray  *checkedCategoryIdList;
@property (nonatomic)           int             browseMode;
@property (nonatomic)           BOOL            bChanged;

// --------------------------------------------------------------------------------------
#pragma mark - Singleton Mehtod
+ (id)sharedInstance;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)store;

@end
