//
//  message_board.js
//  Store
//
//  Created by Cheng Xian on 9/22/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get list of messsages for Message Board Page
 * 
 * Expected Input:
 *			request.params.skip: 	Number of objects to skip
 *
 * Expected Output: 
 *			messages: 				List of messages
 */
Parse.Cloud.define("getMessagesInMessageBoardPageWithFilterParams", function(request, response)
{
	var mainQuery = function(config, request)
	{
		// Set up query
		var query = new Parse.Query(constants.kFMMessageClassKey);
		query.equalTo(constants.kFMMessageToKey, null);
		query.include(constants.kFMMessageFromKey);

		query.descending(constants.kPFObjectUpdatedAtKey);
		query.limit(config.get(constants.kFMConfigLimitPerMessageBoard));
		
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
 * Get the latest messages for Message Board ( This is for real time chat. )
 * 
 * Expected Input:
 *			request.params.lastDate: 	Date of the lastly loaded message
 *
 * Expected Output: 
 *			messages: 				List of messages
 */
Parse.Cloud.define("getLatestMessagesInMessageBoardPageWithFilterParams", function(request, response)
{
	var mainQuery = function(config, request)
	{
		// Set up query
		var query = new Parse.Query(constants.kFMMessageClassKey);
		
		query.equalTo(constants.kFMMessageToKey, null);
		query.greaterThan(constants.kPFObjectUpdatedAtKey, request.params.lastDate);
		query.include(constants.kFMMessageFromKey);

		query.descending(constants.kPFObjectUpdatedAtKey);
		query.limit(config.get(constants.kFMConfigLimitPerMessageBoard));

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