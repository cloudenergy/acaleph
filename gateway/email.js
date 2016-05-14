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

exports.Test = function ()
{

    var mailOptions = {
        from: user,
        to: "910599438@qq.com, luojieyy@gmail.com",
        subject: "test subject",
        html: "<html>i <i>hope</i> this works!</html>",
        text: 'file test',
        // attachments: [
        //     {   // use URL as an attachment
        //         filename: '报表.xlsx',
        //         path: 'http://download.gugecc.com/%E6%9D%AD%E5%B7%9E%E4%B8%AD%E5%A4%A7%E9%93%B6%E6%B3%B0%E5%9F%8E_%E7%BB%93%E7%AE%97%E6%8A%A5%E8%A1%A8%202015%E5%B9%B412%E6%9C%88.xlsx'
        //         // path: 'https://raw.github.com/nodemailer/nodemailer/master/LICENSE'
        //     },
        // ]
    };

    console.log('opt: ', mailOptions);

    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return console.log('error: ', error, info);
        }
        console.log('Message sent: ' + JSON.stringify(info));
    });
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

