//
//  message_customers.js
//  Store
//
//  Created by Cheng Xian on 9/26/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');


/*
 * Get list of customers for a Message Customers page
 * (For now find users with role value of 'Buyer')
 * 
 * Expected Input:
 *			request.params.skip: 	Number of objects to skip
 *
 * Expected Output: 
 *			customers: 				List of customers
 */
Parse.Cloud.define("getCustomersInMessageCustomersPage", function(request, response)
{
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

		var query = new Parse.Query(constants.kFMUserClassKey);

		// Set up query
		query.equalTo(constants.kFMUserRoleKey, constants.kFMUserRoleBuyer);
		query.notEqualTo(constants.kPFObjectObjectIDKey, request.user.id);

		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerMessageCustomers));
		
		return query.find().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
		});
	}).then(function(customers)
	{
		if (!customers) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(customers);
	});
});