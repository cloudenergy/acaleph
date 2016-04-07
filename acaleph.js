var include = require('include-node');
var appRootPath = require('app-root-path');
var logger = require(appRootPath.path + '/libs/log')('acaleph');
var express = require('express');
var cookieParser = require('cookie-parser');
var app = express();

var _ = require('underscore');
var config = require('config');
var mongodb = require('./libs/mongodb');
var apiUtil = require('./api/apiUtil');
var moment = require('moment');
var url = require('url');

var crypto = require('crypto');
var moment = require('moment');

var wechat = Include('/gateway/wechat');
var email = Include('/gateway/email');
var sms = Include('/gateway/sms');
var push = Include('/gateway/push');

wechat.Init();
email.Init();

require('./api')(app);
mongodb(function(){

    var Retry = function()
    {
        setTimeout(function(){
            setTimeout(function(){
                //
                DoFetch();
            }, 1000);
        }, 0);
    };

    var DoFetch = function()
    {
        //获取事件进行处理
        mongodb.Event
            .find({})
            .limit(50)
            .sort({timestamp: 1})
            .exec(function(err, data){
                if(!data || data.length ==0 || err){
                    return Retry();
                }
                else{
                    //
                    ProcessEvents(data);
                    //Remove data
                }
            });
    };

    var ProcessEvents = function(events){
        //
        var removeIDs = [];

        _.each(events, function(event){
            removeIDs.push(event._id);

            switch(event.gateway){
                case 'WECHAT':
                    wechat.Send(event.target, event.message);
                    break;
                case 'EMAIL':
                    email.Send(event.target, event.message);
                    break;
                case 'SMS':
                    sms.Send(event.target, event.message);
                case 'PUSH':
                    push.Send(event.target, event.message);
                    break;
            }
        });

        mongodb.Event.remove({_id:{$in: removeIDs}}, function(err){
            DoFetch();
        });
    };

    Retry();
});

var server = app.listen(config.port, function(){
    log.info('listening at %s', server.address().port);
});


//var email = Include('/gateway/email');
//email.Init();
//email.Send('50923132@qq.com', "testing emailjs", "Acaleph Email TestNew LIne\n    ZZZZ");

//var sms = Include('/gateway/sms');
//sms.Send();