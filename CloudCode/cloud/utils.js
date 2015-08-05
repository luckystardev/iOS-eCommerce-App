//
//  utils.js
//  Store
//
//  Created by Cheng Xian on 9/20/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants 	= require('cloud/constants.js');

/*
 *
 */
exports.roundNumber = function(num)
{
	return Number((num).toFixed(2));
};

/*
 * Limit the length of text for push notification
 */
exports.trimmedTextForPushNotification = function(text)
{
	var res = text;
	if (res.length > 200)
	{
		res = res.substr(0, 200);
	}
	return res;
}

/*
 * Find OrderStatus from array of OrderStatus objects by a OrderStatusName value
 */
exports.getOrderStatusByNameValue = function(orderStates, value)
{
	for (var k in orderStates)
	{
		var status = orderStates[k];

		if (status.get(constants.kFMOrderStatusNameKey) == value)
		{
			return status;
		}
	}

	return null;
};

/*
 * Find DeliveryMethod from array of DeliveryMethod objects by a DeliveryMethodName value
 */
exports.getDeliveryMethodByNameValue = function(deliveryMethods, value)
{
	for (var k in deliveryMethods)
	{
		var method = deliveryMethods[k];

		if (method.get(constants.kFMDeliveryMethodNameKey) == value)
		{
			return method;
		}
	}

	return null;
};

/*
 * Find DeliveryMethod from array of DeliveryMethod objects by a objectId
 */
exports.getDeliveryMethodById = function(deliveryMethods, value)
{
	for (var k in deliveryMethods)
	{
		var method = deliveryMethods[k];

		if (method.id == value)
		{
			return method;
		}
	}

	return null;
};