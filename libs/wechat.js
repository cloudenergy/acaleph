var events = require('./events'),
	_ = require('underscore'),
	Handlebars = require('handlebars');

module.exports = {
	compile : function(msg, type){
		var event = events[type].wechat,
			keywords = event.keywords,
			data = {};

		// 编译 first
		console.log('msg: ', msg);
		if (event.first) {
			data.first = {
				value: Handlebars.compile(event.first)(msg), 
				color: "#FF0000"
			};
		}

		_.each(keywords, function(val, key){
			console.log("each", val, key);
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
		console.log('compiled: ', compiled);
		return compiled;
	}
}