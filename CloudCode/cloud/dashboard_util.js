//
//  dashboard_util.js
//  Store
//
//  Created by Cheng Xian on 9/23/14.
//  Copyright (c) 2014 Cheng Xian. All rights reserved.
//

var constants 	= require('cloud/constants.js');

/*
 * Returns the total sum of 'totalPrice' fields from array of orders
 */
exports.totalRevenue = function(orders)
{
	var totalSum = 0.0;
	for (var k in orders)
	{
		totalSum += orders[k].get(constants.kFMOrderTotalPriceKey);
	}

	return totalSum;
};
