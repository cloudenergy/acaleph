'use strict';
var moment = require('moment');
var crypto = require('crypto');
var https = require('https');
var handlebars = require('handlebars');
var events = require('../libs/events');
var _ = require('underscore');

var SoftVersion = '2014-06-30';
var AccountSID = 'a864bd13ecf51aba30b8fc1e244fa004';
var AccountToken = '6f4af4712489742bf1ee818d4027030b';

var AppID = '2685c4d4d87a42d7b59fb92636469012';
var AppToken = 'e7748afd4a2e8754cef5332b3db18734';

module.exports = exports = function(){};

function MD5(plain)
{
    return crypto.createHash('md5').update(plain).digest('hex').toUpperCase();
}

function EncodeAuthorization(timeStamp)
{
    var plainAuth = AccountSID + ":" + timeStamp.format('YYYYMMDDHHmmss');
    //console.log(plainAuth);
    return new Buffer(plainAuth).toString('base64');
}

function PackageBody(to, message, eventName)
{
    var eventTemplate = events[eventName].sms;

    var body = {
        templateSMS: {
            "to": to,
            "appId": AppID,
            "templateId": eventTemplate.templateId,
            "param": handlebars.compile(eventTemplate.param)(message)
        }
    };
    return body;
}

exports.Send = function (message, eventName)
{
    if (!events[eventName]) {
        return;
    }

    let number = message && message.mobile;

    if(_.isEmpty(message)){
        return;
    }
    // return

    var timeStamp = moment();
    var plainSignature = AccountSID + AccountToken + timeStamp.format('YYYYMMDDHHmmss');
    var encryptSignature = MD5(plainSignature);
    var url = "/"+SoftVersion+"/Accounts/"+AccountSID+"/Messages/templateSMS?sig="+encryptSignature;

    try {
        var body = PackageBody(number, message, eventName);
        body = JSON.stringify(body);

        var contentLength = new Buffer(body).length;

        var Header = {
            "Accept": "application/json"
            , "Content-type": "application/json;charset=utf-8;"
            , "Content-Length": contentLength
            , "Authorization": EncodeAuthorization(timeStamp)
        };

        var options = {
            host: "api.ucpaas.com"
            , path: url
            , method: 'POST'
            , headers: Header
        };
    } catch(e) {
        // statements
        log.error('短信发送错误: ', number, message, data);
    } finally {
        // statements
    }
 

    var req = https.request(options, function(res){
        var data='';
        res.on('data', function(chunk){
            data += chunk;
        });
        res.on('end', function(){
            log.debug('SMS: ', number, message, data);
            var ret = {};
            try{
                ret = JSON.parse(data);
            }
            catch(e){
                return;
            }
            if(ret.resp.respCode != '000000'){
                log.error(body, ret);
            }
            else{
                log.info(body);
            }
        });
    });
    req.on('error', function(e){
        log.error(e);
    });
    req.write(body);
    req.end();
};