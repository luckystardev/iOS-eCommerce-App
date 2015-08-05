//
//  FMBProductDetailsImageListView.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBProductDetailsImageListView.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"

#define CELLID_BIG                      @"ImageListViewBigCell"
#define CELLID_SMALL                    @"ImageListViewSmallCell"

#define MAX_PRODUCT_IMAGES              5

@implementation FMBProductDetailsImageListView
{
    NSMutableArray *dataSource;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBProductDetailsImageListView) return;
    
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
#pragma mark - LifeCycle Functions
- (void)awakeFromNib
{
    [self printLogWith:@"awakeFromNib"];
    [super awakeFromNib];
    
    [self initUI];
    [self initDataSource];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    self.backgroundColor            = [UIColor clearColor];
    _collectionview1.backgroundColor = [UIColor clearColor];
    _collectionview2.backgroundColor = [UIColor clearColor];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    dataSource = _product[kFMProductImagesKey];
}

- (void)configureViewWithData:(id)data
{
    [self printLogWith:@"configureViewWithData"];
    
    _product = data;
    
    [self initDataSource];
    
    [_collectionview1 reloadData];
    [_collectionview2 reloadData];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (CGSize)cellSizeForCollectionView:(UICollectionView *)cv
{
    if (cv == _collectionview1)
    {
        return CGSizeMake(302, 302);
    }
    
    return CGSizeMake(60, 60);
}

- (NSString *)cellIDForCollectionView:(UICollectionView *)cv
{
    if (cv == _collectionview1)
    {
        return CELLID_BIG;
    }
    
    return CELLID_SMALL;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [dataSource count])
    {
        return [dataSource objectAtIndex:indexPath.row];
    }
    return nil;
}

- (PFImageView *)imageViewForCell:(UICollectionViewCell *)cell
{
    return (PFImageView *)[cell viewWithTag:105];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionview1)
    {
        return [dataSource count];
    }
    
    return MAX_PRODUCT_IMAGES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSizeForCollectionView:collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIDForCollectionView:collectionView]
                                                                           forIndexPath:indexPath];
    
    PFImageView *imageviewProduct = [self imageViewForCell:cell];
    
    imageviewProduct.image = nil;
    imageviewProduct.file  = [self objectAtIndexPath:indexPath];
    
    [imageviewProduct loadInBackground];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (collectionView == _collectionview2 && indexPath.row < dataSource.count)
    {
        [_collectionview1 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
