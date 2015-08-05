//
//  customer_reviews.js
//  Store
//
//  Created by Cheng Xian on 9/26/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get list of orders completed and got reviews from Customers for Customer Reviews Page
 * 
 * Expected Input:
 *			request.params.skip: 			Number of objects to skip
 *			request.params.searchString: 	A string to be filtered
 *
 * Expected Output: 
 *			orders: Array of recent orders of any status
 */
Parse.Cloud.define("getOrdersInCustomerReviewsPage", function(request, response)
{
	var basicQuery = function(config, request)
	{
		var query = new Parse.Query(constants.kFMOrderClassKey);

		// Set up query
		var innerQuery = new Parse.Query(constants.kFMOrderStatusClassKey);
		innerQuery.equalTo(constants.kFMOrderStatusNameKey, constants.kFMOrderStatusNameCompleteValue);

		query.exists(constants.kFMOrderCustomerKey);
		// query.matchesQuery(constants.kFMOrderStatusKey, innerQuery);

		return query;
	};

	var mainQuery = function(config, request)
	{
		var mainQuery;

		if (request.params.searchString)
		{
			// String match for product title
			var query1 = basicQuery(config, request);
			var innerQuery1 = new Parse.Query(constants.kFMProductClassKey);
			innerQuery1.matches(constants.kFMProductTitleKey, request.params.searchString, 'i');
			query1.matchesQuery(constants.kFMOrderProductsKey, innerQuery1);

			// String match for user first name
			var query2 = basicQuery(config, request);
			var innerQuery2 = new Parse.Query(constants.kFMUserClassKey);
			innerQuery2.matches(constants.kFMUserFirstNameKey, request.params.searchString, 'i');
			query2.matchesQuery(constants.kFMOrderCustomerKey, innerQuery2);

			// String match for customer's comment
			var query3 = basicQuery(config, request);
			query3.matches(constants.kFMOrderReviewCommentKey, request.params.searchString, 'i');

			mainQuery = new Parse.Query.or(query1, query2, query3);			
		}
		else
		{
			mainQuery = basicQuery(config, request);
		}

		mainQuery.include(constants.kFMOrderCustomerKey);
		mainQuery.include(constants.kFMOrderProductsKey);
		mainQuery.include(constants.kFMOrderStatusKey);

		mainQuery.descending(constants.kPFObjectCreatedAtKey);
		mainQuery.skip(request.params.skip);
		mainQuery.limit(config.get(constants.kFMConfigLimitPerCustomerReviews));

		return mainQuery;
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
	}).then(function(orders)
	{
		if (!orders) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(orders);
	});
});