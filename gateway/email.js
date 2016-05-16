var email = require('emailjs');
var _ = require('underscore');
var user = "古鸽云能源 <group@cloudenergy.me>";
var nodemailer = require('nodemailer');

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
    var message = JSON.parse(msg);

     var mailOptions = {
        from: user,
        to: target,
        subject: message.title,
        html: message.content,
    }

    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return console.log('error: ', error, info);
        }
        console.log('Message sent: ' + JSON.stringify(info));
    });
};

