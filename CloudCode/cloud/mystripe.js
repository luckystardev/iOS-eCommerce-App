//
//  mystripe.js
//  Store
//
//  Created by Cheng Xian on 9/21/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var Stripe  = require('cloud/stripe.js').Stripe('');

/*
 * Return Promise for creating charge of Stripe
 */
exports.createCharge = function(data)
{
	var promise = new Parse.Promise();

	Stripe.charges.create(data, function(error, purchase)
	{
		if (error)
		{
			promise.reject(error);
		}
		else
		{
			promise.resolve(purchase)
		}
	});

	return promise;
};

/*
 * Return Promise for creating recipient of Stripe
 */
exports.createRecipient = function(data)
{
	var promise = new Parse.Promise();

	Stripe.recipients.create(data, function(error, recipient)
	{
		if (error)
		{
			promise.reject(error);
		}
		else
		{
			promise.resolve(recipient)
		}
	});

	return promise;
};

/*
 * Return Promise for creating transfer of Stripe
 */
exports.createTransfer = function(data)
{
	var promise = new Parse.Promise();

	Stripe.transfers.create(data, function(error, transfer)
	{
		if (error)
		{
			promise.reject(error);
		}
		else
		{
			promise.resolve(transfer)
		}
	});

	return promise;
};

/*
 * Return Promise for retrieving balance of Stripe
 */
exports.getBalance = function()
{
	var promise = new Parse.Promise();

	Stripe.balance.retrieve(function(error, balance)
	{
		if (error)
		{
			promise.reject(error);
		}
		else
		{
			promise.resolve(balance)
		}
	});

	return promise;
};