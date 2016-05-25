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

handlebars.registerHelper('ifEqual', function(v1, v2, options) {
    if (v1 === v2) {
        return options.fn(this);
    }
    return options.inverse(this);
});

// 生成 email 模板
module.exports = {
    compile: function(templateName, data) {
        var filePath = tempPath + templateName + '.html';
        console.log('file: ', filePath);
        var html = handlebars
            .compile(fs
                .readFileSync(filePath, 'utf8'))(data);

        return html;
    }
}
