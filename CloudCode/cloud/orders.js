//
//  orders.js
//  Store
//
//  Created by Cheng Xian on 9/23/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get list of total orders for TotalOrders Sub Page of Dashboard Page
 * 
 * Expected Input:
 *			request.params.skip: 			Number of objects to skip
 *			request.params.searchString: 	A string to be filtered
 *
 * Expected Output: 
 *			orders: Array of recent orders of any status
 */
Parse.Cloud.define("getTotalOrders", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var query = new Parse.Query(constants.kFMOrderClassKey);

		// Set up query
		query.include(constants.kFMOrderCustomerKey);
		query.include(constants.kFMOrderProductsKey);
		query.include(constants.kFMOrderStatusKey);

		if (request.params.searchString)
		{
			var innerQuery = new Parse.Query(constants.kFMProductClassKey);
			innerQuery.matches(constants.kFMProductTitleKey, request.params.searchString, 'i');

			query.matchesQuery(constants.kFMOrderProductsKey, innerQuery);
		}

		query.descending(constants.kPFObjectCreatedAtKey);
		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerTotalOrders));

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
	}).then(function(orders)
	{
		if (!orders) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(orders);
	});
});


/*
 * Get list of pending orders for TotalOrders Sub Page of Dashboard Page
 * 
 * Expected Input:
 *			request.params.skip: 			Number of objects to skip
 *			request.params.searchString: 	A string to be filtered
 *
 * Expected Output: 
 *			orders: Array of orders of pending status
 */
Parse.Cloud.define("getPendingOrders", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var query = new Parse.Query(constants.kFMOrderClassKey);

		// Set up query
		query.include(constants.kFMOrderCustomerKey);
		query.include(constants.kFMOrderProductsKey);
		query.include(constants.kFMOrderStatusKey);

		if (request.params.searchString)
		{
			var innerQuery = new Parse.Query(constants.kFMProductClassKey);
			innerQuery.matches(constants.kFMProductTitleKey, request.params.searchString, 'i');
			
			query.matchesQuery(constants.kFMOrderProductsKey, innerQuery);
		}

		var innerQuery2 = new Parse.Query(constants.kFMOrderStatusClassKey);
		innerQuery2.equalTo(constants.kFMOrderStatusNameKey, constants.kFMOrderStatusNamePendingValue);
		query.matchesQuery(constants.kFMOrderStatusKey, innerQuery2);

		query.descending(constants.kPFObjectCreatedAtKey);
		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerPendingOrders));

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
	}).then(function(orders)
	{
		if (!orders) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(orders);
	});
});

/*
 * Get list of previous orders for a user in Buyer App
 * 
 * Expected Input:
 *			request.params.skip: 			Number of objects to skip
 *			request.params.searchString: 	A string to be filtered
 *
 * Expected Output: 
 *			orders: Array of recent orders of any status
 */
Parse.Cloud.define("getPreviousOrders", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var query = new Parse.Query(constants.kFMOrderClassKey);

		// Set up query
		query.include(constants.kFMOrderCustomerKey);
		query.include(constants.kFMOrderProductsKey);
		query.include(constants.kFMOrderStatusKey);

		if (request.params.searchString)
		{
			var innerQuery = new Parse.Query(constants.kFMProductClassKey);
			innerQuery.matches(constants.kFMProductTitleKey, request.params.searchString, 'i');

			query.matchesQuery(constants.kFMOrderProductsKey, innerQuery);
		}

		query.equalTo(constants.kFMOrderCustomerKey, request.user);
		query.descending(constants.kPFObjectCreatedAtKey);
		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerPreviousOrders));

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
	}).then(function(orders)
	{
		if (!orders) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(orders);
	});
});