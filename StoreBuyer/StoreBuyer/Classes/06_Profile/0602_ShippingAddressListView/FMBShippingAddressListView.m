//
//  FMBShippingAddressListView.m
//  StoreBuyer
//
//  Created by Matti on 9/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBShippingAddressListView.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBShippingAddressListCVCell.h"
#import "FMBProfileUtil.h"

#define CELLID                                      @"ShippingAddressListCVCell"
#define EMPTY_LABEL_TEXT                            @"No Shipping Address(es)"
#define MESSAGE_SHIPPING_ADDRESS_DELETE             @"Are you sure you want to delete this shipping address?"
#define TAG_ALERTVIEW_SHIPPDING_ADDRESS_DELETE      107

@implementation FMBShippingAddressListView
{
    NSMutableArray *_addressList;
    NSIndexPath    *_indexPathDeleting;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBShippingAddressListView) return;
    
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
    
    [self layoutEmptyLabel];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    
    _collectionview.backgroundView  = self.labelEmpty;
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    _addressList = [FMBProfileUtil shippingAddressList];
}

- (void)addShippingAddress:(FMBShippingAddress *)address;
{
    [self printLogWith:@"addCard"];
    
    [_addressList addObject:address];
    [_collectionview reloadData];
    
    if ([_addressList count] == 1)
    {
        [self layoutEmptyLabel];
    }
}

- (void)deleteShippingAddressAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"deleteShippingAddressAtIndexPath"];
    
    [_addressList removeObjectAtIndex:indexPath.row];
    [_collectionview reloadData];
    
    [FMBProfileUtil deleteShippingAddressByIndex:indexPath.row];
    
    if ([_addressList count] == 0)
    {
        [self layoutEmptyLabel];
        
        self.bEdit = !self.bEdit;
    }
}

- (void)layoutEmptyLabel
{
    [self printLogWith:@"layoutEmptyLabel"];
    
    if ([_addressList count] > 0)
    {
        self.labelEmpty.text = @"";
    }
    else
    {
        self.labelEmpty.text = EMPTY_LABEL_TEXT;
    }
}

- (UILabel *)labelEmpty
{
    [self printLogWith:@"emptyLabel"];
    
    if (!_labelEmpty)
    {
        UILabel *label = [[UILabel alloc] init];
        
        CGRect rect = _collectionview.frame;
        rect.origin = CGPointMake(0.f, 0.f);
        label.frame = rect;
        label.text  = EMPTY_LABEL_TEXT;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font          = COMMON_FONT_FOR_EMPTY_LISTVIEW_LABEL;
        label.textColor     = COMMON_COLOR_FOR_EMPTY_LISTVIEW_LABEL;
        
        _labelEmpty = label;
    }
    
    return _labelEmpty;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnAdd:(id)sender
{
    [self printLogWith:@"onBtnAdd"];
    
    [_delegate shippingAddressListViewDidClickAddButton];
}

- (IBAction)onBtnTrash:(id)sender
{
    [self printLogWith:@"onBtnTrash"];
    
    self.bEdit = !self.bEdit;
    [_collectionview reloadData];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self printLogWith:@"alertView clickedButtonAtIndex"];
    
    if (buttonIndex == 1)
    {
        if (alertView.tag == TAG_ALERTVIEW_SHIPPDING_ADDRESS_DELETE)
        {
            [self deleteShippingAddressAtIndexPath:_indexPathDeleting];
        }
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (FMBShippingAddress *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_addressList objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_addressList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMBShippingAddressListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    FMBShippingAddress *address = [self objectAtIndexPath:indexPath];
    
    [cell configureCellWithData:address isEditMode:self.bEdit];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (self.bEdit)
    {
        UIAlertView *alertView = [FMBUtil okCancelAlertWithTitle:nil
                                                         message:MESSAGE_SHIPPING_ADDRESS_DELETE
                                                         OkTitle:nil CancelTitle:nil delegate:self];
        alertView.tag = TAG_ALERTVIEW_SHIPPDING_ADDRESS_DELETE;
        [alertView show];
        
        _indexPathDeleting = indexPath;
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
