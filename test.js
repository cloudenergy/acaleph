var gateway = require('./gateway/email'),
	emailComposer = require('./libs/email'),
	events = require('./libs/events'),
	_ = require('underscore'),
	fs = require('fs');

var template_data = {
		data: {
			name: '迪诺水镇',
			account: '2132010105',
			project: '迪诺水镇',
			time_range: '2016年5月',
			bills: {
				electricity: '116',
				property: '583'
			},
			amount: '123112.1',
			balance: '12992.1',
			devices: [
				{name: '设备1', type: '通讯故障', time: '2016-05-01 12:00', location:'A区', code: 'COMM'}
			],
			list: [
				{title: '1', count: 10, amount: 1656},
				{title: '2', count: 12, amount: 5324}, 
				{title: '3', count: 1, amount: 1295}
			]
		}
	};

_.each(events, function(val, key){
	var eventType = key,
	template = emailComposer.compile(eventType, template_data);
 
	var mail = {
			title: val.title,
			content: template,
			attachment: []
		},
		target = '910599438@qq.com';

	// fs.writeFile('./test.html', template, 'utf8');
	gateway.Send(target, JSON.stringify(mail));
})
