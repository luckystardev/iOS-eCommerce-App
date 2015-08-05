//
//  message.js
//  Store
//
//  Created by Cheng Xian on 9/22/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js'),
	utilsMod  = require('cloud/utils.js');

/*
 * Send push notification after a message saved
 */
Parse.Cloud.afterSave(constants.kFMMessageClassKey, function(request, response) 
{
	Parse.Cloud.useMasterKey();

	var savedMessage = request.object;

	var query = new Parse.Query(Parse.Installation),
		pushMessage = "", payloadType = "", separator	 = "\n"; 

	// Set up push message
	pushMessage	 	 = utilsMod.trimmedTextForPushNotification(savedMessage.get(constants.kFMMessageTextKey));

	if (request.object.get(constants.kFMMessageToKey))
	{
		// Send push to toUser Installation
		query.equalTo(constants.kFMInstallationUserKey, savedMessage.get(constants.kFMMessageToKey));

		var messageTitle = "Message from " + request.user.get(constants.kFMUserFirstNameKey);
		pushMessage 	 = messageTitle + separator + pushMessage;		
		payloadType 	 = "m2m"; // Message from a user to a user
	}
	else
	{
		// Send push notification to the employees including managers (since this is for Message Board.)
		var innerQuery = new Parse.Query(constants.kFMUserClassKey);
		innerQuery.notEqualTo(constants.kFMUserRoleKey, constants.kFMUserRoleBuyer);

		query.matchesQuery(constants.kFMInstallationUserKey, innerQuery);

		var messageTitle = request.user.get(constants.kFMUserFirstNameKey) + " posted on Message Board.";
		pushMessage 	 = messageTitle + separator + pushMessage;
		payloadType 	 = "m4b"; // Message for Message Board
	}

	// Send push notification to the target user
	var pushData =	
	{
		alert: 	pushMessage,
		badge: 	0,
		sound:  '',
		p: 		payloadType, 									// Payload Type: Message from a user to a user
		fuid: 	request.user.id, 								// ObjectId of Sending User
		fue: 	request.user.get(constants.kFMUserEmailKey),	// Email of Sender
		mid: 	savedMessage.id, 								// ObjectId of the saved message
	}

	var toUserID = savedMessage.get(constants.kFMMessageToKey).id;
	if (toUserID == 'LJXU3YI4qE' || toUserID == 'CRfzzvPSGP' || toUserID == 'CTdyOISgwB')
	{

	}
	else
	{
		return Parse.Push.send(
		{
			where: 	query,
			data: 	pushData
		}).then(null, function(error)
		{
			console.log(error);
			return Parse.Promise.error(error);
		});
	}
});