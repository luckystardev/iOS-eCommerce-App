//
//  scan.js
//  Store
//
//  Created by Cheng Xian on 9/16/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants = require('cloud/constants.js');

/*
 * Get a product with a barcode
 *
 * Expected Input:
 *			request.params.barcode: Barcode string to be searched for a product
 *
 * Expected Output: 
 *			product: 		A product with request barcode
 */
Parse.Cloud.define("getProductByBarcode", function(request, response)
{
	var mainQuery = function(request)
	{
		var query = new Parse.Query(constants.kFMProductClassKey);

		query.include(constants.kFMProductCategoryKey);
		query.include(constants.kFMProductColorKey);
		query.equalTo(constants.kFMProductBarcodeKey, request.params.barcode);
		query.equalTo(constants.kFMProductStatusKey, true);

		return query;
	}

	Parse.Cloud.useMasterKey();

	Parse.Promise.as().then(function()
	{
		var query = mainQuery(request);

		return query.first().then(null, function(error)
		{
			console.log(error.code + " : " + error.message);
			return Parse.Promise.error(error);
		});
	}).then(function(product)
	{
		if (!product) { return Parse.Promise.error('Sorry, problem occured in server'); }

		response.success(product);
	})	
});