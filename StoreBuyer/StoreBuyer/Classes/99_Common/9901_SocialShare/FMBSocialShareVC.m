//
//  FMBSocialShareVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBSocialShareVC.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBImageCaptionCVCell.h"

#define CELLID_SOCIALSHARE @"SocialShareCell"

@interface FMBSocialShareVC ()

@end

@implementation FMBSocialShareVC
{
    NSArray *dataSource;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBSocialShareVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initDataSource];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    self.view.backgroundColor           = [UIColor clearColor];
    self.collectionview.backgroundColor = [UIColor clearColor];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    dataSource = @[@{kFMBCellDataTitleKey:@"Facebook",   kFMBCellDataImageIconKey:@"0001_facebook"},
                   @{kFMBCellDataTitleKey:@"Contacts",   kFMBCellDataImageIconKey:@"0001_contacts"},
                   @{kFMBCellDataTitleKey:@"Twitter",    kFMBCellDataImageIconKey:@"0001_twitter"},
                   @{kFMBCellDataTitleKey:@"FlypBox",    kFMBCellDataImageIconKey:@"0001_flyp"},
                   @{kFMBCellDataTitleKey:@"Email",      kFMBCellDataImageIconKey:@"0001_email"},];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMBImageCaptionCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID_SOCIALSHARE forIndexPath:indexPath];
    
    [cell configureCellWithData:[self cellDataAtIndexPath:indexPath]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (indexPath.row == 0)
    {
        [_delegate socialShareVCDidClickShareType:FMB_SHARE_TYPE_FACEBOOK];
    }
    if (indexPath.row == 1)
    {
        [_delegate socialShareVCDidClickShareType:FMB_SHARE_TYPE_CONTACTS];
    }
    if (indexPath.row == 2)
    {
        [_delegate socialShareVCDidClickShareType:FMB_SHARE_TYPE_TWITTER];
    }
    if (indexPath.row == 3)
    {
        [_delegate socialShareVCDidClickShareType:FMB_SHARE_TYPE_APP];
    }
    if (indexPath.row == 4)
    {
        [_delegate socialShareVCDidClickShareType:FMB_SHARE_TYPE_EMAIL];
    }

}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
