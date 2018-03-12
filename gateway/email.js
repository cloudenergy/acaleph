'use strict';
var emailComposer = require('../libs/email'),
    handlebars = require('handlebars'),  
    nodemailer = require('nodemailer');
var config = require('config');
var path = require('path');

var user = '智慧云能源 <group@cloudenergy.me>';

var transporter = nodemailer.createTransport({
    port: 465,
    host: 'smtp.exmail.qq.com',
    secure: true,
    auth: {
        user: 'group@cloudenergy.me',
        pass: 'BJVPVJd44qnPAy5M'
    }
});

module.exports = exports = function(){};

exports.Init = function () {

};

exports.Send = function(target, msg){

    var event = msg.event,
        template = msg.template,
        event_data = msg.data,
        param = event_data.param,
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

        var fileExt = path.extname(file);

        var attachmentPath = path.join(config.attachmentpath, file);
        mailOptions.attachments = [
            {   // use URL as an attachment
                filename:  `${file_name}.${fileExt}`,
                path: attachmentPath
            }
        ];
    }

    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return log.error('send mail error: ', error, info);
        }
        log.info('mail send: ', user, target, info, msg);
    });
};

// const mailOptions = {
//     from: user,
//     to: "50923132@qq.com",
//     subject: 'Test Email',
//     html: "TestEmail"
// };
// transporter.sendMail(mailOptions, function(error, info){
//     if(error){
//         return log.error('send mail error: ', error, info);
//     }
// });