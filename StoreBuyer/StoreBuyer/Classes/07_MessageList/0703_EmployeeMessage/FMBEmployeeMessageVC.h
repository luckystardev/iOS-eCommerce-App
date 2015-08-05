//
//  FMBEmployeeMessageVC.h
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JSQMessages.h"
#import "FMBEmployeeMessageUtil.h"
#import "FMBBackgroundUtil.h"

@interface FMBEmployeeMessageVC : JSQMessagesViewController<FMBEmployeeMessageUtilDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong, 	nonatomic) NSString    *backgroundName;

// ----------------------------------------------------------------------------------
@property (strong, nonatomic) NSTimer           *timer;
@property (nonatomic)         BOOL              bRegularLoading;
@property (nonatomic)         BOOL              bTimerLoading;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;
@property (strong,  nonatomic)      PFUser        *other;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UIButton         *btnCustomerAvatar;
@property (weak,    nonatomic)     IBOutlet    UIButton         *btnReceiver;

// ----------------------------------------------------------------------------------
// Test Models Related Methods and Variables
// ----------------------------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *messages;
@property (copy,   nonatomic) NSDictionary   *avatars;

@property (strong, nonatomic) UIImageView    *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView    *incomingBubbleImageView;

- (void)setupTestModel;

@end
