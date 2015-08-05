//
//  wallet.js
//  Store
//
//  Created by Cheng Xian on 9/28/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants 	= require('cloud/constants.js'),
	myStripeMod = require('cloud/mystripe.js');

var Mailgun = require('mailgun');
Mailgun.initialize("sandbox16334.mailgun.org", "");

/*
 * Get balance of Stripe
 * 
 * Expected Input:
 *
 * Expected Output: 
 *			balance: {"pending":0.0, "available":0.0};
 */
Parse.Cloud.define("getBalance", function(request, response)
{
	Parse.Cloud.useMasterKey();

	var getTotalAvailableAmount = function(balance)
	{
		var res = 0.0;

		for (var k in balance.available)
		{
			res = res + balance.available[k].amount / 100.0; // convert it into 1 dollar unit since it expressed as cents
		}
		return res;
	};

	var getTotalPendingAmount = function(balance)
	{
		var res = 0.0;

		for (var k in balance.pending)
		{
			res = res + balance.pending[k].amount / 100.0; // convert it into 1 dollar unit since it expressed as cents
		}
		return res;
	};

	var getBalance = function(balance)
	{
		var res = new Object();

		res[constants.kFMBalanceAvailableKey] 	= getTotalAvailableAmount(balance);
		res[constants.kFMBalancePendingKey] 	= getTotalPendingAmount(balance);

		return res;
	};

	Parse.Promise.as().then(function()
	{
		return myStripeMod.getBalance().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);	
		});
	}).then(function(balance)
	{
		if (!balance) return Parse.Promise.error('Sorry, problem occured in server');

		console.log("Stripe Balance: "); console.log(balance);

		var res = getBalance(balance);

		response.success(res);
	});
});

/*
 * Withdraw some amount from Stripe Merchant Account of FlypBox to User's bank account
 *
 * Expected Input (in request.params)
 *			withdrawAmount: Number, the amount to be withdrawn
 *				 bankToken: String, the bank token returned to the user from Stripe
 *
 * Expected Output (in request.response)
 *			"Success": will be returned on success
 */
Parse.Cloud.define("withdrawBalance", function(request, response)
{
	Parse.Cloud.useMasterKey();

	var name  = request.user.get(constants.kFMUserFirstNameKey) + " " + request.user.get(constants.kFMUserLastNameKey),
		type  = 'individual',
		email = request.user.get('email'),
		bankAccountId;

	Parse.Promise.as().then(function()
	{
		// Collect recipient details
		return myStripeMod.createRecipient(
		{
			name: 		  name,
			type: 		  type,
			bank_account: request.params.bankToken,
			email: 		  email
		}).then(null, function(error)
		{
			console.log('Creating recipient with bank token failed. Error:' + error);
			return Parse.Promise.error('An error has occurred. You withdrawal request was not processed.');
		});
	}).then(function(recipient)
	{
		bankAccountId = recipient.active_account.id;

		// Create transfer
		return myStripeMod.createTransfer(
		{
			amount: 		  request.params.withdrawAmount * 100,
			currency: 		  'usd',
			recipient: 		  recipient.id,
			description: 	  'Transfer for ' + email,
			bank_account: 	  bankAccountId,
		}).then(null, function(error)
		{
			console.log('Creating transfer with recipient failed. Error:' + error);
			return Parse.Promise.error('An error has occurred. You withdrawal request was not processed.');
		});
	}).then(function(transfer)
	{
		console.log("After Creating Transfer: "); console.log(transfer);

		if (transfer.failure_code)
		{
			return Parse.Promise.error(transfer.failure_message);
		}
		// Transfered done
		// Then update the user's balance
		request.user.set('balance', request.user.get('balance') - request.params.withdrawAmount)
		
		return request.user.save().then(null, function(error)
		{
			console.log('Updating user\'s balance failed. Error: ' + error);
			return Parse.Promise.error('A critical error has occurred with your withdrawal. Please ' + 
			                         'contact flypbox@flypbox.com at your earliest convinience. ');
		});
	}).then(function(result)
	{
		// Generate the email body string.
	    var body = "We've received your withdrawal request for amount: $ " + request.params.withdrawAmount + "\n";
	               
	    body += "\nIt will take 5 - 7 business days to complete the transaction." + 
	            "Let us know if you have any questions!\n\n" +
	            "Thank you,\n" +
	            "The Flypbox Team";

	    // Send the email.
	    return Mailgun.sendEmail(
	    {
			to: 	 email,
			from: 	 'Store@Store.com',
			subject: 'Your withdrawal request was successful!',
			text: 	 body
	    }).then(null, function(error) 
	    {
			return Parse.Promise.error('Your withdrawal was successful, but we were not able to ' +
			                         'send you an email. Contact us at flypbox@flypbox.com if ' +
			                         'you have any questions.');
	    });	
	}).then(function()
	{
		response.success('Success');
	}, function(error)
	{
		response.error(error);
	});
});