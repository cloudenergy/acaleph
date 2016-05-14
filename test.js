var gateway = require('./gateway/email');
require('./libs/log')('acaleph');

var data = {
		title: 'test',
		content: 'test',
		attachement: null
	},
	target = '910599438@qq.com';

gateway.Send(target, JSON.stringify(data));