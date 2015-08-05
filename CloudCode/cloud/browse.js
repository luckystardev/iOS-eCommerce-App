
//
//  browse.js
//  Store
//
//  Created by Cheng Xian on 9/15/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get list of products for a browser page
 *
 * Expected Input:
 *			request.params.skip: 			Number of objects to skip
 *			request.params.price1: 			Start price value to be filtered
 *			request.params.price2: 			End price value to be filtered
 *			request.params.searchString: 	String to be searched against product's title and description
 *			request.params.categoryIdList: 	List of category IDs to be filtered
 *
 * Expected Output: 
 *			product: 		List of products matched with filter params
 */
Parse.Cloud.define("getProductsInBrowsePageWithFilterParams", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var query = new Parse.Query(constants.kFMProductClassKey);

		// Set up query
		query.greaterThanOrEqualTo(constants.kFMProductPriceKey, request.params.price1);

		if (request.params.price2 < constants.maxFilterPrice)
		{
			query.lessThanOrEqualTo(constants.kFMProductPriceKey, request.params.price2);
		}
		
		if (request.params.categoryIdList.length > 0)
		{
			var innerQuery = new Parse.Query(constants.kFMCategoryClassKey);
			innerQuery.containedIn(constants.kPFObjectObjectIDKey,request.params.categoryIdList);

			query.include(constants.kFMProductCategoryKey);
			query.matchesQuery(constants.kFMProductCategoryKey, innerQuery);
		}

		if (request.params.searchString)
		{
			query.matches(constants.kFMProductTitleKey, request.params.searchString, 'i');
		}

		query.include(constants.kFMProductCategoryKey);
		query.include(constants.kFMProductColorKey);

		query.descending(constants.kPFObjectUpdatedAtKey);
		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerBrowseKey));

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

		// Find matching products
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});
	}).then(function(products)
	{
		if (!products) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(products);
	});
});