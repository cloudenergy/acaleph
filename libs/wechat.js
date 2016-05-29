var events = require('./events'),
	_ = require('underscore'),
	Handlebars = require('handlebars');

Handlebars.registerHelper("date", function(timestamp) {
    return new Date(timestamp).toString('yyyy-MM-dd HH:mm')
});

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
		console.log('data first: ', data, msg);

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