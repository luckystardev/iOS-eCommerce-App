//
//  checkout_util.js
//  Store
//
//  Created by Cheng Xian on 9/21/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants 	= require('cloud/constants.js');

/*
 * Make cart with Product objects included from products and request param's cart
 */
exports.getCartWithProductsIncludedFromRequestParamCart = function(products, cart)
{
	var res = [];

	for (var kk in cart)
	{
		var tt = cart[kk];

		var productId = tt[constants.kFMCartProductKey];
		var product   = exports.getProductFromListById(products, productId);

		tt[constants.kFMCartProductKey] = product;

		res.push(tt);
	}

	return res;
}

/*
 * Get product from array of products by productId
 */
exports.getProductFromListById = function(products, productId)
{
	for (var k in products)
	{
		var product = products[k];

		if (product.id == productId)
		{
			return product;
		}
	}

	return null;
};

/*
 * Get array of product IDs from cart
 */
exports.getProductIdListFromCart = function(cart)
{
	var res = [];
	for (var kk in cart)
	{
		var productId = cart[kk][constants.kFMCartProductKey];
		res.push(productId);
	}
	return res;
};

/*
 * Get array of quantities from reuest.params.cart
 */
exports.getQuantitiesFromCart = function(cart)
{
	var res = [];
	for (var kk in cart)
	{
		var productId = cart[kk][constants.kFMCartQuantityKey];
		res.push(productId);
	}
	return res;
};

/*
 * Get array of prices at the point when items of cart being ordered
 */
exports.getPricesFromProducts = function(products)
{
	var res = [];
	for (var k in products)
	{
		var product = products[k];

		res.push(product.get(constants.kFMProductPriceKey));
	}

	return res;
};

/*
 * Get array of updated products with decreased quantities from cart
 */
exports.updatedProductsWithDecreasedQuantitiesFromCart = function(cart)
{
	var res = [];
	
	// Dcrease the quantity for each product
	for (var p in cart)
	{		
		var orderedProduct 	= cart[p][constants.kFMCartProductKey];
		var orderedQuantity = cart[p][constants.kFMCartQuantityKey];
		var newQuantity 	= orderedProduct.get(constants.kFMProductQuantityKey) - orderedQuantity;

		orderedProduct.set(constants.kFMProductQuantityKey, newQuantity);

		res.push(orderedProduct);
	}

	return res;
};

/*
 * Make sure a concurrent request didn't take the last item.
 * Returns a message if a product is out of stock.
 */
exports.checkUpdatedProductsOutOfStock = function(products)
{
	var res = "";

	for (var k in products)
	{
		var product = products[k];
		if (product.get(constants.kFMProductQuantityKey) < 0) 
	    { 
	    	// can be 0 if we took the last
	    	if (res == "")
	    	{
	    		res = res + product.get(constants.kFMProductTitleKey);
	    	}
	    	else
	    	{
	    		res = res + ", " + product.get(constants.kFMProductTitleKey);
	    	}
	    }
	}

	return res;
}