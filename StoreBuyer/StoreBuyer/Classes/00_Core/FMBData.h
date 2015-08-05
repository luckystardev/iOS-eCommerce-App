//
//  FMBData.h
//  StoreBuyer
//
//  Created by Matti on 9/6/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import <Foundation/Foundation.h>

// --------------------------------------------------------------------------------------
// Debug constants to turn on debug console messages
// --------------------------------------------------------------------------------------
static const int debugFMBCoreLocationController     = 1;
static const int debugFMBUserUtil                   = 1;
static const int debugFMBUserSetting                = 1;
static const int debugFMBUtil                       = 1;
static const int debugFMBThemeManager               = 1;
static const int debugAppDelegate                   = 1;
static const int debugFMBLoginVC                    = 1;
static const int debugFMBBrowseVC                   = 1;
static const int debugFMBSideMenuVC                 = 1;
static const int debugFMBSocialShareVC              = 1;
static const int debugFMBImageCaptionCVCell         = 1;
static const int debugFMBBrowseCVCell               = 1;
static const int debugFMBPriceRangeVC               = 1;
static const int debugFMBFilterCategoryVC           = 1;
static const int debugFMBFilterCategoryCVCell       = 1;
static const int debugFMBSignupVC                   = 1;
static const int debugFMBResetPasswordVC            = 1;
static const int debugFMBProfileVC                  = 1;
static const int debugFMBCardListView               = 1;
static const int debugFMBCardListCVCell             = 1;
static const int debugFMBProfileUtil                = 1;
static const int debugFMBAddCardVC                  = 1;
static const int debugFMBShippingAddressListView    = 1;
static const int debugFMBShippingAddressListCVCell  = 1;
static const int debugFMBAddShippingAddressVC       = 1;
static const int debugFMBMessageListVC              = 1;
static const int debugFMBMessageListCell            = 1;
static const int debugFMBMessageVC                  = 1;
static const int debugFMBCartVC                     = 1;
static const int debugFMBCheckoutVC                 = 1;
static const int debugFMBScanVC                     = 1;
static const int debugFMBDealsVC                    = 1;
static const int debugFMBBrowseUtil                 = 1;
static const int debugFMBScanUtil                   = 1;
static const int debugFMBScannedProductsCell        = 1;
static const int debugFMBScannedProductsVC          = 1;
static const int debugFMBProductsDetailsVC          = 1;
static const int debugFMBProductDetailsImageListView= 1;
static const int debugFMBAddToCartVC                = 1;
static const int debugFMBCartUtil                   = 1;
static const int debugFMBShoppingCartVC             = 1;
static const int debugFMBShoppingCartProductCell    = 1;
static const int debugFMBDeliveryMethodsView        = 1;
static const int debugFMBDeliveryMethodsCVCell      = 1;
static const int debugFMBChooseCardVC               = 1;
static const int debugFMBChooseCardCell             = 1;
static const int debugFMBChooseShippingAddressVC    = 1;
static const int debugFMBChooseShippingAddressCell  = 1;
static const int debugFMBReceiptVC                  = 1;
static const int debugFMBMessageEmployeesUtil       = 1;
static const int debugFMBMessageEmployeesVC         = 1;
static const int debugFMBMessageEmployeesCell       = 1;
static const int debugFMBEmployeeMessageVC          = 1;
static const int debugFMBEmployeeMessageUtil        = 1;
static const int debugFMBDealsCVCell                = 1;
static const int debugFMBDealsUtil                  = 1;
static const int debugFMBEditProfileVC              = 1;
static const int debugFMBChangePasswordVC           = 1;
static const int debugFMBShareUtil                  = 1;
static const int debugFMBBackgroundSetting          = 1;
static const int debugFMBBackgroundUtil             = 1;
static const int debugFMBAboutVC                    = 1;
static const int debugFMBPreviousOrdersVC           = 1;
static const int debugFMBPreviousOrdersUtil         = 1;
static const int debugFMBPreviousOrdersCVCell       = 1;
static const int debugFMBPreviousOrders2VC          = 1;
static const int debugFMBPreviousOrders2Cell        = 1;
static const int debug = 1;

// --------------------------------------------------------------------------------------
// Storyboard IDs
// --------------------------------------------------------------------------------------
#pragma mark - Storyboard IDs

#define SBID_FMBLOGIN_VC                    @"SBID_FMBLoginVC"
#define SBID_FMBBROWSE_NC                   @"SBID_FMBBrowseNC"
#define SBID_FMBBROWSE_VC                   @"SBID_FMBBrowseVC"
#define SBID_FMBSIDEMENU_NC                 @"SBID_FMBSideMenuNC"
#define SBID_FMBSIDEMENU_VC                 @"SBID_FMBSideMenuVC"
#define SBID_FMBSOCIALSHARE_VC              @"SBID_FMBSocialShareVC"
#define SBID_FMBPRICERANGE_VC               @"SBID_FMBPriceRangeVC"
#define SBID_FMBFILTERCATEGORY_VC           @"SBID_FMBFilterCategoryVC"
#define SBID_FMBSIGNUP_NC                   @"SBID_FMBSignupNC"
#define SBID_FMBSIGNUP_VC                   @"SBID_FMBSignupVC"
#define SBID_FMBRESETPASSWORD_NC            @"SBID_FMBResetPasswordNC"
#define SBID_FMBRESETPASSWORD_VC            @"SBID_FMBResetPasswordVC"
#define SBID_FMBPROFILE_NC                  @"SBID_FMBProfileNC"
#define SBID_FMBPROFILE_VC                  @"SBID_FMBProfileVC"
#define SBID_FMBADDCARD_NC                  @"SBID_FMBAddCardNC"
#define SBID_FMBADDCARD_VC                  @"SBID_FMBAddCardVC"
#define SBID_FMBADDSHIPPINGADDRESS_NC       @"SBID_FMBAddShippingAddressNC"
#define SBID_FMBADDSHIPPINGADDRESS_VC       @"SBID_FMBAddShippingAddressVC"
#define SBID_FMBMESSAGELIST_NC              @"SBID_FMBMessageListNC"
#define SBID_FMBMESSAGELIST_VC              @"SBID_FMBMessageListVC"
#define SBID_FMBMESSAGE_NC                  @"SBID_FMBMessageNC"
#define SBID_FMBMESSAGE_VC                  @"SBID_FMBMessageVC"
#define SBID_FMBCART_NC                     @"SBID_FMBCartNC"
#define SBID_FMBCART_VC                     @"SBID_FMBCartVC"
#define SBID_FMBCHECKOUT_NC                 @"SBID_FMBCheckoutNC"
#define SBID_FMBCHECKOUT_VC                 @"SBID_FMBCheckoutVC"
#define SBID_FMBSCAN_NC                     @"SBID_FMBScanNC"
#define SBID_FMBSCAN_VC                     @"SBID_FMBScanVC"
#define SBID_FMBDEALS_NC                    @"SBID_FMBDealsNC"
#define SBID_FMBDEALS_VC                    @"SBID_FMBDealsVC"
#define SBID_FMBSCANNEDPRODUCTS_NC          @"SBID_FMBScannedProductsNC"
#define SBID_FMBSCANNEDPRODUCTS_VC          @"SBID_FMBScannedProductsVC"
#define SBID_FMBPRODUCTDETAILS_NC           @"SBID_FMBProductDetailsNC"
#define SBID_FMBPRODUCTDETAILS_VC           @"SBID_FMBProductDetailsVC"
#define SBID_FMBADDTOCART_VC                @"SBID_FMBAddToCartVC"
#define SBID_FMBSHOPPINGCART_NC             @"SBID_FMBShoppingCartNC"
#define SBID_FMBSHOPPINGCART_VC             @"SBID_FMBShoppingCartVC"
#define SBID_FMBCHOOSESHIPPINGADDRESS_NC    @"SBID_FMBChooseShippingAddressNC"
#define SBID_FMBCHOOSESHIPPINGADDRESS_VC    @"SBID_FMBChooseShippingAddressVC"
#define SBID_FMBCHOOSECARD_NC               @"SBID_FMBChooseCardNC"
#define SBID_FMBCHOOSECARD_VC               @"SBID_FMBChooseCardVC"
#define SBID_FMBRECEIPT_NC                  @"SBID_FMBReceiptNC"
#define SBID_FMBRECEIPT_VC                  @"SBID_FMBReceiptVC"
#define SBID_FMBMESSAGEEMPLOYEES_NC         @"SBID_FMBMessageEmployeesNC"
#define SBID_FMBMESSAGEEMPLOYEES_VC         @"SBID_FMBMessageEmployeesVC"
#define SBID_FMBEMPLOYEEMESSAGE_NC          @"SBID_FMBEmployeeMessageNC"
#define SBID_FMBEMPLOYEEMESSAGE_VC          @"SBID_FMBEmployeeMessageVC"
#define SBID_FMBEDITPROFILE_NC              @"SBID_FMBEditProfileNC"
#define SBID_FMBEDITPROFILE_VC              @"SBID_FMBEditProfileVC"
#define SBID_FMBCHANGEPASSWORD_NC           @"SBID_FMBChangePasswordNC"
#define SBID_FMBCHANGEPASSWORD_VC           @"SBID_FMBChangePasswordVC"
#define SBID_FMBABOUT_NC                    @"SBID_FMBAboutNC"
#define SBID_FMBABOUT_VC                    @"SBID_FMBAboutVC"
#define SBID_FMBPREVIOUSORDERS_NC           @"SBID_FMBPreviousOrdersNC"
#define SBID_FMBPREVIOUSORDERS_VC           @"SBID_FMBPreviousOrdersVC"
#define SBID_FMBPREVIOUSORDERS2_NC          @"SBID_FMBPreviousOrders2_NC"
#define SBID_FMBPREVIOUSORDERS2_VC          @"SBID_FMBPreviousOrders2_VC"


// --------------------------------------------------------------------------------------
// Macros
// --------------------------------------------------------------------------------------
#pragma mark - Macros

#define RGB(r,g,b,a)                [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]
#define RGBHEX(rgbValue,a)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// System Version Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// --------------------------------------------------------------------------------------
// Common Values
// --------------------------------------------------------------------------------------

// Common Theme Values
#pragma mark -

#define COMMON_COLOR_FOR_BORDER                 RGBHEX(0xDADADA, 1.f)
#define COMMON_COLOR_FOR_BUTTON_TITLE           RGBHEX(0x1FB0FF, 1.f)
#define COMMON_COLOR_FOR_TEXTFIELD              RGBHEX(0x7E8B8D, 1.f)
#define COMMON_COLOR_FOR_ERROR_TITLE            RGBHEX(0xff0000, 1.f)
#define COMMON_COLOR_FOR_CIRCLE_BORDER          RGBHEX(0x5178b4, 1.f)
#define COMMON_COLOR_FOR_EMPTY_LISTVIEW_LABEL   RGBHEX(0xcccccc, 1.f)

#define COMMON_WIDTH_FOR_BORDER                 1.f
#define COMMON_RADIUS                           5.f
#define COMMON_WIDTH_FOR_CIRCLE_BORDER          2.f

#define COMMON_FONT_FOR_PAGE_TITLE              [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]
#define COMMON_FONT_FOR_EMPTY_LISTVIEW_LABEL    [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]

// Common Values For Alert View
#pragma mark -

#define ALERT_TITLE_WARNING                 @"Warning"
#define ALERT_TITLE_ERROR                   @"Error"
#define ALERT_MSG_FIELDS_EMPTY              @"All fields must be filled!"
#define ALERT_MSG_INVALID_EMAIL             @"Please enter an email of correct format."
#define ALERT_MSG_INVALID_ZIPCODE           @"Please enter a ZIP code of correct format."
#define ALERT_MSG_INVALID_USERNAME_CONTENT  @"The user name field cannot contain whitespace or @ characters."
#define ALERT_MSG_NO_AVAILABLE_PHONE_CALL   @"This function is only available on the iPhone."

// Common Values used for validation process
#pragma mark -

#define SIGNUP_VALID_PASSWORD_MINIMUM_LENGTH    8
#define SIGNUP_VALID_PASSWORD_OK                0
#define SIGNUP_NOVALID_PASSWORD_LENGTH          1

#define SIGNUP_VALID_USERNAME_MINIMUM_LENGTH    6
#define SIGNUP_VALID_USERNAME_OK                0
#define SIGNUP_INVALID_USERNAME_LENGTH          1
#define SIGNUP_INVALID_USERNAME_CONTENT         2

#define VALID_PHONE_NUMBER_LENGTH               10

// Common Image Resource Names
#pragma mark -

#define COMMON_IMAGE_HUD_CHECKMARK          @"00_hud_checkmark"
#define COMMON_IMAGE_BACKGROUND             @"00_background"

// Common Maximum and Minimum Values For Filter Settings
#pragma mark -

#define MIN_PRICE    0
#define MAX_PRICE    2000

#define MAX_COUNT_ITEM_IMAGES       5

// ----------------------------------------------------------------
// App StandardUserDefaults Keys
// ----------------------------------------------------------------
#pragma mark - App StandardUserDefaults Keys

#define APP_SETTING_KEY_CREDIT_CARDS        @"creditcards"
#define APP_SETTING_KEY_BANKS               @"banks"
#define APP_SETTING_KEY_SHIPPING_ADDRESSES  @"shippingaddresses"
#define APP_SETTING_KEY_USER_SETTING        @"usersetting"
#define APP_SETTING_KEY_BACKGROUND_SETTING  @"backgroundsetting"

// ----------------------------------------------------------------
// Enumerations
// ----------------------------------------------------------------
typedef enum
{
    FMB_SHARE_TYPE_FACEBOOK = 0,
    FMB_SHARE_TYPE_TWITTER  = 1,
    FMB_SHARE_TYPE_EMAIL    = 2,
    FMB_SHARE_TYPE_CONTACTS = 3,
    FMB_SHARE_TYPE_APP      = 4,
} FMBShareType;

typedef enum
{
    FMB_BROWSE_MODE_SINGLE = 0,
    FMB_BROWSE_MODE_GRID   = 1,
    FMB_BROWSE_MODE_LINE   = 2,
} FMBBrowseMode;