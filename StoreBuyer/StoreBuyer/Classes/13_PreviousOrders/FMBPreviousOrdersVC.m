//
//  FMBPreviousOrdersVC.m
//  StoreBuyer
//
//  Created by Matti on 10/19/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBPreviousOrdersVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

#define VIEW_MODE_SINGLE_IMAGE          @"00_singleview"
#define VIEW_MODE_GRID_IMAGE            @"00_gridview"

#define CELLID_SINGLECELL4              @"OrdersSingleCell4"
#define CELLID_SINGLECELL35             @"OrdersSingleCell35"
#define CELLID_GRIDCELL4                @"OrdersGridCell4"
#define CELLID_GRIDCELL35               @"OrdersGridCell35"
#define CELLID_LOADMORECELL             @"LoadMoreCell"

#define EMPTY_LABEL_TEXT                @"No Order(s) Found"

@interface FMBPreviousOrdersVC ()

@end

@implementation FMBPreviousOrdersVC
{
    NSMutableArray *dataSource;
    NSString       *searchString;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBPreviousOrdersVC) return;
    
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

// ---------------------------------------------------------------------------------------------------------------------
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initViewBackground];
    [self initSearchBar];
    
    _collectionview.backgroundView  = self.labelEmpty;
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameDashboard delegate:self];
    
    _collectionview.backgroundColor = [UIColor clearColor];
}

- (void)initSearchBar
{
    [self printLogWith:@"initSearchBar"];
    
    _searchBar.enablesReturnKeyAutomatically = NO;
    
    [FMBThemeManager makeTransparentSearchBar:_searchBar];
    
    [FMBUtil setupInputAccessoryViewWithButtonTitle:@"Cancel"
                                           selector:@selector(onBtnCancelInInputAccessoryView:)
                                             target:self
                                         forControl:_searchBar];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Empty Label Functions
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Source Functions
- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    [self sendRequest];
}

- (void)sendRequest
{
    [self printLogWith:@"sendRequest"];
    
    [FMBUtil showHUD:_hud withText:@""];
    
    [FMBPreviousOrdersUtil requestGetPreviousOrders:[dataSource count] searchString:_searchBar.text delegate:self];
}

- (void)sendRequestOnSettingsChanged
{
    [self printLogWith:@"sendRequestOnSettingsChanged"];
    
    [FMBUtil showHUD:_hud withText:@""];
    
    [dataSource removeAllObjects];
    [_collectionview reloadData];
    
    [FMBPreviousOrdersUtil requestGetPreviousOrders:[dataSource count] searchString:_searchBar.text delegate:self];
}

- (void)requestGetPreviousOrdersDidRespondWithOrders:(NSArray *)orders
{
    [self printLogWith:@"requestGetPreviousOrdersDidRespondWithOrders"];
    
    [_hud hide:YES];
    
    if ([FMBUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    [dataSource addObjectsFromArray:orders];
    [_collectionview reloadData];
    
    [self layoutEmptyLabel];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnMenu:(id)sender
{
    [self printLogWith:@"onBtnMenu"];
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (IBAction)onBtnViewMode:(id)sender
{
    [self printLogWith:@"onBtnViewMode"];
    
    bViewModeGrid = !bViewModeGrid;
    [self changeViewModeIntoGrid:bViewModeGrid];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UISearchBarDelegate
- (void)onBtnCancelInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnCancelInInputAccessoryView"];
    
    [_searchBar resignFirstResponder];
    
    _searchBar.text = searchString;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self printLogWith:@"searchBarSearchButtonClicked"];
    
    [_searchBar resignFirstResponder];
    
    searchString = _searchBar.text;
    [self sendRequestOnSettingsChanged];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Core Functions
- (void)changeViewModeIntoGrid:(BOOL)bGridViewMode
{
    [self printLogWith:@"changeViewModeIntoSingle"];
    
    NSString *imageName = bGridViewMode ? VIEW_MODE_SINGLE_IMAGE : VIEW_MODE_GRID_IMAGE;
    
    [FMBUtil setImageNamed:imageName toButton:_btnViewMode];
    
    [self.collectionview reloadData];
}

- (CGSize)cellSizeForIndexPath:(NSIndexPath *)indexPath
{
    CGSize res;
    
    if (indexPath.row == [dataSource count])
    {
        res = CGSizeMake(300.f, 50.f);
    }
    else if (bViewModeGrid)
    {
        if ([FMBUtil isRetina4])
        {
            res = CGSizeMake(150.f, 190.f);
        }
        else
        {
            res = CGSizeMake(150.f, 145.f);
        }
    }
    else
    {
        if ([FMBUtil isRetina4])
        {
            res = CGSizeMake(300.f, 380.f);
        }
        else
        {
            res = CGSizeMake(300.f, 295.f);
        }
    }
    return res;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString *res;
    
    if (indexPath.row == [dataSource count])
    {
        res = CELLID_LOADMORECELL;
    }
    else if (bViewModeGrid)
    {
        if ([FMBUtil isRetina4])
        {
            res = CELLID_GRIDCELL4;
        }
        else
        {
            res = CELLID_GRIDCELL35;
        }
    }
    else
    {
        if ([FMBUtil isRetina4])
        {
            res = CELLID_SINGLECELL4;
        }
        else
        {
            res = CELLID_SINGLECELL35;
        }
    }
    return res;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBPreviousOrdersCVCellDelegate Functions
- (BOOL)previousOrdersCVCellCheckViewModeGrid
{
    return bViewModeGrid;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([dataSource count] > 0)
    {
        return [dataSource count] + 1;
    }
    
    return [dataSource count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSizeForIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifierForIndexPath:indexPath]
                                                                           forIndexPath:indexPath];
    if (indexPath.row < [dataSource count])
    {
        PFObject                *product = [self objectAtIndexPath:indexPath];
        FMBPreviousOrdersCVCell *cell1   = (FMBPreviousOrdersCVCell *)cell;
        
        cell1.delegate = self;
        
        [cell1 configureCellWithData:product];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (indexPath.row == [dataSource count])
    {
        [self sendRequest];
    }
    else
    {
//        PFObject *order = [self objectAtIndexPath:indexPath];
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
