//
//  deals.js
//  Store
//
//  Created by Cheng Xian on 9/26/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get list of products for Discounts & Deals Page in Buyer App
 * 
 * Expected Input:
 *			request.params.skip: 			Number of objects to skip
 *			request.params.searchString: 	A string to be filtered
 *
 * Expected Output: 
 *			products: Array of products
 */
Parse.Cloud.define("getProductsInDeals", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var query = new Parse.Query(constants.kFMProductClassKey);

		// Set up query
		if (request.params.searchString)
		{
			query.matches(constants.kFMProductTitleKey, request.params.searchString, 'i');
		}

		query.include(constants.kFMProductCategoryKey);
		query.include(constants.kFMProductColorKey);

		query.descending(constants.kPFObjectUpdatedAtKey);
		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerDeals));

		return query;
	};

	Parse.Cloud.useMasterKey();

	var config = Parse.Config.current();

	Parse.Promise.as().then(function()
	{
		return Parse.Config.get().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(result)
	{
		if (result)
		{
			config = result;
		}

		var query = mainQuery(config, request);	
		
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(products)
	{
		if (!products) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(products);
	});
});