//
//  FMBFilterCategoryVC.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBFilterCategoryVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBFilterCategoryCVCell.h"
#import "FMBUserSetting.h"

#define CELLID @"FilterCategoryCVCell"

@interface FMBFilterCategoryVC ()

@end

@implementation FMBFilterCategoryVC
{
    NSArray        *dataSource;
    NSMutableArray *checkedIdList;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBFilterCategoryVC) return;
    
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
    
    _hud = [FMBUtil initHUDWithView:self.view];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    dataSource      = [[NSMutableArray alloc] init];
    checkedIdList   = [[NSMutableArray alloc] initWithArray:[[FMBUserSetting sharedInstance] checkedCategoryIdList]];
    
    [FMBUtil showHUD:self.hud withText:@""];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMCategoryClassKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             dataSource = objects;
             
             if ([checkedIdList count] == 0)
             {
                 [self addAllIDsToCheckedIDsList];
             }
             
             [_collectionview reloadData];
         }
     }];
}

- (void)addAllIDsToCheckedIDsList
{
    [self printLogWith:@"addAllIDsToCheckedIDsList"];
    
    checkedIdList = [[NSMutableArray alloc] init];
    
    for (PFObject *category in dataSource)
    {
        [checkedIdList addObject:category.objectId];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnSearch:(id)sender
{
    [self printLogWith:@"onBtnSearch"];
    
    FMBUserSetting *userSetting         = [FMBUserSetting sharedInstance];
    
    userSetting.checkedCategoryIdList   = [[NSMutableArray alloc] initWithArray:checkedIdList];
    [userSetting store];
    
    [self.delegate filterCategoryVCDidSearch];
}

- (IBAction)onBtnCheckAll:(id)sender
{
    [self printLogWith:@"onBtnCheckAll"];
    
    [self addAllIDsToCheckedIDsList];
    
    [self.collectionview reloadData];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (BOOL)checkedStatusForIndexPath:(NSIndexPath *)indexPath
{
    PFObject *category = [self cellDataAtIndexPath:indexPath];
    
    if ([checkedIdList indexOfObject:category.objectId] != NSNotFound)
    {
        return YES;
    }
    
    return NO;
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
    FMBFilterCategoryCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    [cell configureCellWithData:[self cellDataAtIndexPath:indexPath]];
    
    cell.btnChecked.hidden = ![self checkedStatusForIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    FMBFilterCategoryCVCell *cell = (FMBFilterCategoryCVCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
    PFObject            *category = [self cellDataAtIndexPath:indexPath];
    
    if ([checkedIdList indexOfObject:category.objectId] == NSNotFound)
    {
        [checkedIdList addObject:category.objectId];
        cell.btnChecked.hidden = NO;
    }
    else
    {
        [checkedIdList removeObjectAtIndex:[checkedIdList indexOfObject:category.objectId]];
        cell.btnChecked.hidden = YES;
    }
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMBFilterCategoryCVCell* cell = (FMBFilterCategoryCVCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
