//
//  cart.js
//  Store
//
//  Created by Cheng Xian on 9/24/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Add number of products to cart of the current user
 * 
 * Expected Input:
 *			request.params.productId: 	The objectId of a product to be added
 *			request.params.quantity: 	Number of products to be stored on cart
 *
 * Expected Output: 
 *			"Success": will be returned on success
 */
Parse.Cloud.define("addToCart", function(request, response)
{
	Parse.Cloud.useMasterKey();

	var product;

	Parse.Promise.as().then(function()
	{
		// Get the Product with the request objectId from Product Class
		var query = new Parse.Query(constants.kFMProductClassKey);
		query.equalTo(constants.kPFObjectObjectIDKey, request.params.productId);

		return query.first().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});

	}).then(function(result)
	{
		product = result;
		if (!product) { return Parse.Promise.error('Sorry, problem occured in server'); };

		// Check if the same product is already in cart of the user
		var query = new Parse.Query(constants.kFMCartClassKey);
		query.equalTo(constants.kFMCartProductKey, 	product);
		query.equalTo(constants.kFMCartCustomerKey, request.user);
		return query.first().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});
	}).then(function(result)
	{
		var cart = result;

		// Creat new one if it's not in the cart
		if (!cart)
		{
			cart = new Parse.Object(constants.kFMCartClassKey);
			cart.set(constants.kFMCartProductKey,  product);
			cart.set(constants.kFMCartQuantityKey, request.params.quantity);
			cart.set(constants.kFMCartCustomerKey, request.user);
		}
		// Add the quantity to the existing cart if it is already in the cart
		else
		{
			cart.increment(constants.kFMCartQuantityKey, request.params.quantity);
		}

		// Save cart
		return cart.save().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});
	}).then(function(result)
	{
		if (!result) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success('Success');
	});
});