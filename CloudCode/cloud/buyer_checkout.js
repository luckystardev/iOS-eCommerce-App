//
//  buyer_checkout.js
//  Store
//
//  Created by Cheng Xian on 9/25/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var utilsMod 		= require('cloud/utils.js'),
	myStripeMod 	= require('cloud/mystripe.js'),
	constants 		= require('cloud/constants.js'),
	checkoutUtil 	= require('cloud/checkout_util.js');

var Stripe  = require('cloud/stripe.js').Stripe('');
	Mailgun = require('mailgun');

/*
 * Charge credit card by cardToken and check out the products requested
 *
 * Expected Input:
 *			request.params.cardToken: 			Number of objects to skip
 *			request.params.cart: 				Array of Object: {kFMCartProductKey:, kFMCartQuantityKey:}
 *			request.params.totalPrice:  		Total price of order
 *			request.params.salesTax: 			Sales tax ( stripe fee ) of order
 *			request.params.shippingMethod: 		Delivery Method Id
 *			request.params.shippingRate: 		Delivery Rate
 *			request.params.street: 				Shipping Street Address
 *			request.params.city: 				Shipping City
 *			request.params.state: 				Shipping State
 *			request.params.zipCode: 			Shipping ZIP Code
 *			request.params.country: 			Shipping Country
 *			request.params.phone: 				Phone number of buyer
 *			request.params.email: 				Email of buyer
 *
 * Expected Output: 
 *			order: The order object will be returned on success
 */
Parse.Cloud.define("buyerCheckOutProducts", function(request, response)
{
	Parse.Cloud.useMasterKey();

	var updatedProducts = [], order, orderStates, deliveryMethods;
	var cart = [];

	// Create an array of requested products
	Parse.Promise.as().then(function()
	{
		// Create array of product Ids
		var ids = checkoutUtil.getProductIdListFromCart(request.params.cart);

		// Get all products for ordered by the product id list
		var query = new Parse.Query(constants.kFMProductClassKey);

		query.containedIn(constants.kPFObjectObjectIDKey, ids);
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});
	}).then(function(result)
	{
		if (!result) { return Parse.Promise.error('Sorry, problem occured in server'); }

		cart = checkoutUtil.getCartWithProductsIncludedFromRequestParamCart(result, request.params.cart);
	
		// Fetch all OrderStatus objects
		var query = new Parse.Query(constants.kFMOrderStatusClassKey);
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(result)
	{
		orderStates = result;

		// Fetch all Delivery Method objects
		var query = new Parse.Query(constants.kFMDeliveryMethodClassKey);
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(result)
	{
		deliveryMethods = result;

		updatedProducts = checkoutUtil.updatedProductsWithDecreasedQuantitiesFromCart(cart);

		// Save all objects
		return Parse.Object.saveAll(updatedProducts).then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(result)
	{
		// Make sure a concurrent request didn't take the last item.
		var msgOutOfStock = checkoutUtil.checkUpdatedProductsOutOfStock(result);
		
		if (msgOutOfStock)
		{
			msgOutOfStock = "Sorry, the products: " + msgOutOfStock + " are out of stock.";
			return Parse.Promise.error(msgOutOfStock);
		}

		var orderQuantities 	 = checkoutUtil.getQuantitiesFromCart(request.params.cart);
		var orderPrices			 = checkoutUtil.getPricesFromProducts(updatedProducts);
		var deliveryMethod       = utilsMod.getDeliveryMethodById(deliveryMethods, request.params.shippingMethod);		
		var OrderStatusPending   = utilsMod.getOrderStatusByNameValue(orderStates, constants.kFMOrderStatusNamePendingValue);

		// Create order item
		order = new Parse.Object(constants.kFMOrderClassKey);

		order.set(constants.kFMOrderCustomerKey,		request.user);
		order.set(constants.kFMOrderProductsKey,		updatedProducts);
		order.set(constants.kFMOrderQuantitiesKey,		orderQuantities);
		order.set(constants.kFMOrderPricesKey,			orderPrices);
		order.set(constants.kFMOrderDeliveryRateKey, 	0);
		order.set(constants.kFMOrderChargedKey, 		false);
		order.set(constants.kFMOrderStripeFeeKey, 		request.params.salesTax);
		order.set(constants.kFMOrderDeliveryRateKey, 	request.params.shippingRate);
		order.set(constants.kFMOrderTotalPriceKey, 		request.params.totalPrice);
		order.set(constants.kFMOrderStatusKey,			OrderStatusPending);
		order.set(constants.kFMOrderDeliveryMethodKey,	deliveryMethod);

		order.set(constants.kFMOrderShippingFirstNameKey, 	request.user.get(constants.kFMUserFirstNameKey));
		order.set(constants.kFMOrderShippingLastNameKey, 	request.user.get(constants.kFMUserLastNameKey));
		order.set(constants.kFMOrderShippingStreet1Key,		request.params.street);
		order.set(constants.kFMOrderShippingCityKey,		request.params.city);
		order.set(constants.kFMOrderShippingStateKey,		request.params.state);
		order.set(constants.kFMOrderShippingZIPKey,			request.params.zipCode);
		order.set(constants.kFMOrderShippingCountryKey,		request.params.country);
		order.set(constants.kFMOrderShippingPhoneNumberKey,	request.params.phone);
		order.set(constants.kFMOrderShippingEmailKey,		request.params.email);
		
		// Create new order
		return order.save().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});
	}).then(function(result)
	{
		return myStripeMod.createCharge({
			amount: 	request.params.totalPrice * 100, // express dollars in cents 
			currency: 	'usd',
			card: 		request.params.cardToken
		}).then(null, function(error) 
		{
			console.log('Charging with stripe failed. Error: ' + error);
		 	return Parse.Promise.error('An error has occurred. Your credit card was not charged.');
		});
	}).then(function(purchase)
	{
		// Credit card charged! Now we save the ID of the purchase on our
	    // order and mark it as 'charged'.
	    order.set(constants.kFMOrderStripePaymentIdKey, purchase.id);
	    order.set(constants.kFMOrderChargedKey, true);

	    // Save updated order
	    return order.save().then(null, function(error) 
	    {
			// This is the worst place to fail since the card was charged but the order's
			// 'charged' field was not set. Here we need the user to contact us and give us
			// details of their credit card (last 4 digits) and we can then find the payment
			// on Stripe's dashboard to confirm which order to rectify. 
			return Parse.Promise.error('A critical error has occurred with your order. Please ' + 
			                         'contact info@Store.com at your earliest convinience. ');
	    });
	}).then(function()
	{
		// We're done!
		response.success(order);
	}, function(error)
	{
		response.error(error);
	});
});