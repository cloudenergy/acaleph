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

handlebars.registerHelper("date", function(timestamp) {
    return moment.unix(timestamp).format('YYYY-MM-DD HH:mm');
});

handlebars.registerHelper("length", function(obj) {
    log.warn('count the length for: ', obj);
    return Object.keys(obj).length;
});

handlebars.registerHelper("event", function(keyword) {
    switch (keyword) {
        case 'COMMUNICATION':
            return '通讯异常';
            break;
        case 'DATA':
            return '数据异常';
            break;
        default:
            return '通讯异常';
            break;
    }
});

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
