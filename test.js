var messager = require('./api/messager'),
	events = require('./libs/events'),
	_ = require('underscore'),
	fs = require('fs');

require('./libs/log')('acaleph');

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
				{title: '设备1', type: '通讯故障', time: '2016-05-01 12:00', location:'A区', code: 'COMM', 'did': '12ddrjdWNDblf12dkadk'}
			],
			list: [
				{title: '1', count: 10, amount: 1656},
				{title: '2', count: 12, amount: 5324}, 
				{title: '3', count: 1, amount: 1295}
			]
		},
		device: {
			name: '迪诺水镇', 
			device: '设备1',
			type: '通讯故障', 
			time: '2016-05-01 12:00', 
			location:'A区', 
			code: 'COMM',
			amount: '1482.1',
			balance: '-1929',
			bank: '招商银行',
			fee: '10 元'
		}
	};

var users =[
	{
	  "_id": "oVO8Aj5i4BU-tGNjIuRjCWW5fwaY",
	  "user": "13735570920",
	  "platformid": "gh_e8d031d150e4"
	},
	{
	  "_id": "oVO8Aj5sr-Jz7WCZZp3d1JauU7mE",
	  "user": "13735570920",
	  "platformid": "gh_e8d031d150e4"
	},
	{
	  "_id": "oVO8Aj66yWWJOPGwKAx36lxKLUM8",
	  "user": "13735570920",
	  "platformid": "gh_e8d031d150e4"
	},
	{
	  "_id": "oVO8Aj6MCWcYY_5s68nmaUezO87c",
	  "user": "13735570920",
	  "platformid": "gh_e8d031d150e4"
	},
	{
	  "_id": "oVO8Aj8ADXPQt6tP1eMk2pdazvY0",
	  "user": "13735570920",
	  "platformid": "gh_e8d031d150e4"
	}
];

users = [
	{
	  "_id": "oVO8Aj7-yPPeVSbeh3KdJUQ8dGoQ",
	  "user": "lj",
	  "platformid": "gh_e8d031d150e4"
	}
];

// _.each(users, function(val, index){
// 	send_all_events(val, '')
// })

// return;
