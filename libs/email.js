// 使用 handlebar
var handlebars = require('handlebars'),
    layouts = require('handlebars-layouts');
 
handlebars.registerHelper(layouts(handlebars));

var tempPath = './templates/';

// 生成 email 模板
module.exports = {
	compile: function(template, date){

	}
}