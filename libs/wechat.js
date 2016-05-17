var events = require('./events'),
	_ = require('underscore'),
	Handlebars = require('handlebars');

module.exports = {
	compile : function(msg, type){
		var event = events[type].wechat,
			keywords = event.keywords,
			data = {};

		// 编译 first
		if (event.first) {
			data.first = {
				value: Handlebars.compile(event.first)(msg), 
				color: event.theme
			};
		}

		_.each(keywords, function(val, key){
			data[key] = {
				value: msg[val[0]],
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