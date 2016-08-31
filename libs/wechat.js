'use strict';
var events = require('./events'),
	_ = require('underscore'),
	moment = require('moment'),
	handlebars = require('handlebars');
	require('./helpers')(handlebars);

module.exports = {
	compile : function(msg, type){
		var event = events[type].wechat,
			keywords = event.keywords,
			data = {};

		// 编译 first
		if (event.first) {
			data.first = {
				value: handlebars.compile(event.first)(msg), 
				color: event.theme
			};
		}
		// console.log('data first: ', data, msg);

		_.each(keywords, function(val, key){
			data[key] = {
				value: handlebars.compile(val[0])(msg),
				color: val[1]
			}
		})

		var compiled = {
		    'url': '',
		    'template_id': event.template,
			'data': data,
			'topcolor': event.theme
		};
		return compiled;
	}
}