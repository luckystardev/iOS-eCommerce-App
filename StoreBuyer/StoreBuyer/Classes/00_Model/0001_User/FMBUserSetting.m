//
//  FMBUserSetting.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBUserSetting.h"
#import "FMBUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"

#define USER_SETTINGS_PRICE1_CODING_KEY                     @"usersetting_price1"
#define USER_SETTINGS_PRICE2_CODING_KEY                     @"usersetting_price2"
#define USER_SETTINGS_SEARCH_STRING_CODING_KEY              @"usersetting_search_string"
#define USER_SETTINGS_CHECKED_CATEGORY_ID_LIST_CODING_KEY   @"usersetting_checked_category_ID_list"
#define USER_SETTINGS_BROWSE_MODE                           @"usersetting_browse_mode"

@implementation FMBUserSetting

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBUserSetting) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)printLogWith:(NSString *)logMessage
{
    [FMBUserSetting printLogWith:logMessage];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Singleton Mehtod
+ (id)sharedInstance
{
    [self printLogWith:@"sharedInstance"];
    
    static FMBUserSetting *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if ([FMBUtil checkKeyExistInAppSettings:APP_SETTING_KEY_USER_SETTING])
        {
            sharedInstance = [self unarchivedObjectFromData:[FMBUtil appSettingValueByKey:APP_SETTING_KEY_USER_SETTING]];
        }
        else
        {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - LifeCycle Functions
- (id)init
{
    self = [super init];
    
    if (self)
    {
        _price1                 = MIN_PRICE;
        _price2                 = MAX_PRICE;
        _searchString           = @"";
        _checkedCategoryIdList  = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    self = [super init];
    
    if (self)
    {
        _price1                 = [(NSNumber *)[aDecoder decodeObjectForKey:USER_SETTINGS_PRICE1_CODING_KEY] floatValue];
        _price2                 = [(NSNumber *)[aDecoder decodeObjectForKey:USER_SETTINGS_PRICE2_CODING_KEY] floatValue];
        _searchString           = [aDecoder decodeObjectForKey:USER_SETTINGS_SEARCH_STRING_CODING_KEY];
        _checkedCategoryIdList  = [aDecoder decodeObjectForKey:USER_SETTINGS_CHECKED_CATEGORY_ID_LIST_CODING_KEY];
        _browseMode             = [[aDecoder decodeObjectForKey:USER_SETTINGS_BROWSE_MODE] intValue];
        
        if (!_searchString)
        {
            _searchString = @"";
        }
        
        if (_browseMode < 0 || _browseMode > 2)
        {
            _browseMode = FMB_BROWSE_MODE_SINGLE;
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self printLogWith:@"encodeWithCoder"];
    
    [aCoder encodeObject:[NSNumber numberWithFloat:_price1]         forKey:USER_SETTINGS_PRICE1_CODING_KEY];
    [aCoder encodeObject:[NSNumber numberWithFloat:_price2]         forKey:USER_SETTINGS_PRICE2_CODING_KEY];
    [aCoder encodeObject:_searchString                              forKey:USER_SETTINGS_SEARCH_STRING_CODING_KEY];
    [aCoder encodeObject:_checkedCategoryIdList                     forKey:USER_SETTINGS_CHECKED_CATEGORY_ID_LIST_CODING_KEY];
    [aCoder encodeObject:[NSNumber numberWithInt:_browseMode]        forKey:USER_SETTINGS_BROWSE_MODE];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSData *)archivedObject
{
    [self printLogWith:@"archivedObject"];
    
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (FMBUserSetting *)unarchivedObjectFromData:(NSData *)data
{
    [self printLogWith:@"unarchivedObjectFromData"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)store
{
    [self printLogWith:@"store"];
    
    [FMBUtil setAppSettingValue:[self archivedObject] ByKey:APP_SETTING_KEY_USER_SETTING];
}

@end
