var email = require('emailjs'),
    emailComposer = require('../libs/email'),
    _ = require('underscore'),  
    nodemailer = require('nodemailer');

var user = "古鸽云能源 <group@cloudenergy.me>";

var transporter = nodemailer.createTransport({
    port: 465,
    host: "smtp.exmail.qq.com",
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
        event_data = msg.data,
        param = event_data.get('param'),
        file = param.file;

     var mailOptions = {
        from: user,
        to: target,
        subject: msg.template.title,
        html: emailComposer.compile(event, param),
    }

    // 附件
    if (file) {
        mailOptions.attachments = [
            {   // use URL as an attachment
                filename: '报表.xlsx',
                path: file
            }
        ]
    }

    // console.log('opt: ', mailOptions);

    // return
    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return console.log('error: ', error, info);
        }
        console.log('Message sent: ' + JSON.stringify(info));
    });
};

