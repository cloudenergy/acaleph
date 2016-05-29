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

require('./helpers')(handlebars);

// 生成 email 模板
module.exports = {
    /**
     * /
     * @param  {[type]} templateName [description]
     * @param  {[type]} data         {param: {}, target: 'business'}
     * @return {[type]}              [description]
     */
    compile: function(templateName, param) {
        var filePath = tempPath + templateName + '.html';
        try {
            param.data = this.decorate(templateName, param.data);
        } catch(e) {
            // statements
            console.log(e);
        }

        var html = handlebars
            .compile(fs
                .readFileSync(filePath, 'utf8'))(param);

        return html;
    },
    decorate: function(event, data){
        switch (event) {
            case 'ntf_userdailyreport':
            case 'ntf_usermonthlyreport':
                data.list = [];
                _.each(data.consumption.category, function(value, key, list){
                    data.list.push(value);
                });

                break;
            case 'ntf_projectdailyreport':
            case 'ntf_projectmonthlyreport':
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
            case 'ntf_projectarrears':
                var count = _.reduce(data.data, (pre, item) => {
                    return pre + item.count;
                }, 0);
                var balance = _.reduce(data.data, (pre, item) => {
                    return pre + item.balance;
                }, 0);
                data.sum = {
                    count: count,
                    balance: balance
                }
                break; 
            default:
                // statements_def
                break;
        }
        return data;
    }
};
