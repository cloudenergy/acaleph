var gateway = require('./gateway/email');
require('./libs/log')('acaleph');
var fs = require('fs');

// 使用 handlebar
var handlebars = require('handlebars'),
    layouts = require('handlebars-layouts');
 
// Register partials 
var tempPath = './libs/templates/';

handlebars.registerPartial('layout', fs.readFileSync(tempPath + 'layout.hbs', 'utf8'));
handlebars.registerHelper(layouts(handlebars));

var template = handlebars
	.compile(fs
		.readFileSync(tempPath +'ntf_accountarrears.html', 'utf8'))({
			data: {
				name: '迪诺水镇',
				account: '2132010105'
			}
		});
 
var data = {
		title: '帐号创建成功',
		content: template,
		attachment: []
	},
	eventType = 'ntf_accountarrears';
	target = '910599438@qq.com, luojieyy@gmail.com';

fs.writeFile('./test.html', template, 'utf8');
gateway.Send(target, JSON.stringify(data));
