//
//  FMBShoppingCartVC.m
//  StoreBuyer
//
//  Created by Matti on 9/25/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBShoppingCartVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBReceiptVC.h"
#import "FMBBackgroundSetting.h"

#define CELLID_PRODUCT                      @"ProductCell"
#define CELLID_DELIVERY                     @"DeliveryCell"
#define CELLID_SHIPPINGADDRESS              @"ShippingAddressCell"
#define CELLID_CARD                         @"CardCell"
#define CELLID_BOTTOM                       @"BottomCell"

#define TAG_DELIVERY_METHODS                300
#define TAG_SHIPPING_ADDRESS                301
#define TAG_CARD_ICON                       302
#define TAG_CARD_NUMBER                     303
#define TAG_SUBTOTAL                        304
#define TAG_TAX                             305
#define TAG_DELIVERY_NAME                   306
#define TAG_DELIVERY_RATE                   307
#define TAG_GRANDTOTAL                      308

#define MESSAGEdataSource_DELETE                 @"Are you sure you want to delete this credit card?"
#define TAG_ALERTVIEWdataSource_DELETE           107

#define SEGID_CHOOSECARD                    @"SEGID_ChooseCard"
#define SEGID_CHOOSESHIPPINGADDRESS         @"SEGID_ChooseShippingAddress"

@interface FMBShoppingCartVC ()

@end

@implementation FMBShoppingCartVC
{
    NSMutableArray *dataSource;
    NSIndexPath    *_indexPathDeleting;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBShoppingCartVC) return;
    
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

- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMBThemeManager relayoutTableviewForApp:self.tableView];
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
    
    [self initTheme];
    
    _hud = [FMBUtil initHUDWithView:self.view];
    
    _bDeleteMode = NO;
    
    _deliveryMethod = [_deliveryMethodsView selectedDeliveryMethod];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameStore toImageView:_imageviewBackground];
    
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
#pragma mark - Data Source Functions
- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMCartClassKey];
    
    [query whereKey:kFMCartCustomerKey equalTo:[PFUser currentUser]];
    [query includeKey:kFMCartProductKey];
    
    [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackForInitDataSource:error:)];
    
    [FMBUtil showHUD:_hud withText:@""];
}

- (void)callbackForInitDataSource:(NSArray *)carts error:(NSError *)error
{
    [self printLogWith:@"callbackForInitDataSource"];
    [_hud hide:YES];
    if (error) return;
    
    if (!dataSource)
    {
        dataSource = [NSMutableArray array];
    }
    
    [dataSource addObjectsFromArray:carts];
    
    [self.tableView reloadData];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Section2 ( Summarization ) Functions
- (void)initSummary
{
    [self printLogWith:@"initSummary"];
    
    [self updateShippingAddressLabel];
    [self updateCardLabel];
    [self updateBottomLabels];
}

- (void)updateShippingAddressLabel
{
    [self printLogWith:@"updateShippingAddressLabel"];
    
    if ([FMBUtil isObjectEmpty:_shippingAddress])
    {
        _labelShippingAddress.text = @"Shipping Address";
    }
    else
    {
        _labelShippingAddress.text = [_shippingAddress formattedText1];
    }
}

- (void)updateCardLabel
{
    [self printLogWith:@"updateCardLabel"];
    
    if ([FMBUtil isObjectEmpty:_pk_card])
    {
        _labelCardLast4Number.text = @"****";
    }
    else
    {
        _labelCardLast4Number.text  = [_pk_card last4];
        _imageviewCardIcon.image    = [_pk_card cardTypeImage];
    }
}

- (void)updateBottomLabels
{
    [self printLogWith:@"updateBottomLabels"];
    
    // Format delivery methods
    if ([FMBUtil isObjectEmpty:_deliveryMethod])
    {
        _labelDeliveryName.text = kFMDeliveryMethodNamePickUpValue;
    }
    else
    {
        _labelDeliveryName.text = _deliveryMethod[kFMDeliveryMethodNameKey];
    }
    
    _labelSubTotal.text     = [NSString stringWithFormat:@"%.2f", [FMBCartUtil subTotalPriceFromCart:dataSource]];
    _labelTax.text          = [NSString stringWithFormat:@"%.2f", [FMBCartUtil salesTaxFromCart:dataSource]];
    _labelDeliveryRate.text = [NSString stringWithFormat:@"%.2f", [FMBCartUtil shippingRateFromObject:_deliveryMethod]];
    _labelGrandTotal.text   = [NSString stringWithFormat:@"%.2f", [FMBCartUtil grandTotalPriceFromCart:dataSource
                                                                                    withDeliveryMethod:_deliveryMethod]];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnCheckOut:(id)sender
{
    [self printLogWith:@"onBtnCheckOut"];
    
    if (![self doValidationProcess]) return;
    
    [self doCheckout];
}

- (IBAction)onBtnDeleteMode:(id)sender
{
    [self printLogWith:@"onBtnDeleteMode"];
    
    _bDeleteMode = !_bDeleteMode;
    
    [self reloadSection:0];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBShoppingCartProductCellDelegate
- (id)shoppingCartProductCellGetPrdouctData:(FMBShoppingCartProductCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return [self objectAtIndexPath:indexPath];
}

- (void)shoppingCartProductCell:(FMBShoppingCartProductCell *)cell didUpdateQuantity:(int)quantity
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    PFObject *cart = [self objectAtIndexPath:indexPath];
    
    cart[kFMCartQuantityKey] = @(quantity);
    
    [cart saveInBackground];
    
    [self updateBottomLabels];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Functions
- (void)reloadSection:(NSInteger)section
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (CGFloat)cellSizeAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100.f;
    }
    // Section 2
    else if (indexPath.row == 0)
    {
        return 80.f;
    }
    else if (indexPath.row == 1 || indexPath.row == 2)
    {
        return 44.f;
    }
    else
    {
        return 240.f;
    }
    
    return 0.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [dataSource count];
    }
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSizeAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *res;
    
    if (indexPath.section == 0)
    {
        FMBShoppingCartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID_PRODUCT];
        
        [cell configureCellWithData:[self objectAtIndexPath:indexPath]];
        cell.delegate = self;
        cell.btnRemove.hidden = !_bDeleteMode;
        
        res = cell;
    }
    // Section 2
    else if (indexPath.row == 0)
    {
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_DELIVERY];
        
        _deliveryMethodsView = (FMBDeliveryMethodsView *)[res viewWithTag:TAG_DELIVERY_METHODS];
        _deliveryMethodsView.delegate = self;
    }
    else if (indexPath.row == 1)
    {
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_SHIPPINGADDRESS];
        
        _labelShippingAddress = (UILabel *)[res viewWithTag:TAG_SHIPPING_ADDRESS];
    }
    else if (indexPath.row == 2)
    {
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_CARD];
        
        _imageviewCardIcon    = (UIImageView *)[res viewWithTag:TAG_CARD_ICON];
        _labelCardLast4Number = (UILabel *)[res viewWithTag:TAG_CARD_NUMBER];
    }
    else
    {
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_BOTTOM];
        
        _labelSubTotal      = (UILabel *)[res viewWithTag:TAG_SUBTOTAL];
        _labelTax           = (UILabel *)[res viewWithTag:TAG_TAX];
        _labelDeliveryName  = (UILabel *)[res viewWithTag:TAG_DELIVERY_NAME];
        _labelDeliveryRate  = (UILabel *)[res viewWithTag:TAG_DELIVERY_RATE];
        _labelGrandTotal    = (UILabel *)[res viewWithTag:TAG_GRANDTOTAL];
        
        [self updateBottomLabels];
        
        [self initSummary];
    }
    
    res.backgroundColor = [UIColor clearColor];
    
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView didSelectRowAtIndexPath"];
    
    if (indexPath.section == 0)
    {
        if (_bDeleteMode)
        {
            UIAlertView *alertView = [FMBUtil okCancelAlertWithTitle:nil message:MESSAGEdataSource_DELETE OkTitle:nil CancelTitle:nil delegate:self];
            alertView.tag = TAG_ALERTVIEWdataSource_DELETE;
            [alertView show];
            
            _indexPathDeleting = indexPath;
        }
    }
    // Section 2
    else if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:SEGID_CHOOSESHIPPINGADDRESS sender:self];
    }
    else if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:SEGID_CHOOSECARD sender:self];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && (indexPath.row ==0 || indexPath.row == 3)) return;
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && (indexPath.row ==0 || indexPath.row == 3)) return;
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self printLogWith:@"alertView clickedButtonAtIndex"];
    
    if (buttonIndex == 1)
    {
        if (alertView.tag == TAG_ALERTVIEWdataSource_DELETE)
        {
            PFObject *cart = [dataSource objectAtIndex:_indexPathDeleting.row];
            [cart deleteInBackground];
            
            [dataSource removeObjectAtIndex:_indexPathDeleting.row];
            
            [self reloadSection:0];
            
            [self updateBottomLabels];
        }
    }
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBDeliveryMethodsViewDelegate
- (void)deliveryMethodsView:(FMBDeliveryMethodsView *)view selectDeliveryMethod:(PFObject *)deliveryMethod
{
    _deliveryMethod = deliveryMethod;
    
    [self updateBottomLabels];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBChooseShippingAddressVCDelegate
- (void)chooseShippingAddressVC:(FMBChooseShippingAddressVC *)controller didSelectShippingAddress:(FMBShippingAddress *)shippingAddress
{
    [self printLogWith:@"chooseShippingAddressVC: didSelectShippingAddress"];
    
    _shippingAddress = shippingAddress;
    
    [self updateShippingAddressLabel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMBChooseCardVCDelegate
- (void)chooseCardVC:(FMBChooseCardVC *)controller didSelectCard:(PKCard *)card
{
    [self printLogWith:@"chooseCardVC: didSelectCard"];
    
    _pk_card = card;
    
    [self updateCardLabel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_CHOOSECARD])
    {
        FMBChooseCardVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate = self;
        vc.backgroundName = kFMBackgroundNameStore;
    }
    if ([segue.identifier isEqualToString:SEGID_CHOOSESHIPPINGADDRESS])
    {
        FMBChooseShippingAddressVC *vc = [FMBUtil vcFromSegue:segue];
        vc.delegate = self;
        vc.backgroundName = kFMBackgroundNameStore;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Charging Functions
- (void)doCheckout
{
    [self printLogWith:@"doCheckout"];
    
//    [self orderProcessDidSucceedWithOrder:nil];
//    return;
    
    [FMBUtil showHUD:self.hud withText:@"Authorizing..."];
    
    STPCard *card = [[STPCard alloc] init];
    card.number   = self.pk_card.number;
    card.expMonth = self.pk_card.expMonth;
    card.expYear  = self.pk_card.expYear;
    card.cvc      = self.pk_card.cvc;
    
    [Stripe createTokenWithCard:card
                 publishableKey:[FMBUtil stripePublishableKey]
                     completion:^(STPToken *token, NSError *error)
     {
         if (error)
         {
             [self.hud hide:YES];
             [[FMBUtil generalAlertWithTitle:ALERT_TITLE_ERROR message:[error localizedDescription] delegate:nil] show];
         }
         else
         {
             [self doChargeWithToken:token];
         }
     }];
}

- (void)doChargeWithToken:(STPToken *)token
{
    [self printLogWith:@"doChargeWithToken"];
    [FMBUtil showHUD:self.hud withText:@"Charging..."];
    
    NSDictionary *params = [self requestParamsWithToken:token];
    
    [PFCloud callFunctionInBackground:@"buyerCheckOutProducts"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [[FMBUtil generalAlertWithTitle:ALERT_TITLE_ERROR
                                     message:[FMBUtil errorStringFromParseError:error WithCode:NO]
                                    delegate:nil] show];
         }
         else
         {
             // Checked out successfully
             [self orderProcessDidSucceedWithOrder:object];
         }
     }];
}

- (void)orderProcessDidSucceedWithOrder:(PFObject *)order
{
    [self printLogWith:@"orderProcessDidSucceed"];
    
    [PFObject deleteAllInBackground:dataSource];
    
    [self dismissViewControllerAnimated:YES completion:
    ^{
        UINavigationController *nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBRECEIPT_NC];
        FMBReceiptVC           *vc = [nc viewControllers][0];
        vc.order          = order;
        vc.backgroundName = kFMBackgroundNameStore;
        
        [[FMBUtil appDelegate].menuContainerVC.mainViewController presentViewController:nc animated:YES completion:nil];
    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:kFMOrderClassKey];
//    [query whereKey:kPFObjectObjectIDKey equalTo:@"jDr1RJvaPi"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error)
//        {
//        }
//        else
//        {
//            [self dismissViewControllerAnimated:NO completion:^{
//                
//                UINavigationController *nc = [FMBUtil instantiateViewControllerBySBID:SBID_FMBRECEIPT_NC];
//                FMBReceiptVC *vc = [nc viewControllers][0];
//                vc.order = objects[0];
//                
//                [[FMBUtil appDelegate].menuContainerVC.mainViewController presentViewController:nc animated:YES completion:nil];
//            }];
//        }
//    }];
}

- (NSDictionary *)requestParamsWithToken:(STPToken *)token
{
    [self printLogWith:@"requestParams"];
    
    NSDictionary *res = @{
                          @"cardToken":     token.tokenId,
                          @"cart" :         [FMBCartUtil cartRequestParamFromCart:dataSource],
                          @"totalPrice":@([FMBCartUtil grandTotalPriceFromCart:dataSource withDeliveryMethod:_deliveryMethod]),
                          @"salesTax":      @([FMBCartUtil salesTaxFromCart:dataSource]),
                          @"shippingMethod": _deliveryMethod ? _deliveryMethod.objectId : @"",
                          @"shippingRate":  @([FMBCartUtil shippingRateFromObject:_deliveryMethod]),
                          @"street" :        _shippingAddress.streeAddress?_shippingAddress.streeAddress:@"",
                          @"city":          _shippingAddress.city?_shippingAddress.city:@"",
                          @"state":         _shippingAddress.state?_shippingAddress.state:@"",
                          @"zipCode":       _shippingAddress.zipCode?_shippingAddress.zipCode:@"",
                          @"country":       _shippingAddress.countryCode?_shippingAddress.countryCode:@"",
                          @"phone":         _shippingAddress.phoneNumber?_shippingAddress.phoneNumber:@"",
                          @"email":         _shippingAddress.email?_shippingAddress.email:@"",
                          };
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    // Check if cart is empty
    if ([dataSource count] ==0)
    {
        NSString *msg = @"No products to check out. Please scan products you want to order.";
        [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
        
        return NO;
    }
    
    // Check if an order is out of stock or an ordered quantity is zero
    for (int i=0; i<[dataSource count]; i++)
    {
        PFObject *product = [dataSource[i] objectForKey:kFMCartProductKey];
        
        int stock = [product[kFMProductQuantityKey] intValue];
        
        int orderedQuantity = [[dataSource[i] objectForKey:kFMCartQuantityKey] intValue];
        
        if (orderedQuantity <= 0)
        {
            NSString *msg = @"The order quantity should not be zero. Please fix it and try again.";
            [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
            
            return NO;
        }
        
        if (orderedQuantity > stock)
        {
            NSString *msgFormat = @"The current stock of product: %@ is %d. Please fix it and try again.";
            NSString *msg       = [NSString stringWithFormat:msgFormat, product[kFMProductTitleKey], [product[kFMProductQuantityKey] intValue]];
            
            [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
            
            return NO;
        }
    }
    
    if ([FMBUtil isObjectNotEmpty:_deliveryMethod] &&
        ![kFMDeliveryMethodNamePickUpValue isEqualToString:_deliveryMethod[kFMDeliveryMethodNameKey]] &&
        [FMBUtil isObjectEmpty:_shippingAddress])
    {
        NSString *msg = @"Please choose your shipping address.";
        [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
        
        return NO;
    }
    
    if ([FMBUtil isObjectEmpty:_pk_card])
    {
        NSString *msg = @"Please choose your credit card.";
        [[FMBUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
        
        return NO;
    }

    return YES;
}

@end
