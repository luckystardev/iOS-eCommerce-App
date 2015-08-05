//
//  customer_message.js
//  Store
//
//  Created by Cheng Xian on 9/26/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get list of messsages for Customer Message Page
 * 
 * Expected Input:
 *			request.params.skip: 	Number of objects to skip
 *			request.params.other:   Another user's objectId of the message
 *
 * Expected Output: 
 *			messages: 				List of messages
 */
Parse.Cloud.define("getMessagesInCustomerMessagePage", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var otherUser = new Parse.User();
		otherUser.id  = request.params.other;

		// Set up query1 (For messages from current user to the other)
		var query1 = new Parse.Query(constants.kFMMessageClassKey);
		query1.equalTo(constants.kFMMessageFromKey, request.user);
		query1.equalTo(constants.kFMMessageToKey, otherUser);

		// Set up query2 (For messages from the other user to the current user)
		var query2 = new Parse.Query(constants.kFMMessageClassKey);
		query2.equalTo(constants.kFMMessageFromKey, otherUser);
		query2.equalTo(constants.kFMMessageToKey, request.user);

		// Set up main query with query1 and query2
		var query = new Parse.Query.or(query1, query2);

		query.include(constants.kFMMessageFromKey);
		query.include(constants.kFMMessageToKey);
		query.descending(constants.kPFObjectUpdatedAtKey);
		query.skip(request.params.skip);
		query.limit(config.get(constants.kFMConfigLimitPerCustomerMessage));

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
	}).then(function(messages)
	{
		if (!messages) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(messages);
	});
});

/*
 * Get the latest messages from the other user ( This is for real time chat. )
 * 
 * Expected Input:
 *			request.params.lastDate: 	Date of the lastly loaded message
 *			request.params.other:   	Another user's objectId of the message
 *
 * Expected Output: 
 *			messages: 				List of messages
 */
Parse.Cloud.define("getLatestMessagesInCustomerMessagePage", function(request, response)
{
	var mainQuery = function(config, request)
	{
		var otherUser = new Parse.User();
		otherUser.id  = request.params.other;

		// Set up query
		var query = new Parse.Query(constants.kFMMessageClassKey);
		
		query.equalTo(constants.kFMMessageFromKey, otherUser);
		query.equalTo(constants.kFMMessageToKey, request.user);
		query.greaterThan(constants.kPFObjectUpdatedAtKey, request.params.lastDate);
		query.include(constants.kFMMessageFromKey);
		query.include(constants.kFMMessageToKey);

		query.descending(constants.kPFObjectUpdatedAtKey);
		query.limit(config.get(constants.kFMConfigLimitPerCustomerMessage));

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
	}).then(function(messages)
	{
		if (!messages) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(messages);
	});
});