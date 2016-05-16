require('./log')('acaleph');
var fs = require('fs');

// 使用 handlebar
var handlebars = require('handlebars'),
    layouts = require('handlebars-layouts');
 
// Register partials 
var tempPath = __dirname + '/templates/';
var _ = require('underscore');

handlebars.registerPartial('layout', fs.readFileSync(tempPath + 'layout.hbs', 'utf8'));
handlebars.registerHelper(layouts(handlebars));

// todo 异步读取文件放入缓存

// 生成 email 模板
module.exports = {
	compile: function(templateName, data){
		var html = handlebars
			.compile(fs
				.readFileSync(tempPath + templateName +'.html', 'utf8'))(data);

		return html;
	}
}