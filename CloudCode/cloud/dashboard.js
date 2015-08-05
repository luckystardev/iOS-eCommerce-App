//
//  dashboard.js
//  Store
//
//  Created by Cheng Xian on 9/23/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants 		= require('cloud/constants.js'),
	dashboardUtil 	= require('cloud/dashboard_util.js');

/*
 * Calculate the total sum of this month
 * 
 * Expected Input:
 *			request.params.firstDate: 	firstDate of this month
 *			request.params.lastDate:   	lastDate of this month
 *
 * Expected Output: 
 *			Sum: Total sum of Order's total prices of this month
 */
Parse.Cloud.define("getTotalRevenueInDashboardPageWithParams", function(request, response)
{
	var mainQuery = function(request)
	{
		var otherUser = new Parse.User();
		otherUser.id  = request.params.other;

		// Set up query
		var query = new Parse.Query(constants.kFMOrderClassKey);
		
		query.greaterThanOrEqualTo(constants.kPFObjectCreatedAtKey, request.params.firstDate);
		query.lessThanOrEqualTo(constants.kPFObjectCreatedAtKey, request.params.lastDate);
		query.select(constants.kFMOrderTotalPriceKey);

		return query;
	};

	Parse.Cloud.useMasterKey();

	Parse.Promise.as().then(function()
	{
		var query = mainQuery(request);
		
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error('Sorry, problem occured in server');
		});
	}).then(function(orders)
	{
		if (!orders) { return Parse.Promise.error('Sorry, problem occured in server'); }

		var res = dashboardUtil.totalRevenue(orders);
		
		response.success(res);
	});
});

/*
 * Calculate the total number of reivews of this month
 * 
 * Expected Input:
 *			request.params.firstDate: 	firstDate of this month
 *			request.params.lastDate:   	lastDate of this month
 *
 * Expected Output: 
 *			Number: The total number of reviews of this month
 */
Parse.Cloud.define("getTotalNumberOfReviewsInDashboardPage", function(request, response)
{
	var mainQuery = function(request)
	{
		// Set up query
		var query = new Parse.Query(constants.kFMOrderClassKey);

		var innerQuery = new Parse.Query(constants.kFMOrderStatusClassKey);
		innerQuery.equalTo(constants.kFMOrderStatusNameKey, constants.kFMOrderStatusNameCompleteValue);

		query.exists(constants.kFMOrderCustomerKey)
		// query.matchesQuery(constants.kFMOrderStatusKey, innerQuery);
		query.greaterThanOrEqualTo(constants.kPFObjectCreatedAtKey, request.params.firstDate);
		query.lessThanOrEqualTo(constants.kPFObjectCreatedAtKey, request.params.lastDate);

		return query;
	};

	Parse.Cloud.useMasterKey();

	Parse.Promise.as().then(function()
	{
		var query = mainQuery(request);
		
		return query.count().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error('Sorry, problem occured in server');
		});
	}).then(function(result)
	{
		if (typeof result === 'undefined') { return Parse.Promise.error('Sorry, problem occured in server'); }
		response.success(result);
	}, 
	function(error)
	{
		response.error(error);
	});
});
