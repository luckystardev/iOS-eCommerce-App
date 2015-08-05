//
//  constants.js
//  Store
//
//  Created by Cheng Xian on 9/15/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

// ------------------------------------------------------------------------------------------------------------------
// Common Maximum and Minimum Values For Filter Settings
exports.minFilterPrice = 0;
exports.maxFilterPrice = 2000;

// ------------------------------------------------------------------------------------------------------------------
// Keys used in Revenue Page
exports.kFMRevenueLabelKey     = "label";
exports.kFMRevenueSumKey       = "sum";
exports.kFMRevenueStartDate    = "startDate";
exports.kFMRevenueEndDate      = "endDate";

// ------------------------------------------------------------------------------------------------------------------
// Keys used in eRegister Page
exports.kFMBalancePendingKey	= "pending";
exports.kFMBalanceAvailableKey	= "available";

// ------------------------------------------------------------------------------------------------------------------
// Parse Cloud Classes and Fields Keys

// PFObject Class

// Field keys
exports.kPFObjectObjectIDKey            = "objectId";
exports.kPFObjectCreatedAtKey     		= "createdAt";
exports.kPFObjectUpdatedAtKey		    = "updatedAt";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Installation Class

// Class key
exports.kFMInstallationClassKey         = "Installation";

// Field keys
exports.kFMInstallationBadgeKey         = "badge";
exports.kFMInstallationUserKey          = "user";
exports.kFMInstallationDeviceTokenKey   = "deviceToken";

// ------------------------------------------------------------------------------------------------------------------
// PFConfig Class

// Field keys
exports.kFMConfigLocationKey                = "location";
exports.kFMConfigLimitPerBrowseKey		    = "limitPerBrowse";
exports.kFMConfigLimitPerMessageEmployees   = "limitPerMessageEmployees";
exports.kFMConfigLimitPerEmployeeMessage    = "limitPerEmployeeMessage";
exports.kFMConfigLimitPerMessageCustomers   = "limitPerMessageCustomers";
exports.kFMConfigLimitPerCustomerMessage    = "limitPerCustomerMessage";
exports.kFMConfigLimitPerMessageBoard       = "limitPerMessageBoard";
exports.kFMConfigLimitPerEmployees          = "limitPerEmployees";
exports.kFMConfigLimitPerPendingOrders      = "limitPerPendingOrders";
exports.kFMConfigLimitPerTotalOrders        = "limitPerTotalOrders";
exports.kFMConfigLimitPerCustomerReviews    = "limitPerCustomerReviews";
exports.kFMConfigLimitPerDeals              = "limitPerDeals";
exports.kFMConfigLimitPerPreviousOrders     = "limitPerPreviousOrders";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Company Class
// Class key
exports.kFMCompanyClassKey                  = "Company";

// Field keys
exports.kFMCompanyNameKey                   = "name";
exports.kFMCompanyStreetAddressKey          = "streetAddress";
exports.kFMCompanyPhoneNumberKey            = "phoneNumber";
exports.kFMCompanyLogoKey                   = "logo";
exports.kFMCompanyOpenHourKey               = "openHour";
exports.kFMCompanyCloseHourKey              = "closeHour";
exports.kFMCompanyStartWeekdayKey           = "startWeekday";
exports.kFMCompanyEndWeekdayKey             = "endWeekday";

// ------------------------------------------------------------------------------------------------------------------
// PFObject User Class
// Class key
exports.kFMUserClassKey             = "User";

// Field keys
exports.kFMUserUsernameKey          = "username";
exports.kFMUserEmailKey             = "email";
exports.kFMUserPasswordKey          = "password";
exports.kFMUserFacebookIDKey        = "facebookId";
exports.kFMUserFirstNameKey         = "firstName";
exports.kFMUserLastNameKey          = "lastName";
exports.kFMUserPhoneNumberKey       = "phoneNumber";
exports.kFMUserRoleKey              = "role";
exports.kFMUserLocationKey          = "location";

// Role values
exports.kFMUserRoleManager          = "Manager";
exports.kFMUserRoleBuyer            = "Buyer";
exports.kFMUserRoleEmployee         = "Employee";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Personality Class
// Class key
exports.kFMCategoryClassKey        = "Category";

// Field keys
exports.kFMCategoryNameKey         = "name";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Color Class
// Class key
exports.kFMColorClassKey         = "Color";

// Field keys
exports.kFMColorTitleKey         = "title";
exports.kFMColorValueKey         = "value";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Product Class
// Class key
exports.kFMProductClassKey           = "Product";

// Field keys
exports.kFMProductTitleKey           = "title";
exports.kFMProductPriceKey           = "price";
exports.kFMProductQuantityKey        = "quantity";
exports.kFMProductDescriptionKey     = "description";
exports.kFMProductCategoryKey        = "category";
exports.kFMProductColorKey           = "color";
exports.kFMProductBarcodeKey         = "barcode";
exports.kFMProductImagesKey          = "images";
exports.kFMProductWidthKey           = "width";
exports.kFMProductHeightKey          = "height";
exports.kFMProductLengthKey          = "length";
exports.kFMProductWeightKey          = "weight";
exports.kFMProductShippingRate       = "shippingRate";
exports.kFMProductStatusKey          = "status";

// ------------------------------------------------------------------------------------------------------------------
// PFObject DeliveryMethod Class
// Class key
exports.kFMDeliveryMethodClassKey               = "DeliveryMethod";

// Field keys
exports.kFMDeliveryMethodNameKey                = "name";
exports.kFMDeliveryMethodRateKey                = "rate";
exports.kFMDeliveryMethodDescriptionKey         = "description";
exports.kFMDeliveryMethodSortOrderKey           = "sortOrder";

// Name values
exports.kFMDeliveryMethodNameShippingValue      = "Shipping";
exports.kFMDeliveryMethodNameDeliveryValue      = "Delivery";
exports.kFMDeliveryMethodNamePickUpValue        = "Pick-Up";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Cart Class
// Class key
exports.kFMCartClassKey             = "Cart";

// Field keys
exports.kFMCartProductKey           = "product";
exports.kFMCartQuantityKey          = "quantity";
exports.kFMCartCustomerKey          = "customer";

// ------------------------------------------------------------------------------------------------------------------
// PFObject Order Class
// Class key
exports.kFMOrderClassKey                    = "Order";

// Field keys
exports.kFMOrderCustomerKey                 = "customer";
exports.kFMOrderProductsKey                 = "products";
exports.kFMOrderQuantitiesKey               = "quantities";
exports.kFMOrderPricesKey                   = "prices";
exports.kFMOrderShippingFirstNameKey        = "shippingFirstName";
exports.kFMOrderShippingLastNameKey         = "shippingLastName";
exports.kFMOrderShippingStreet1Key          = "shippingStreet1";
exports.kFMOrderShippingStreet2Key          = "shippingStreet2";
exports.kFMOrderShippingCityKey             = "shippingCity";
exports.kFMOrderShippingStateKey            = "shippingState";
exports.kFMOrderShippingZIPKey              = "shippingZIP";
exports.kFMOrderShippingCountryKey          = "shippingCoutnry";
exports.kFMOrderShippingPhoneNumberKey      = "shippingPhoneNumber";
exports.kFMOrderShippingEmailKey            = "shippingEmail";
exports.kFMOrderDeliveryMethodKey           = "deliveryMethod";
exports.kFMOrderDeliveryRateKey             = "deliveryRate";
exports.kFMOrderStripePaymentIdKey          = "stripePaymentId";
exports.kFMOrderChargedKey                  = "charged";
exports.kFMOrderStripeFeeKey                = "stripeFee";
exports.kFMOrderTotalPriceKey               = "totalPrice";
exports.kFMOrderStatusKey                   = "status";
exports.kFMOrderReviewRateKey               = "reviewRate";
exports.kFMOrderReviewCommentKey            = "reviewComment";

// ------------------------------------------------------------------------------------------------------------------
// PFObject OrderStatus Class
// Class key
exports.kFMOrderStatusClassKey              = "OrderStatus";

// Field keys
exports.kFMOrderStatusNameKey               = "name";
exports.kFMOrderStatusDescriptionKey        = "description";

// Name Values
exports.kFMOrderStatusNamePendingValue      = "Pending";
exports.kFMOrderStatusNameShippedValue      = "Shipped";
exports.kFMOrderStatusNameCompleteValue     = "Complete";

// ------------------------------------------------------------------------------------------------------------------
//PFObject Message Class
// Class key
exports.kFMMessageClassKey          = "Message";

// Field keys
exports.kFMMessageFromKey           = "from";
exports.kFMMessageToKey             = "to";
exports.kFMMessageTextKey           = "text";
exports.kFMMessageTypeKey           = "type";
exports.kFMMessageReferenceKey      = "reference";