//
//  FMBMessageEmployeesVC.h
//  StoreBuyer
//
//  Created by Matti on 9/26/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBMessageEmployeesUtil.h"
#import "FMBEmployeeMessageVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBMessageEmployeesVC : UIViewController<UITableViewDataSource, UITableViewDelegate,FMBMessageEmployeesUtilDelegate, FMBBackgroundUtilDelegate>


// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UITableView          *tableview;

@end
