//
//  FMBDeliveryMethodsView.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBDeliveryMethodsView.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBThemeManager.h"
#import "FMBUtil.h"
#import "FMBDeliveryMethodsCVCell.h"

#define CELLID                              @"DeliveryMethodsCell"

#define EMPTY_LABEL_TEXT                    @"No Delivery Method(s)"

@implementation FMBDeliveryMethodsView
{
    NSMutableArray *dataSource;
    NSInteger    selectedIndex;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBDeliveryMethodsView) return;
    
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
    
    self.backgroundColor            = [UIColor clearColor];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.backgroundView  = self.labelEmpty;
    
    _hud = [FMBUtil initHUDWithView:self];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    selectedIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kFMDeliveryMethodClassKey];
    
    [query orderByAscending:kFMDeliveryMethodSortOrderKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            if ([dataSource count]==0)
            {
                dataSource = [NSMutableArray array];
            }
            
            [dataSource addObjectsFromArray:objects];
            
            [_collectionview reloadData];
            
            [self layoutEmptyLabel];
        }
    }];
}

- (void)layoutEmptyLabel
{
    [self printLogWith:@"layoutEmptyLabel"];
    
    if ([dataSource count] > 0)
    {
        self.labelEmpty.text = @"";
    }
    else
    {
        self.labelEmpty.text = EMPTY_LABEL_TEXT;
    }
}

- (PFObject *)selectedDeliveryMethod
{
    return [self cellDataAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0]];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (void)changeCellSelected:(BOOL)bSelected atIndex:(NSInteger)index
{
    NSIndexPath *prevIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    FMBDeliveryMethodsCVCell *previousSelectedCell;
    previousSelectedCell = (FMBDeliveryMethodsCVCell *)[_collectionview cellForItemAtIndexPath:prevIndexPath];
    
    [previousSelectedCell changeColorWithSelected:bSelected];
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
    FMBDeliveryMethodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    [cell configureCellWithData:[self cellDataAtIndexPath:indexPath]];
    
    [cell changeColorWithSelected:indexPath.row == selectedIndex];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    
    [self changeCellSelected:NO atIndex:selectedIndex];
    [self changeCellSelected:YES atIndex:indexPath.row];
    
    selectedIndex = indexPath.row;
    
    [_delegate deliveryMethodsView:self selectDeliveryMethod:[self cellDataAtIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = (UICollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
