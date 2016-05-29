'use strict';
var	_ = require('underscore'),
	moment = require('moment'),
	handlebars = require('handlebars'),
	sensors = {
		'ELECTRICITYMETER': '电表',
		'COLDWATERMETER': '冷水表',
		'HOTWATERMETER': '热水表',
		'ENERGYMETER': '能量表',
		'TEMPRATURECONTROL': '温控器'
	},
	eventType = {
		'COMMUNICATION' : '通讯异常',
		'DATA': '数据异常'
	};


module.exports = (handlebars) => {

	handlebars.registerHelper("date", function(timestamp, format) {
		if (!timestamp) {
			return moment().format('YYYY-MM-DD HH:mm');
		}
	    return moment.unix(timestamp).format('YYYY-MM-DD HH:mm');
	});

	handlebars.registerHelper("month", function(timestamp) {
		if (!timestamp) {
			return moment().format('YYYY年MM月');
		}
	    return moment.unix(timestamp).format('YYYY年MM月');
	});

	handlebars.registerHelper("eventType", function(obj) {
		var events = '';
		_.each(obj, (item)=>{
			events = eventType[item.type];
		});
		return events;
	})
	handlebars.registerHelper("sensor", function(obj) {
		let temp = {};
		_.each(obj, (item) => {
			temp[item.devicetype] = temp[item.devicetype] ? ++temp[item.devicetype] : 1;
		})
		let str = _.reduce(temp, (pre, item, key) => {
			return `${pre} `+sensors[key]+` ${item}个`;
		}, '')
	    return str;
	});

	handlebars.registerHelper('ifEqual', function(v1, v2, options) {
	    if (v1 === v2) {
	        return options.fn(this);
	    }
	    return options.inverse(this);
	});

	handlebars.registerHelper("date", function(timestamp) {
	    return moment.unix(timestamp).format('YYYY-MM-DD HH:mm');
	});

	handlebars.registerHelper("length", function(obj) {
	    return Object.keys(obj).length;
	});

	handlebars.registerHelper("fixed", function(obj) {
	    return obj.toFixed(2);
	});

	handlebars.registerHelper("event", function(keyword) {
	    return eventType[keyword];
	});
}
