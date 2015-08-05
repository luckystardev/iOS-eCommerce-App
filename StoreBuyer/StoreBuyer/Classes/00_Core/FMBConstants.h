//
//  FMBConstants.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ----------------------------------------------------------------------------------
#pragma mark - NSNotification
extern NSString *const FMBBackgroundSettingDidUpdateNotification;

// ----------------------------------------------------------------------------------
#pragma mark - Size and Frame Constants
extern CGRect const kSocialSharePORect;
extern CGRect const kPriceRangePORect;
extern CGRect const kFilterCategoryPORect;
extern CGRect const kChooseCategoryPORect;
extern CGRect const kChooseColorPORect;
extern CGRect const kEditPackageDimensionsPORect;
extern CGRect const kAddToCartPORect;

extern CGSize const kCompanyLogoSize;
extern CGSize const kBackgroundImageSize;

// ----------------------------------------------------------------------------------
#pragma mark - Keys used in validation Process
extern NSString *const kFMBValidationPlaceholderKey;
extern NSString *const kFMBValidationControlKey;

// ----------------------------------------------------------------------------------
#pragma mark - Keys used in Side Menu
extern NSString *const kFMBSideMenuItemTitleKey;
extern NSString *const kFMBSideMenuItemImageKey;

// ----------------------------------------------------------------------------------
#pragma mark - Keys used in UI Cells
extern NSString *const kFMBCellDataTitleKey;
extern NSString *const kFMBCellDataImageIconKey;
extern NSString *const kFMBCellDataBGColorKey;

// ----------------------------------------------------------------------------------
#pragma mark - Parse Cloud Classes and Fields Keys

#pragma mark - PFObject Installation Class
// Class key
extern NSString *const kFMBInstallationClassKey;

// Field keys
extern NSString *const kFMBInstallationBadgeKey;
extern NSString *const kFMBInstallationUserKey;
extern NSString *const kFMBInstallationDeviceTokenKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Category Class
// Class key
extern NSString *const kFMBCategoryClassKey;

// Field keys
extern NSString *const kFMBCategoryTitleKey;
extern NSString *const kFMBCategoryImageKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Color Class
// Class key
extern NSString *const kFMBColorClassKey;

// Field keys
extern NSString *const kFMBColorTitleKey;
extern NSString *const kFMBColorValueKey;

// ----------------------------------------------------------------------------------
#pragma mark - Facebook Result Keys
// keys
extern NSString *const kFMFacebookResultClassNameKey;
extern NSString *const kFMFacebookResultBirthdayKey;
extern NSString *const kFMFacebookResultEmailKey;
extern NSString *const kFMFacebookResultFirstNameKey;
extern NSString *const kFMFacebookResultLastNameKey;
extern NSString *const kFMFacebookResultNameKey;
extern NSString *const kFMFacebookResultIDKey;
extern NSString *const kFMFacebookResultGenderKey;

// Gender values
extern NSString *const kFMFacebookResultGenderMale;
extern NSString *const kFMFacebookResultGenderFemale;

// Birthday format
extern NSString *const kFMFacebookResultBirthdayFormat;

// ----------------------------------------------------------------------------------
#pragma mark - PFPush Notification Payload Keys
extern NSString *const kAPNSAPSKey;
extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kFMPushPayloadTypeKey;
extern NSString *const kFMPushPayloadTypeM2M;
extern NSString *const kFMPushPayloadTypeM4B;

extern NSString *const kFMPushPayloadFromUserIDKey;
extern NSString *const kFMPushPayloadFromUserEmailKey;
extern NSString *const kFMPushPayloadMessageIDKey;

// ----------------------------------------------------------------------------------
#pragma mark - Parse Cloud Classes and Fields Keys

#pragma mark - PFObject Class

// Field keys
extern NSString *const kPFObjectObjectIDKey;
extern NSString *const kPFObjectCreatedAtKey;
extern NSString *const kPFObjectUpdatedAtKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Installation Class
// Class key
extern NSString *const kFMInstallationClassKey;

// Field keys
extern NSString *const kFMInstallationBadgeKey;
extern NSString *const kFMInstallationUserKey;
extern NSString *const kFMInstallationDeviceTokenKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFConfig Class

// Field keys
extern NSString *const kFMConfigLocationKey;
extern NSString *const kFMConfigLimitPerBrowseKey;
extern NSString *const kFMConfigLimitPerMessageEmployees;
extern NSString *const kFMConfigLimitPerEmployeeMessage;
extern NSString *const kFMConfigLimitPerMessageCustomers;
extern NSString *const kFMConfigLimitPerCustomerMessage;
extern NSString *const kFMConfigLimitPerMessageBoard;
extern NSString *const kFMConfigLimitPerMessageBoard;
extern NSString *const kFMConfigLimitPerEmployees;
extern NSString *const kFMConfigLimitPerPendingOrders;
extern NSString *const kFMConfigLimitPerTotalOrders;
extern NSString *const kFMConfigLimitPerCustomerReviews;
extern NSString *const kFMConfigLimitPerDeals;
extern NSString *const kFMConfigLimitPerPreviousOrders;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Company Class
// Class key
extern NSString *const kFMCompanyClassKey;

// Field keys
extern NSString *const kFMCompanyNameKey;
extern NSString *const kFMCompanyStreetAddressKey;
extern NSString *const kFMCompanyPhoneNumberKey;
extern NSString *const kFMCompanyLogoKey;
extern NSString *const kFMCompanyOpenHourKey;
extern NSString *const kFMCompanyCloseHourKey;
extern NSString *const kFMCompanyStartWeekdayKey;
extern NSString *const kFMCompanyEndWeekdayKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject User Class
// Class key
extern NSString *const kFMUserClassKey;

// Field keys
extern NSString *const kFMUserUsernameKey;
extern NSString *const kFMUserEmailKey;
extern NSString *const kFMUserPasswordKey;
extern NSString *const kFMUserFacebookIDKey;
extern NSString *const kFMUserFirstNameKey;
extern NSString *const kFMUserLastNameKey;
extern NSString *const kFMUserPhoneNumberKey;
extern NSString *const kFMUserRoleKey;
extern NSString *const kFMUserLocationKey;

// Role values
extern NSString *const kFMUserRoleManager;
extern NSString *const kFMUserRoleBuyer;
extern NSString *const kFMUserRoleEmployee;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Category Class
// Class key
extern NSString *const kFMCategoryClassKey;

// Field keys
extern NSString *const kFMCategoryNameKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Color Class
// Class key
extern NSString *const kFMColorClassKey;

// Field keys
extern NSString *const kFMColorTitleKey;
extern NSString *const kFMColorValueKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Product Class
// Class key
extern NSString *const kFMProductClassKey;

// Field keys
extern NSString *const kFMProductTitleKey;
extern NSString *const kFMProductPriceKey;
extern NSString *const kFMProductQuantityKey;
extern NSString *const kFMProductDescriptionKey;
extern NSString *const kFMProductCategoryKey;
extern NSString *const kFMProductColorKey;
extern NSString *const kFMProductBarcodeKey;
extern NSString *const kFMProductImagesKey;
extern NSString *const kFMProductWidthKey;
extern NSString *const kFMProductHeightKey;
extern NSString *const kFMProductLengthKey;
extern NSString *const kFMProductWeightKey;
extern NSString *const kFMProductShippingRate;
extern NSString *const kFMProductStatusKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject DeliveryMethod Class
// Class key
extern NSString *const kFMDeliveryMethodClassKey;

// Field keys
extern NSString *const kFMDeliveryMethodNameKey;
extern NSString *const kFMDeliveryMethodRateKey;
extern NSString *const kFMDeliveryMethodDescriptionKey;
extern NSString *const kFMDeliveryMethodSortOrderKey;

// Name values
extern NSString *const kFMDeliveryMethodNameShippingValue;
extern NSString *const kFMDeliveryMethodNameDeliveryValue;
extern NSString *const kFMDeliveryMethodNamePickUpValue;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Cart Class
// Class key
extern NSString *const kFMCartClassKey;

// Field keys
extern NSString *const kFMCartProductKey;
extern NSString *const kFMCartQuantityKey;
extern NSString *const kFMCartCustomerKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Order Class
// Class key
extern NSString *const kFMOrderClassKey;

// Field keys
extern NSString *const kFMOrderCustomerKey;
extern NSString *const kFMOrderProductsKey;
extern NSString *const kFMOrderQuantitiesKey;
extern NSString *const kFMOrderPricesKey;
extern NSString *const kFMOrderShippingFirstNameKey;
extern NSString *const kFMOrderShippingLastNameKey;
extern NSString *const kFMOrderShippingStreet1Key;
extern NSString *const kFMOrderShippingStreet2Key;
extern NSString *const kFMOrderShippingCityKey;
extern NSString *const kFMOrderShippingStateKey;
extern NSString *const kFMOrderShippingZIPKey;
extern NSString *const kFMOrderShippingCountryKey;
extern NSString *const kFMOrderShippingPhoneNumberKey;
extern NSString *const kFMOrderShippingEmailKey;
extern NSString *const kFMOrderDeliveryMethodKey;
extern NSString *const kFMOrderDeliveryRateKey;
extern NSString *const kFMOrderStripePaymentIdKey;
extern NSString *const kFMOrderChargedKey;
extern NSString *const kFMOrderStripeFeeKey;
extern NSString *const kFMOrderTotalPriceKey;
extern NSString *const kFMOrderStatusKey;
extern NSString *const kFMOrderReviewRateKey;
extern NSString *const kFMOrderReviewCommentKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject OrderProduct Class
// Class key
extern NSString *const kFMOrderStatusClassKey;

// Field keys
extern NSString *const kFMOrderStatusNameKey;
extern NSString *const kFMOrderStatusDescriptionKey;

// Name Values
extern NSString *const kFMOrderStatusNamePendingValue;
extern NSString *const kFMOrderStatusNameShippedValue;
extern NSString *const kFMOrderStatusNameCompleteValue;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Message Class
// Class key
extern NSString *const kFMMessageClassKey;

// Field keys
extern NSString *const kFMMessageFromKey;
extern NSString *const kFMMessageToKey;
extern NSString *const kFMMessageTextKey;
extern NSString *const kFMMessageTypeKey;
extern NSString *const kFMMessageReferenceKey;

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Background Class
// Class key
extern NSString *const kFMBackgroundClassKey;

// Field keys
extern NSString *const kFMBackgroundNameKey;
extern NSString *const kFMBackgroundImageKey;
extern NSString *const kFMBackgroundSortOrderKey;

// Name values
extern NSString *const kFMBackgroundNameDefault;
extern NSString *const kFMBackgroundNameLogin;
extern NSString *const kFMBackgroundNameDashboard;
extern NSString *const kFMBackgroundNameStore;
extern NSString *const kFMBackgroundNameMessages;
extern NSString *const kFMBackgroundNameERegister;
extern NSString *const kFMBackgroundNameSettings;