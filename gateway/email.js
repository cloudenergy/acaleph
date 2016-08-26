'use strict';
var emailComposer = require('../libs/email'),
    handlebars = require('handlebars'),  
    nodemailer = require('nodemailer');

var user = '古鸽云能源 <group@cloudenergy.me>';

var transporter = nodemailer.createTransport({
    port: 465,
    host: 'smtp.exmail.qq.com',
    secure: true,
    auth: {
        user: 'group@cloudenergy.me',
        pass: '51Cloudenergy'
    }
});

module.exports = exports = function(){};

exports.Init = function () {

};

exports.Send = function(target, msg){

    var event = msg.event,
        template = msg.template,
        event_data = msg.data,
        param = event_data.get('param'),
        ext = (template.email && template.email.ext) || 'xlsx',
        file = param.file;

    var title = emailComposer.title(event, template.title, param);
     var mailOptions = {
        from: user,
        to: target,
        subject: title,
        html: emailComposer.compile(event, {
            data: param,
            target: template.email.target || 'business'
        }),
    };

    // 附件
    if (file) {
        var file_name = template.title;
        if (template.email.title) {
            file_name = handlebars.compile(template.email.title)(param);
        }

        mailOptions.attachments = [
            {   // use URL as an attachment
                filename:  `${file_name}.${ext}`,
                path: file
            }
        ];
    }

    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return console.log('error: ', error, info);
        }
        console.log('Message sent: ' + JSON.stringify(info));
    });
};

