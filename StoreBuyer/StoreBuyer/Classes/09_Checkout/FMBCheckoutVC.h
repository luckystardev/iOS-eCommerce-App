//
//  FMBCheckoutVC.h
//  StoreBuyer
//
//  Created by Matti on 9/8/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMBCheckoutVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ---------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet     UIView              *viewBack1;
@property (weak,    nonatomic) IBOutlet     UICollectionView    *collectionview;
@property (weak,    nonatomic) IBOutlet     UITableView         *tableview;

@end
