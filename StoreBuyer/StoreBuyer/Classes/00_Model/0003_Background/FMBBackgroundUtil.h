//
//  FMBBackgroundUtil.h
//  StoreBuyer
//
//  Created by Matti on 10/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// ---------------------------------------------------------------------------------------
// FMBBackgroundUtilDelegate Protocol
// ---------------------------------------------------------------------------------------
@protocol  FMBBackgroundUtilDelegate<NSObject>

- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew;

@end

// ---------------------------------------------------------------------------------------
// FMBBackgroundUtil Class
// ---------------------------------------------------------------------------------------
@interface FMBBackgroundUtil : NSObject

// ---------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)imagePathDir;
+ (NSDictionary *)notificationObjectWithImage:(UIImage *)image forBackgroundName:(NSString *)backgroundName;

// ---------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestBackgroundForName:(NSString *)backgroundName
                        delegate:(id<FMBBackgroundUtilDelegate>)delegate;

@end
