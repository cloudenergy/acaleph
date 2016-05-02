var email = require('emailjs');
var _ = require('underscore');
var user = "group@cloudenergy.me";
var nodemailer = require('nodemailer');

module.exports = exports = function(){};

exports.Init = function () {

};

exports.Test = function ()
{
    var transporter = nodemailer.createTransport({
        port: 465,
        host: "smtp.exmail.qq.com",
        secure: true,
        auth: {
            user: 'group@cloudenergy.me',
            pass: '51Cloudenergy'
        }
    });

    var mailOptions = {
        from: user,
        to: "50923132@qq.com",
        subject: "test subject",
        html: "<html>i <i>hope</i> this works!</html>",
        text: 'file test',
        attachments: [
            {   // use URL as an attachment
                filename: '报表.xlsx',
                path: 'http://download.gugecc.com/%E6%9D%AD%E5%B7%9E%E4%B8%AD%E5%A4%A7%E9%93%B6%E6%B3%B0%E5%9F%8E_%E7%BB%93%E7%AE%97%E6%8A%A5%E8%A1%A8%202015%E5%B9%B412%E6%9C%88.xlsx'
                // path: 'https://raw.github.com/nodemailer/nodemailer/master/LICENSE'
            },
        ]
    };

    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return console.log(error);
        }
        console.log('Message sent: ' + info.response);
    });
};

exports.Send = function(target, message){
    var mailServer  = email.server.connect({
        user: user,
        password: "51Cloudenergy",
        host: "smtp.exmail.qq.com",
        port: 465,
        ssl: true
    });
    
    try{
        message = JSON.parse(message);
    }
    catch(e){
        message = {};
    }

    if(_.isEmpty(message)){
        return;
    }


    mailServer.send({
        attachment: message.attachment,
        text: message.content,
        from: user,
        to: target,
        subject: message.title
    }, function(err, message) {
        if(err){
            log.error(err, message);
        }
        log.info(message);
    });
};

