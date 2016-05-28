'use strict';
var fs = require('fs');

// 使用 handlebar
var handlebars = require('handlebars'),
    layouts = require('handlebars-layouts'),
    _ = require('underscore');

// Register partials 
var tempPath = __dirname + '/templates/';

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
        try {
            data = this.decorate(templateName, data);
        } catch(e) {
            // statements
            console.log(e);
        }

        var html = handlebars
            .compile(fs
                .readFileSync(filePath, 'utf8'))(data);

        return html;
    },
    decorate: function(event, data){
        switch (event) {
            case 'ntf_usermonthlyreport':
            case 'ntf_projectdailyreport':
            case 'ntf_projectmonthlyreport':
            case 'ntf_userdailyreport':
                // 解析 data
                var keyLen = {}, list = [], keys = ['earning', 'expenses', 'consumption'];

                keys.forEach( function(element) {
                    keyLen[element] = Object.keys(data.data[element].category);
                });
                
                var max = _.max(keyLen, function(item){
                    return item.length;
                });

                for (var i = 0; i < max.length; i++) {
                    let temp = {}
                    keys.forEach( function(elm, index) {
                        let key = keyLen[elm][i];
                        temp[elm] = data.data[elm].category[key];
                    });

                    list.push(temp);
                }

                data.data.list = list;
                break;
            default:
                // statements_def
                break;
        }
        return data;
    }
};
