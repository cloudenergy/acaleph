var email = require('emailjs');
var _ = require('underscore');
var user = "group@cloudenergy.me";

var mailServer;

module.exports = exports = function(){};

exports.Init = function () {
    mailServer  = email.server.connect({
        user: user,
        password: "51Cloudenergy",
        host: "smtp.exmail.qq.com",
        port: 465,
        ssl: true
    });
};

exports.Send = function(target, message){
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

