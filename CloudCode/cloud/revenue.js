//
//  revenue.js
//  Store
//
//  Created by Cheng Xian on 9/27/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants 		= require('cloud/constants.js'),
	dashboardUtil 	= require('cloud/dashboard_util.js'),
	_ 				= require('underscore');

/*
 * Calculate the total sum of this month
 * 
 * Expected Input:
 *			request.params.revenues: 	Array of Objects:
 *										 {kFMRevenueLabelKey:Number, kFMRevenueSumKey: Number, 
 *											kFMRevenueStartDate: Date , kFMRevenueEndDate: Date}
 *
 * Expected Output: 
 *			revenues: request.params.revenues with Rvenue Sum calculated by Start and End Date
 */
Parse.Cloud.define("getRevenueGraphData", function(request, response)
{
	var mainQuery = function(data)
	{
		// Set up query
		var query = new Parse.Query(constants.kFMOrderClassKey);
		
		query.greaterThanOrEqualTo(constants.kPFObjectCreatedAtKey, data[constants.kFMRevenueStartDate]);
		query.lessThanOrEqualTo(constants.kPFObjectCreatedAtKey, 	data[constants.kFMRevenueEndDate]);
		query.select(constants.kFMOrderTotalPriceKey);

		return query;
	};

	Parse.Cloud.useMasterKey();

	var revenues = [];

	Parse.Promise.as().then(function()
	{
		var promise = Parse.Promise.as();
		_.each(request.params.revenues, function(data)
		{
			var kk = data;
			promise = promise.then(function()
			{
				var query = mainQuery(data);
				return query.find();
			}).then(function(orders)
			{
				kk[constants.kFMRevenueSumKey] = dashboardUtil.totalRevenue(orders);
				revenues.push(kk);
			});
		});
		return promise;
	}).then(function()
	{	
		response.success(revenues);
	}, 
	function(error)
	{
		console.log(error.code + " : " + error.message);
	});
});