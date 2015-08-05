//
//  FMBMessageVC.h
//  StoreBuyer
//
//  Created by Matti on 9/8/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JSQMessages.h"

@interface FMBMessageVC : JSQMessagesViewController

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UIButton         *btnCustomerAvatar;
@property (weak,    nonatomic)     IBOutlet    UIButton         *btnReceiver;

// --------------------------------------------------------------------------------------
// Test Models Related Methods and Variables
// --------------------------------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *messages;
@property (copy,   nonatomic) NSDictionary   *avatars;

@property (strong, nonatomic) UIImageView    *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView    *incomingBubbleImageView;

- (void)setupTestModel;

@end
