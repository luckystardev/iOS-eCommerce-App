//
//  FMBBrowseVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBBrowseVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBUserSetting.h"
#import "FMBBackgroundSetting.h"

#define VIEW_MODE_SINGLE_IMAGE          @"00_singleview"
#define VIEW_MODE_GRID_IMAGE            @"00_gridview"
#define VIEW_MODE_LINE_IMAGE            @"00_lineview"

#define CELLID_BROWSE_SINGLECELL4       @"BrowseSingleCell4"
#define CELLID_BROWSE_SINGLECELL35      @"BrowseSingleCell35"
#define CELLID_BROWSE_GRIDCELL4         @"BrowseGridCell4"
#define CELLID_BROWSE_GRIDCELL35        @"BrowseGridCell35"
#define CELLID_BROWSE_LINECELL          @"BrowseLineCell"
#define CELLID_BROWSE_LOADMORECELL      @"BrowseLoadMoreCell"

#define EMPTY_LABEL_TEXT                @"No Matched Result(s) Found"

#define SEGID_PRODUCTDETAILS            @"SEGID_ProductDetails"

// Interval in seconds to check if need to sync (keeps checking at this interval until successful sync)
#define CHECK_BACKGROUND_INTERVAL 60.0

@interface FMBBrowseVC ()

@end

@implementation FMBBrowseVC
{
    NSMutableArray *dataSource;
    NSIndexPath    *indexPathToShare;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBBrowseVC) return;
    
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
    
    [self unregisterNotifications];
    
    [self invalidateTimer];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initDataSource];
    [self registerNotifications];
    [self startTimer];
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
    
    [self initViewBackground];
    
    [self initNavigationBar];
    [self initSearchBar];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.backgroundView  = self.labelEmpty;
    
    [self changeViewMode:[[FMBUserSetting sharedInstance] browseMode]];
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForVC:self withBottomBar:_toolbar];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameStore toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameStore delegate:self];
}

- (void)initNavigationBar
{
    [self printLogWith:@"initNavigationBar"];
    
    // Init left bar items
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"00_menu"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(onBtnMenu:)];
    item1.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"02_circle_dollar"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(onBtnPrice:)];
    item2.tintColor = [UIColor whiteColor];
    
    NSArray* items = @[item1, item2];
    [self.navigationItem setLeftBarButtonItems:items animated:NO];
}

- (void)initSearchBar
{
    [self printLogWith:@"initSearchBar"];
    
    _searchBar               = [[UISearchBar alloc] init];
    _searchBar.delegate      = self;
    _searchBar.placeholder   = @"Search";
    _searchBar.enablesReturnKeyAutomatically = NO;
    
    self.navigationItem.titleView = _searchBar;
    
    [FMBUtil setupInputAccessoryViewWithButtonTitle:@"Cancel"
                                           selector:@selector(onBtnCancelInInputAccessoryView:)
                                             target:self
                                         forControl:_searchBar];
    
    _searchBar.text          = [[FMBUserSetting sharedInstance] searchString];
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Background Change Check Timer Functions
- (void)startTimer
{
    [self printLogWith:@"startTimer"];
    
    _timerBackground = [NSTimer scheduledTimerWithTimeInterval:CHECK_BACKGROUND_INTERVAL
                                                        target:self
                                                      selector:@selector(sendRequestForBackground:)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)invalidateTimer
{
    [self printLogWith:@"invalidateTimer"];
    
    [_timerBackground invalidate];
    _timerBackground = nil;
}

- (void)sendRequestForBackground:(id)sender
{
    [self printLogWith:@"sendRequestForBackground"];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameStore delegate:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameStore toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Notification Functions
- (void)registerNotifications
{
    [self printLogWith:@"registerNotifications"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundImageChanged:)
                                                 name:FMBBackgroundSettingDidUpdateNotification object:nil];
}

- (void)unregisterNotifications
{
    [self printLogWith:@"unregisterNotifications"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FMBBackgroundSettingDidUpdateNotification object:nil];
}

- (void)backgroundImageChanged:(NSNotification *)note
{
    [self printLogWith:@"backgroundImageChanged"];
    
    if ([note.object[kFMBackgroundNameKey] isEqualToString:kFMBackgroundNameStore])
    {
        if ([note.object objectForKey:kFMBackgroundImageKey])
        {
            [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameStore toImageView:_imageviewBackground];
        }
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
    
    [FMBBrowseUtil requestGetProductsInBrowsePageWithFilterParams:[dataSource count] delegate:self];
}

- (void)sendRequestOnSettingsChanged
{
    [self printLogWith:@"sendRequestOnSettingsChanged"];
    
    [FMBUtil showHUD:_hud withText:@""];
    
    [dataSource removeAllObjects];
    [_collectionview reloadData];
    
    [FMBBrowseUtil requestGetProductsInBrowsePageWithFilterParams:[dataSource count] delegate:self];
}

- (void)requestGetProductsInBrowsePageWithFilterParamsDidRespondWithProducts:(NSArray *)products
{
    [self printLogWith:@"requestGetProductsInBrowsePageWithFilterParamsDidRespondWithProducts"];
    
    [_hud hide:YES];
    
    if ([FMBUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    [dataSource addObjectsFromArray:products];
    [_collectionview reloadData];
    
    [self layoutEmptyLabel];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnMenu:(id)sender
{
    [self printLogWith:@"onBtnMenu"];
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (IBAction)onBtnPrice:(id)sender
{
    [self printLogWith:@"onBtnPrice"];
    
    self.priceRangePO = [FMBUtil showPOFromSender:sender
                                   contentVC_SBID:SBID_FMBPRICERANGE_VC
                                contentVCDelegate:self
                                popOverVCDelegate:self
                                    contentVCRect:kPriceRangePORect
                                    fromBarButton:YES];
}

- (IBAction)onBtnFilterCategory:(id)sender
{
    [self printLogWith:@"onBtnFilterCategory"];
    
    self.filterCategoryPO = [FMBUtil showPOFromSender:sender
                                       contentVC_SBID:SBID_FMBFILTERCATEGORY_VC
                                    contentVCDelegate:self
                                    popOverVCDelegate:self
                                        contentVCRect:kFilterCategoryPORect
                                        fromBarButton:YES];
}

- (IBAction)onBtnViewMode:(id)sender
{
    [self printLogWith:@"onBtnViewMode"];
    
    FMBUserSetting *settings = [FMBUserSetting sharedInstance];
    settings.browseMode = (settings.browseMode + 1) % 3;
    [[FMBUserSetting sharedInstance] store];
    
    [self changeViewMode:settings.browseMode];}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Core Functions
- (void)changeViewMode:(int)browseMode
{
    [self printLogWith:@"changeViewMode"];
    
    NSArray *imagenames = @[VIEW_MODE_GRID_IMAGE, VIEW_MODE_LINE_IMAGE, VIEW_MODE_SINGLE_IMAGE];
    
    [self.barBtnViewMode setImage:[UIImage imageNamed:imagenames[browseMode]]];
    
    [self.collectionview reloadData];
}


- (CGSize)cellSizeForIndexPath:(NSIndexPath *)indexPath
{
    FMBUserSetting *settings = [FMBUserSetting sharedInstance];
    
    CGSize res;
    
    if (indexPath.row == [dataSource count])
    {
        res = CGSizeMake(290.f, 50.f);
    }
    else if (settings.browseMode == FMB_BROWSE_MODE_GRID)
    {
        if ([FMBUtil isRetina4])
        {
            res = CGSizeMake(140.f, 210.f);
        }
        else
        {
            res = CGSizeMake(140.f, 170.f);
        }
    }
    else if (settings.browseMode == FMB_BROWSE_MODE_SINGLE)
    {
        if ([FMBUtil isRetina4])
        {
            res = CGSizeMake(290.f, 430.f);
        }
        else
        {
            res = CGSizeMake(290.f, 350.f);
        }
    }
    else if (settings.browseMode == FMB_BROWSE_MODE_LINE)
    {
        res = CGSizeMake(290.f, 125.f);
    }
    return res;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    FMBUserSetting *settings = [FMBUserSetting sharedInstance];
    
    NSString *res;
    if (indexPath.row == [dataSource count])
    {
        res = CELLID_BROWSE_LOADMORECELL;
    }
    else if (settings.browseMode == FMB_BROWSE_MODE_GRID)
    {
        if ([FMBUtil isRetina4])
        {
            res = CELLID_BROWSE_GRIDCELL4;
        }
        else
        {
            res = CELLID_BROWSE_GRIDCELL35;
        }
    }
    else if(settings.browseMode == FMB_BROWSE_MODE_SINGLE)
    {
        if ([FMBUtil isRetina4])
        {
            res = CELLID_BROWSE_SINGLECELL4;
        }
        else
        {
            res = CELLID_BROWSE_SINGLECELL35;
        }
    }
    else if (settings.browseMode == FMB_BROWSE_MODE_LINE)
    {
        res = CELLID_BROWSE_LINECELL;
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBBrowseCVCellDelegate
- (void)browseCVCellDidClickShare:(FMBBrowseCVCell *)cell
{
    [self printLogWith:@"browseCVCellDidClickShare"];
    
    indexPathToShare = [_collectionview indexPathForCell:cell];
    
    self.socialSharePO = [FMBUtil showPOFromSender:[FMBUtil barButtonItemFromView:cell.btnShare]
                                    contentVC_SBID:SBID_FMBSOCIALSHARE_VC
                                 contentVCDelegate:self
                                 popOverVCDelegate:self
                                     contentVCRect:kSocialSharePORect
                                     fromBarButton:YES];
}

- (void)browseCVCellDidClickCart:(FMBBrowseCVCell *)cell
{
    self.addToCartPO = [FMBUtil showPOFromSender:[FMBUtil barButtonItemFromView:cell.btnCart]
                                    contentVC_SBID:SBID_FMBADDTOCART_VC
                                 contentVCDelegate:self
                                 popOverVCDelegate:self
                                     contentVCRect:kAddToCartPORect
                                     fromBarButton:YES];
    
    FMBAddToCartVC *vc = (FMBAddToCartVC *)_addToCartPO.contentViewController;
    vc.product         = [self objectAtIndexPath:[_collectionview indexPathForCell:cell]];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TextFields Functions
- (void)onBtnCancelInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnCancelInInputAccessoryView"];
    
    [_searchBar resignFirstResponder];
    
    _searchBar.text = [[FMBUserSetting sharedInstance] searchString];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self printLogWith:@"searchBarSearchButtonClicked"];
    
    [_searchBar resignFirstResponder];
    
    FMBUserSetting *userSetting = [FMBUserSetting sharedInstance];
    
    if (![userSetting.searchString isEqualToString:_searchBar.text])
    {
        userSetting.searchString = _searchBar.text;
        [userSetting store];
        
        [self sendRequestOnSettingsChanged];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBFilterCategoryVCDelegate
- (void)filterCategoryVCDidCancel
{
    [self printLogWith:@"filterCategoryVCDidCancel"];
    
    [self.filterCategoryPO dismissPopoverAnimated:YES];
}

- (void)filterCategoryVCDidSearch
{
    [self printLogWith:@"filterCategoryVCDidSearch"];
    
    [self.filterCategoryPO dismissPopoverAnimated:YES];
    
    [self sendRequestOnSettingsChanged];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBSocialShareVCDelegate
- (void)socialShareVCDidCancel
{
    [self printLogWith:@"socialShareVCDidCancel"];
    
    [self.socialSharePO dismissPopoverAnimated:YES];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBAddToCartVCDelegate
- (void)addToCartVCDidClickAddButton
{
    [self printLogWith:@"addToCartVCDidClickAddButton"];
    
    [self.addToCartPO dismissPopoverAnimated:YES];
}

- (void)socialShareVCDidClickShareType:(FMBShareType)shareType
{
    [self printLogWith:@"socialShareVCDidClickShareType"];
    [self.socialSharePO dismissPopoverAnimated:YES];
    
    PFObject *product = [self objectAtIndexPath:indexPathToShare];
    
    if (shareType == FMB_SHARE_TYPE_FACEBOOK)
    {
        [FMBShareUtil shareViaFacebookWithProduct:product delegate:self];
    }
    if (shareType == FMB_SHARE_TYPE_EMAIL)
    {
        MFMailComposeViewController *vc = [FMBShareUtil shareViaEmailWithProduct:product delegate:self];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBShareUtilDelegate
- (void)shareUtilDelegateDidCompleteShare
{
    [self printLogWith:@"shareUtilDelegateDidCompleteShare"];
}


// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self printLogWith:@"mailComposeController: didFinishWithResult:"];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self printLogWith:@"Result: canceled"];
            break;
        case MFMailComposeResultSaved:
            [self printLogWith:@"Result: saved"];
            break;
        case MFMailComposeResultSent:
            [self printLogWith:@"Result: sent"];
            break;
        case MFMailComposeResultFailed:
            [self printLogWith:@"Result: failed"];
            break;
        default:
            [self printLogWith:@"Result: not sent"];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - WYPopoverControllerDelegate Functions
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController
{
    [self printLogWith:@"popoverControllerShouldDismissPopover"];
    
    FMBUserSetting *userSetting = [FMBUserSetting sharedInstance];
    
    if ([popoverController isEqual:_priceRangePO] && userSetting.bChanged == YES)
    {
        [userSetting store];
        userSetting.bChanged = NO;
        
        [self sendRequestOnSettingsChanged];
    }
    
    return YES;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    [self printLogWith:@"popoverControllerShouldIgnoreKeyboardBounds"];
    return NO;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_PRODUCTDETAILS])
    {
        FMBProductsDetailsVC *vc = [FMBUtil vcFromSegue:segue];
        vc.product               = sender;
        vc.backgroundName        = kFMBackgroundNameStore;
    }
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
        PFObject *product       = [self objectAtIndexPath:indexPath];
        FMBBrowseCVCell *cell1  = (FMBBrowseCVCell *)cell;
        cell1.delegate          = self;
        
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
        PFObject *product = [self objectAtIndexPath:indexPath];
        [self performSegueWithIdentifier:SEGID_PRODUCTDETAILS sender:product];
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
