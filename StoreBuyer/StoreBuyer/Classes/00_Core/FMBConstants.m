//
//  FMBConstants.m
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBConstants.h"

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - NSNotification
NSString *const FMBBackgroundSettingDidUpdateNotification   = @"com.xian.store.buyer.backgroundSettingDidUpdateNotification";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Image Sizes
CGRect const kSocialSharePORect             = {{0.f, 0.f}, {300, 250}};
CGRect const kPriceRangePORect              = {{0.f, 0.f}, {80,  250}};
CGRect const kFilterCategoryPORect          = {{0.f, 0.f}, {320, 300}};
CGRect const kChooseCategoryPORect          = {{0.f, 0.f}, {300, 257}};
CGRect const kChooseColorPORect             = {{0.f, 0.f}, {300, 280}};
CGRect const kEditPackageDimensionsPORect   = {{0.f, 0.f}, {300, 200}};
CGRect const kAddToCartPORect               = {{0.f, 0.f}, {250, 130}};

CGSize const kCompanyLogoSize       = {120.f, 120.f};
CGSize const kBackgroundImageSize   = {640, 1136};

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Keys used in validation Process
NSString *const kFMBValidationPlaceholderKey = @"placeholer";
NSString *const kFMBValidationControlKey     = @"control";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Keys used in Side Menu
NSString *const kFMBSideMenuItemTitleKey     = @"title";
NSString *const kFMBSideMenuItemImageKey     = @"image";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Keys used in UI Cells
NSString *const kFMBCellDataTitleKey     = @"title";
NSString *const kFMBCellDataImageIconKey = @"image_icon";
NSString *const kFMBCellDataBGColorKey   = @"bg_color";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Parse Cloud Classes and Fields Keys

#pragma mark - PFObject Installation Class
// Class key
NSString *const kFMBInstallationClassKey         = @"Installation";

// Field keys
NSString *const kFMBInstallationBadgeKey         = @"badge";
NSString *const kFMBInstallationUserKey          = @"user";
NSString *const kFMBInstallationDeviceTokenKey   = @"deviceToken";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Personality Class
// Class key
NSString *const kFMBCategoryClassKey      = @"Category";

// Field keys
NSString *const kFMBCategoryTitleKey      = @"title";
NSString *const kFMBCategoryImageKey      = @"image";

// ----------------------------------------------------------------------------------
#pragma mark - PFObject Color Class
// Class key
NSString *const kFMBColorClassKey         = @"Color";

// Field keys
NSString *const kFMBColorTitleKey         = @"title";
NSString *const kFMBColorValueKey         = @"value";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Facebook Result Keys
// keys
NSString *const kFMFacebookResultClassNameKey    = @"FBGraphObject";
NSString *const kFMFacebookResultBirthdayKey     = @"birthday";
NSString *const kFMFacebookResultEmailKey        = @"email";
NSString *const kFMFacebookResultFirstNameKey    = @"first_name";
NSString *const kFMFacebookResultLastNameKey     = @"last_name";
NSString *const kFMFacebookResultNameKey         = @"name";
NSString *const kFMFacebookResultIDKey           = @"id";
NSString *const kFMFacebookResultGenderKey       = @"gender";

// Gender values
NSString *const kFMFacebookResultGenderMale      = @"male";
NSString *const kFMFacebookResultGenderFemale    = @"female";

// Birthday format
NSString *const kFMFacebookResultBirthdayFormat  = @"MM/dd/yyyy";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFPush Notification Payload Keys
NSString *const kAPNSAPSKey                             = @"aps";
NSString *const kAPNSAlertKey                           = @"alert";
NSString *const kAPNSBadgeKey                           = @"badge";
NSString *const kAPNSSoundKey                           = @"sound";

NSString *const kFMPushPayloadTypeKey                   = @"p";
NSString *const kFMPushPayloadTypeM2M                   = @"m2m";
NSString *const kFMPushPayloadTypeM4B                   = @"m4b";

NSString *const kFMPushPayloadFromUserIDKey             = @"fuid";
NSString *const kFMPushPayloadFromUserEmailKey          = @"fue";
NSString *const kFMPushPayloadMessageIDKey              = @"mid";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - Parse Cloud Classes and Fields Keys

#pragma mark - PFObject Class

// Field keys
NSString *const kPFObjectObjectIDKey            = @"objectId";
NSString *const kPFObjectCreatedAtKey           = @"createdAt";
NSString *const kPFObjectUpdatedAtKey           = @"updatedAt";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Installation Class
// Class key
NSString *const kFMInstallationClassKey         = @"Installation";

// Field keys
NSString *const kFMInstallationBadgeKey         = @"badge";
NSString *const kFMInstallationUserKey          = @"user";
NSString *const kFMInstallationDeviceTokenKey   = @"deviceToken";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFConfig Class

// Field keys
NSString *const kFMConfigLocationKey                = @"location";
NSString *const kFMConfigLimitPerBrowseKey          = @"limitPerBrowse";
NSString *const kFMConfigLimitPerMessageEmployees   = @"limitPerMessageEmployees";
NSString *const kFMConfigLimitPerEmployeeMessage    = @"limitPerEmployeeMessage";
NSString *const kFMConfigLimitPerMessageCustomers   = @"limitPerMessageCustomers";
NSString *const kFMConfigLimitPerCustomerMessage    = @"limitPerCustomerMessage";
NSString *const kFMConfigLimitPerMessageBoard       = @"limitPerMessageBoard";
NSString *const kFMConfigLimitPerEmployees          = @"limitPerEmployees";
NSString *const kFMConfigLimitPerPendingOrders      = @"limitPerPendingOrders";
NSString *const kFMConfigLimitPerTotalOrders        = @"limitPerTotalOrders";
NSString *const kFMConfigLimitPerCustomerReviews    = @"limitPerCustomerReviews";
NSString *const kFMConfigLimitPerDeals              = @"limitPerDeals";
NSString *const kFMConfigLimitPerPreviousOrders     = @"limitPerPreviousOrders";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Company Class
// Class key
NSString *const kFMCompanyClassKey                  = @"Company";

// Field keys
NSString *const kFMCompanyNameKey                   = @"name";
NSString *const kFMCompanyStreetAddressKey          = @"streetAddress";
NSString *const kFMCompanyPhoneNumberKey            = @"phoneNumber";
NSString *const kFMCompanyLogoKey                   = @"logo";
NSString *const kFMCompanyOpenHourKey               = @"openHour";
NSString *const kFMCompanyCloseHourKey              = @"closeHour";
NSString *const kFMCompanyStartWeekdayKey           = @"startWeekday";
NSString *const kFMCompanyEndWeekdayKey             = @"endWeekday";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject User Class
// Class key
NSString *const kFMUserClassKey             = @"User";

// Field keys
NSString *const kFMUserUsernameKey          = @"username";
NSString *const kFMUserEmailKey             = @"email";
NSString *const kFMUserPasswordKey          = @"password";
NSString *const kFMUserFacebookIDKey        = @"facebookId";
NSString *const kFMUserFirstNameKey         = @"firstName";
NSString *const kFMUserLastNameKey          = @"lastName";
NSString *const kFMUserPhoneNumberKey       = @"phoneNumber";
NSString *const kFMUserRoleKey              = @"role";
NSString *const kFMUserLocationKey          = @"location";

// Role values
NSString *const kFMUserRoleManager          = @"Manager";
NSString *const kFMUserRoleBuyer            = @"Buyer";
NSString *const kFMUserRoleEmployee         = @"Employee";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Personality Class
// Class key
NSString *const kFMCategoryClassKey        = @"Category";

// Field keys
NSString *const kFMCategoryNameKey         = @"name";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Color Class
// Class key
NSString *const kFMColorClassKey         = @"Color";

// Field keys
NSString *const kFMColorTitleKey         = @"title";
NSString *const kFMColorValueKey         = @"value";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Product Class
// Class key
NSString *const kFMProductClassKey           = @"Product";

// Field keys
NSString *const kFMProductTitleKey           = @"title";
NSString *const kFMProductPriceKey           = @"price";
NSString *const kFMProductQuantityKey        = @"quantity";
NSString *const kFMProductDescriptionKey     = @"description";
NSString *const kFMProductCategoryKey        = @"category";
NSString *const kFMProductColorKey           = @"color";
NSString *const kFMProductBarcodeKey         = @"barcode";
NSString *const kFMProductImagesKey          = @"images";
NSString *const kFMProductWidthKey           = @"width";
NSString *const kFMProductHeightKey          = @"height";
NSString *const kFMProductLengthKey          = @"length";
NSString *const kFMProductWeightKey          = @"weight";
NSString *const kFMProductShippingRate       = @"shippingRate";
NSString *const kFMProductStatusKey          = @"status";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject DeliveryMethod Class
// Class key
NSString *const kFMDeliveryMethodClassKey               = @"DeliveryMethod";

// Field keys
NSString *const kFMDeliveryMethodNameKey                = @"name";
NSString *const kFMDeliveryMethodRateKey                = @"rate";
NSString *const kFMDeliveryMethodDescriptionKey         = @"description";
NSString *const kFMDeliveryMethodSortOrderKey           = @"sortOrder";

// Name values
NSString *const kFMDeliveryMethodNameShippingValue      = @"Shipping";
NSString *const kFMDeliveryMethodNameDeliveryValue      = @"Delivery";
NSString *const kFMDeliveryMethodNamePickUpValue        = @"Pick-Up";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Cart Class
// Class key
NSString *const kFMCartClassKey             = @"Cart";

// Field keys
NSString *const kFMCartProductKey           = @"product";
NSString *const kFMCartQuantityKey          = @"quantity";
NSString *const kFMCartCustomerKey          = @"customer";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Order Class
// Class key
NSString *const kFMOrderClassKey                    = @"Order";

// Field keys
NSString *const kFMOrderCustomerKey                 = @"customer";
NSString *const kFMOrderProductsKey                 = @"products";
NSString *const kFMOrderQuantitiesKey               = @"quantities";
NSString *const kFMOrderPricesKey                   = @"prices";
NSString *const kFMOrderShippingFirstNameKey        = @"shippingFirstName";
NSString *const kFMOrderShippingLastNameKey         = @"shippingLastName";
NSString *const kFMOrderShippingStreet1Key          = @"shippingStreet1";
NSString *const kFMOrderShippingStreet2Key          = @"shippingStreet2";
NSString *const kFMOrderShippingCityKey             = @"shippingCity";
NSString *const kFMOrderShippingStateKey            = @"shippingState";
NSString *const kFMOrderShippingZIPKey              = @"shippingZIP";
NSString *const kFMOrderShippingCountryKey          = @"shippingCoutnry";
NSString *const kFMOrderShippingPhoneNumberKey      = @"shippingPhoneNumber";
NSString *const kFMOrderShippingEmailKey            = @"shippingEmail";
NSString *const kFMOrderDeliveryMethodKey           = @"deliveryMethod";
NSString *const kFMOrderDeliveryRateKey             = @"deliveryRate";
NSString *const kFMOrderStripePaymentIdKey          = @"stripePaymentId";
NSString *const kFMOrderChargedKey                  = @"charged";
NSString *const kFMOrderStripeFeeKey                = @"stripeFee";
NSString *const kFMOrderTotalPriceKey               = @"totalPrice";
NSString *const kFMOrderStatusKey                   = @"status";
NSString *const kFMOrderReviewRateKey               = @"reviewRate";
NSString *const kFMOrderReviewCommentKey            = @"reviewComment";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject OrderStatus Class
// Class key
NSString *const kFMOrderStatusClassKey              = @"OrderStatus";

// Field keys
NSString *const kFMOrderStatusNameKey               = @"name";
NSString *const kFMOrderStatusDescriptionKey        = @"description";

// Name Values
NSString *const kFMOrderStatusNamePendingValue      = @"Pending";
NSString *const kFMOrderStatusNameShippedValue      = @"Shipped";
NSString *const kFMOrderStatusNameCompleteValue     = @"Complete";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Message Class
// Class key
NSString *const kFMMessageClassKey          = @"Message";

// Field keys
NSString *const kFMMessageFromKey           = @"from";
NSString *const kFMMessageToKey             = @"to";
NSString *const kFMMessageTextKey           = @"text";
NSString *const kFMMessageTypeKey           = @"type";
NSString *const kFMMessageReferenceKey      = @"reference";

// ------------------------------------------------------------------------------------------------------------------
#pragma mark - PFObject Background Class
// Class key
NSString *const kFMBackgroundClassKey       = @"Background";

// Field keys
NSString *const kFMBackgroundNameKey        = @"name";
NSString *const kFMBackgroundImageKey       = @"image";
NSString *const kFMBackgroundSortOrderKey   = @"sortOrder";

// Name values
NSString *const kFMBackgroundNameDefault    = @"Default";
NSString *const kFMBackgroundNameLogin      = @"Login";
NSString *const kFMBackgroundNameDashboard  = @"Dashboard";
NSString *const kFMBackgroundNameStore      = @"Store";
NSString *const kFMBackgroundNameMessages   = @"Messages";
NSString *const kFMBackgroundNameERegister  = @"eRegister";
NSString *const kFMBackgroundNameSettings   = @"Settings";